# Wiki Log

Append-only chronological record. Newest entries at the bottom.

| Prefix | Meaning |
|--------|---------|
| `[INGEST]` | A new source was processed |
| `[QUERY]` | A query was filed as a wiki page |
| `[LINT]` | A lint run was completed |
| `[UPDATE]` | An existing wiki page was revised |
| `[CAPTURE]` | A pending item was added to the inbox |
| `[DONE]` | A pending item was completed |
| `[ACHIEVE]` | An achievement was recorded |
| `[DECIDE]` | A decision was logged |
| `[REVIEW]` | A weekly review was completed |

---

[INGEST] 2026-06-05 — Wiki initialized. Directory structure created: `raw/`, `wiki/`. Schema defined in `CLAUDE.md`.
[UPDATE] 2026-07-17 — Vault features added: `pending.md`, `achievements.md`, `goals.md`, `decisions.md`, `ideas.md`, `reading-list.md`; new operations (CAPTURE, TRIAGE, COMPLETE, ACHIEVE, DECIDE, REVIEW) defined in `CLAUDE.md`; `index.md` upgraded to a dashboard.
[DECIDE] 2026-07-17 — Extend the wiki into a full vault with plain-markdown features (see `decisions.md`).
[ACHIEVE] 2026-07-17 — Personal vault upgraded to best-in-class feature set (see `achievements.md`).
[DECIDE] 2026-07-19 — Organize the vault as V.A.U.L.T: five pillars (Vision, Achievements, Understanding, Log, Tasks) with a clickable deck front-end (see `decisions.md`).
[UPDATE] 2026-07-19 — V.A.U.L.T site added at `index.html` (deck of clickable MD files, reader, "what's missing" panel); `README.md` guide added; `wiki/index.md` restructured around the five pillars.
[ACHIEVE] 2026-06-05 — Vault initialized (backfilled 2026-07-19 to match `achievements.md`; entry was missing when the achievement was recorded).
