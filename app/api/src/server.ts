import Fastify from "fastify";
import cors from "@fastify/cors";
import pg from "pg";
import { runChecks, loadRulebook } from "./rulebook/evaluate.js";
import { appendAudit, verifyChain } from "./audit/auditLog.js";
import { createGateway } from "./ai/gateway.js";

const DEMO_TENANT = "00000000-0000-0000-0000-000000000001";

const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
const ai = createGateway();
const app = Fastify({ logger: true });
await app.register(cors, { origin: true });

app.get("/health", async () => ({ ok: true, service: "kloer-api" }));

// Rulebook: the versioned obligation library itself.
app.get("/obligations", async () => ({ rulebook: loadRulebook() }));

// Continuous Monitor: run deterministic checks for the demo tenant.
app.get("/checks", async () => {
  const results = await runChecks(pool, DEMO_TENANT);
  return { tenantId: DEMO_TENANT, results };
});

app.get("/relationships", async () => {
  const { rows } = await pool.query(
    `SELECT id, kind, display_name AS "displayName", risk_rating AS "riskRating",
            next_review_due AS "nextReviewDue"
       FROM relationships WHERE tenant_id = $1 ORDER BY next_review_due`,
    [DEMO_TENANT],
  );
  return { relationships: rows };
});

app.get("/kyc-files", async () => {
  const { rows } = await pool.query(
    `SELECT k.id, k.status, k.draft_memo AS "draftMemo",
            r.display_name AS "relationshipName", r.risk_rating AS "riskRating"
       FROM kyc_files k JOIN relationships r ON r.id = k.relationship_id
      WHERE k.tenant_id = $1 ORDER BY k.created_at DESC`,
    [DEMO_TENANT],
  );
  return { kycFiles: rows };
});

// KYC Studio: draft the review memo from the evidence graph (AI drafts, humans approve).
app.post<{ Params: { id: string } }>("/kyc-files/:id/draft", async (req, reply) => {
  const { rows } = await pool.query(
    `SELECT k.id, r.display_name AS name, coalesce(r.risk_rating, 'medium') AS risk
       FROM kyc_files k JOIN relationships r ON r.id = k.relationship_id
      WHERE k.id = $1 AND k.tenant_id = $2`,
    [req.params.id, DEMO_TENANT],
  );
  if (!rows.length) return reply.code(404).send({ error: "kyc file not found" });

  const ev = await pool.query(
    `SELECT id, kind, extracted->>'summary' AS summary
       FROM evidence WHERE kyc_file_id = $1 AND tenant_id = $2`,
    [req.params.id, DEMO_TENANT],
  );
  const evidence = ev.rows.length
    ? ev.rows
    : [{ id: rows[0].id, kind: "register_extract", summary: "seed evidence" }];

  const memo = await ai.draftKycMemo({
    relationshipName: rows[0].name,
    riskRating: rows[0].risk,
    evidence,
  });

  await pool.query(
    `UPDATE kyc_files SET draft_memo = $1, status = 'drafted' WHERE id = $2`,
    [JSON.stringify(memo), req.params.id],
  );
  await appendAudit(pool, DEMO_TENANT, "system:ai-gateway", "kyc_memo_drafted", {
    kycFileId: req.params.id,
    sections: memo.length,
  });
  return { id: req.params.id, status: "drafted", memo };
});

// 4-eyes approval with immutable audit entry.
app.post<{ Params: { id: string }; Body: { approver: string } }>(
  "/kyc-files/:id/approve",
  async (req, reply) => {
    const approver = req.body?.approver ?? "approver@demo-manco.lu";
    const { rowCount } = await pool.query(
      `UPDATE kyc_files SET status = 'approved', approved_at = now()
        WHERE id = $1 AND tenant_id = $2 AND status IN ('drafted', 'in_review')`,
      [req.params.id, DEMO_TENANT],
    );
    if (!rowCount) return reply.code(409).send({ error: "file not in approvable state" });
    await appendAudit(pool, DEMO_TENANT, approver, "kyc_file_approved", {
      kycFileId: req.params.id,
    });
    return { id: req.params.id, status: "approved" };
  },
);

// Evidence Room: independently verifiable audit chain.
app.get("/audit/verify", async () => verifyChain(pool));

const port = Number(process.env.PORT ?? 4000);
await app.listen({ port, host: "0.0.0.0" });
