const API = process.env.API_URL_INTERNAL ?? "http://localhost:4000";

interface Check {
  obligationId: string;
  title: string;
  source: string;
  status: "ok" | "due_soon" | "overdue" | "not_applicable";
  detail: string;
}

interface Relationship {
  id: string;
  kind: string;
  displayName: string;
  riskRating: string | null;
  nextReviewDue: string | null;
}

async function fetchJson<T>(path: string): Promise<T | null> {
  try {
    const res = await fetch(`${API}${path}`, { cache: "no-store" });
    if (!res.ok) return null;
    return (await res.json()) as T;
  } catch {
    return null;
  }
}

export default async function Dashboard() {
  const checks = await fetchJson<{ results: Check[] }>("/checks");
  const rels = await fetchJson<{ relationships: Relationship[] }>("/relationships");
  const audit = await fetchJson<{ valid: boolean; entries: number }>("/audit/verify");

  return (
    <>
      <section className="panel">
        <h2>Continuous Monitor — Demo ManCo S.à r.l.</h2>
        {checks ? (
          <table>
            <thead>
              <tr><th>Obligation</th><th>Source</th><th>Status</th><th>Detail</th></tr>
            </thead>
            <tbody>
              {checks.results.map((c) => (
                <tr key={c.obligationId}>
                  <td>{c.title}</td>
                  <td className="note">{c.source}</td>
                  <td><span className={`status ${c.status}`}>{c.status.replace("_", " ")}</span></td>
                  <td className="note">{c.detail}</td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p className="note">API unreachable — is `docker compose up` running?</p>
        )}
      </section>

      <section className="panel">
        <h2>Monitored Relationships</h2>
        {rels ? (
          <table>
            <thead>
              <tr><th>Name</th><th>Kind</th><th>Risk</th><th>Next review</th></tr>
            </thead>
            <tbody>
              {rels.relationships.map((r) => (
                <tr key={r.id}>
                  <td>{r.displayName}</td>
                  <td className="note">{r.kind}</td>
                  <td>{r.riskRating ?? "—"}</td>
                  <td className="note">{r.nextReviewDue?.slice(0, 10) ?? "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p className="note">No data.</p>
        )}
      </section>

      <section className="panel">
        <h2>Evidence Room — audit chain</h2>
        {audit ? (
          <p>
            <span className={`status ${audit.valid ? "ok" : "overdue"}`}>
              {audit.valid ? "chain valid" : "chain broken"}
            </span>{" "}
            <span className="note">{audit.entries} hash-chained audit entries — independently verifiable.</span>
          </p>
        ) : (
          <p className="note">No data.</p>
        )}
      </section>
    </>
  );
}
