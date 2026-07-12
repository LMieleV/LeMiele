import { createHash } from "node:crypto";
import type { Pool } from "pg";

// Append-only, hash-chained audit log. Each entry's hash covers the previous
// entry's hash, so any tampering breaks the chain verifiably — an inspector
// can re-walk the chain independently of Kloer.
export async function appendAudit(
  pool: Pool,
  tenantId: string,
  actor: string,
  action: string,
  payload: unknown,
): Promise<void> {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    const prev = await client.query(
      "SELECT hash FROM audit_log ORDER BY seq DESC LIMIT 1 FOR UPDATE",
    );
    const prevHash: string = prev.rows[0]?.hash ?? "GENESIS";
    const body = JSON.stringify({ tenantId, actor, action, payload, prevHash });
    const hash = createHash("sha256").update(body).digest("hex");
    await client.query(
      `INSERT INTO audit_log (tenant_id, actor, action, payload, prev_hash, hash)
       VALUES ($1, $2, $3, $4, $5, $6)`,
      [tenantId, actor, action, JSON.stringify(payload), prevHash, hash],
    );
    await client.query("COMMIT");
  } catch (err) {
    await client.query("ROLLBACK");
    throw err;
  } finally {
    client.release();
  }
}

export async function verifyChain(pool: Pool): Promise<{ valid: boolean; entries: number }> {
  const { rows } = await pool.query(
    "SELECT tenant_id, actor, action, payload, prev_hash, hash FROM audit_log ORDER BY seq",
  );
  let prevHash = "GENESIS";
  for (const row of rows) {
    const body = JSON.stringify({
      tenantId: row.tenant_id,
      actor: row.actor,
      action: row.action,
      payload: row.payload,
      prevHash,
    });
    const expected = createHash("sha256").update(body).digest("hex");
    if (row.prev_hash !== prevHash || row.hash !== expected) {
      return { valid: false, entries: rows.length };
    }
    prevHash = row.hash;
  }
  return { valid: true, entries: rows.length };
}
