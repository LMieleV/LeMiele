# V.A.U.L.T — your personal vault, made simple

Everything you tell it is filed into one of **five pillars**, each a plain
markdown file you can open, read, and version forever:

| | Pillar | File | What lives there |
|---|--------|------|------------------|
| **V** | Vision | `wiki/goals.md` | Goals & active projects |
| **A** | Achievements | `wiki/achievements.md` | Wins & milestones, by month |
| **U** | Understanding | `wiki/index.md` + topic pages | Knowledge, one page per topic |
| **L** | Log | `wiki/decisions.md` + `wiki/log.md` | Why (decisions) and when (history) |
| **T** | Tasks | `wiki/pending.md` | Inbox, next actions, waiting, scheduled |

Two queues feed the pillars: `wiki/ideas.md` (someday/maybe) and
`wiki/reading-list.md` (sources to ingest).

## How it operates — three moves

1. **Say it.** In any Claude session on this repo, just talk:
   - `capture: call the supplier about the Q3 contract`
   - `done: send the report`
   - `log achievement: shipped the procurement site`
   - `log decision: we build on plain markdown`
   - `ingest raw/some-file.md`
   - …or ask any question — it answers from the vault.
2. **It's filed.** The vault writes it into the right pillar, cross-links it,
   and appends a line to the history log. Nothing falls through.
3. **Review weekly.** Say `weekly review` — the inbox is triaged to zero,
   goals are checked for next actions, wins are celebrated, the reading
   queue is fed, and the vault lints itself.

## The visual deck

Open `index.html` in a browser — it's the whole vault as a clickable deck in
the style of the Etex site. Every card is a markdown file; click it to read
the rendered file, toggle raw view, and follow `[[wikilinks]]` between pages.
A **"What's missing"** panel shows, at a glance, what needs attention:
inbox items to triage, overdue tasks, goals without a next action, queued
reading, and when the next weekly review is due.

For live data, serve the folder (otherwise the page uses its embedded
snapshots):

```
python3 -m http.server
# → http://localhost:8000
```

## Rules of the house

- `raw/` is immutable — humans drop sources there, the LLM only reads them.
- `wiki/` is LLM-owned — created, updated, and cross-linked automatically.
- History is append-only: decisions are superseded, never rewritten.
- The full schema and workflows live in `CLAUDE.md`.
