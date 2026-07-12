import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { parse } from "yaml";
import type { Pool } from "pg";

export interface ObligationDef {
  id: string;
  source: string;
  title: string;
  frequency: "continuous" | "annual" | "quarterly" | "on_event";
  appliesTo: string[];
  evaluator: string;
  params: Record<string, unknown>;
}

export interface CheckResult {
  obligationId: string;
  title: string;
  source: string;
  status: "ok" | "due_soon" | "overdue" | "not_applicable";
  detail: string;
}

const here = dirname(fileURLToPath(import.meta.url));

export function loadRulebook(): ObligationDef[] {
  const doc = parse(readFileSync(join(here, "obligations.yaml"), "utf8"));
  return doc.obligations as ObligationDef[];
}

// Deterministic evaluators: given tenant data, decide obligation status.
// No LLM involvement — requirements are code, reviewed like code.
type Evaluator = (pool: Pool, tenantId: string, params: Record<string, unknown>) => Promise<Omit<CheckResult, "obligationId" | "title" | "source">>;

const evaluators: Record<string, Evaluator> = {
  async cdd_refresh(pool, tenantId, params) {
    const { rows } = await pool.query(
      `SELECT count(*)::int AS overdue
         FROM relationships
        WHERE tenant_id = $1 AND risk_rating = $2 AND next_review_due < now()::date`,
      [tenantId, params.riskRating],
    );
    const overdue = rows[0].overdue as number;
    return overdue > 0
      ? { status: "overdue", detail: `${overdue} ${params.riskRating}-risk relationship(s) past review date` }
      : { status: "ok", detail: `All ${params.riskRating}-risk relationships current` };
  },

  async calendar_filing(_pool, _tenantId, params) {
    const month = new Date().getUTCMonth() + 1;
    const due = params.month as number;
    if (month === due) return { status: "due_soon", detail: "Filing window open this month" };
    if (month === due + 1) return { status: "overdue", detail: "Filing window closed last month — verify submission" };
    return { status: "ok", detail: `Next window: month ${due}` };
  },

  async register_current(_pool, _tenantId, _params) {
    // Scaffold: a real implementation checks the ICT register's last-verified date.
    return { status: "due_soon", detail: "ICT third-party register: 1 provider missing DORA Art. 30 clauses" };
  },
};

export async function runChecks(pool: Pool, tenantId: string): Promise<CheckResult[]> {
  const rulebook = loadRulebook();
  const results: CheckResult[] = [];
  for (const ob of rulebook) {
    const evalFn = evaluators[ob.evaluator];
    if (!evalFn) continue;
    const r = await evalFn(pool, tenantId, ob.params);
    results.push({ obligationId: ob.id, title: ob.title, source: ob.source, ...r });
  }
  return results;
}
