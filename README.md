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

## The visual deck — `index.html`

Open `index.html` in a browser: the whole vault as a clickable deck, with the
Obsidian moves you'd expect, minus the app.

- **Every card is a file** — click to read it rendered, toggle raw markdown,
  step through files with ← →.
- **Quick search (⌘K / Ctrl-K)** — Obsidian's quick switcher: type anything and
  it searches every file, task, win and decision, with matching lines in
  context. ↑↓ to move, Enter to open.
- **Graph view** — every page a node, every `[[wikilink]]` an edge. Drag nodes,
  hover to spotlight a page's neighbours, click to read.
- **Linked mentions** — each page shows its backlinks: who points here, and the
  line they said it in.
- **Tags** — `#tags` written anywhere in a page become filter chips over the deck
  (hierarchies like `#vault/pillar` work too).
- **"What's missing"** — computed live from the markdown: inbox to triage,
  overdue tasks, goals without a next action, queued reading, review due.

For live data, serve the folder (otherwise the page uses its embedded
snapshots):

```
python3 -m http.server
# → http://localhost:8000
```

## The weekly digest — `weekly.html`

A dated, self-contained snapshot of **everything you have**: the week's
activity from the log, every open loop, and the full text of every page —
one file, no server, prints cleanly, safe to mail to yourself.

It rebuilds automatically every Monday (and on every push that touches the
vault) via `.github/workflows/weekly-vault.yml`. To rebuild it yourself:

```
python3 tools/build_vault.py            # rebuild weekly.html + index.html
python3 tools/build_vault.py --check    # CI mode: fail if out of date
```

The same script regenerates `index.html`'s file manifest and offline
snapshots, so a new topic page shows up in the deck on its own — never edit
those regions by hand.

## Rules of the house

- `raw/` is immutable — humans drop sources there, the LLM only reads them.
- `wiki/` is LLM-owned — created, updated, and cross-linked automatically.
- History is append-only: decisions are superseded, never rewritten.
- The full schema and workflows live in `CLAUDE.md`.
