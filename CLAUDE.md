# V.A.U.L.T — Schema & Workflow

This repository implements [Karpathy's LLM-wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) extended into a full personal vault: an LLM-maintained knowledge base that compounds over time instead of re-processing raw sources on every query, plus the productivity surfaces found in best-in-class vaults (Obsidian, Notion, Logseq).

The vault is organized as **V.A.U.L.T — five pillars**, one file each:

| Pillar | File | What lives there |
|--------|------|------------------|
| **V** — Vision | `wiki/goals.md` | Goals & active projects |
| **A** — Achievements | `wiki/achievements.md` | Wins & milestones, by month |
| **U** — Understanding | `wiki/index.md` + topic pages | Knowledge, one page per topic |
| **L** — Log | `wiki/decisions.md` + `wiki/log.md` | Why (decisions) and when (history) |
| **T** — Tasks | `wiki/pending.md` | Inbox, next actions, waiting, scheduled |

Two queues feed the pillars: `wiki/ideas.md` (someday/maybe) and `wiki/reading-list.md` (sources to ingest). `index.html` at the repo root is the visual front door — a clickable deck where every markdown file opens in a reader.

## Directory Layout

```
index.html  ← V.A.U.L.T site: clickable deck over the wiki (zero-dependency, single file)
weekly.html ← GENERATED weekly digest: the whole vault as of the last build
tools/build_vault.py ← rebuilds index.html's manifest/snapshots and weekly.html
.github/workflows/weekly-vault.yml ← runs the build every Monday and commits
README.md   ← plain-language guide to using the vault
raw/        ← immutable source documents (never modified by the LLM)
wiki/       ← LLM-owned markdown knowledge base
  index.md  ← the Understanding pillar: pillar map + knowledge-page catalog
  log.md    ← append-only chronological record
  pending.md      ← pending items: inbox + triaged next actions (GTD-style)
  achievements.md ← achievements vault: wins, milestones, shipped work
  goals.md        ← goals & active projects the vault is serving
  decisions.md    ← decision log (lightweight ADR pattern)
  ideas.md        ← someday/maybe parking lot
  reading-list.md ← queued sources and resources to ingest
  <topic>.md      ← one page per entity, concept, or summary
CLAUDE.md   ← this file; defines schema and workflows
```

## Core Operations

### INGEST

Trigger: "ingest `raw/<file>`" or "ingest all new sources"

Steps:
1. Read the source file(s) in `raw/`.
2. Identify key entities, concepts, claims, and data points.
3. Discuss the top 3–5 takeaways briefly.
4. Create or update the relevant wiki page(s) in `wiki/`:
   - Add a **Summary** section with a 2–4 sentence abstract.
   - Add or update **Key Points** as a bullet list.
   - Add **Cross-references** to other wiki pages that are related.
   - Add **Source** citation at the bottom: `Source: raw/<filename>`.
5. Update `wiki/index.md`:
   - Add the new page under the appropriate category.
   - If no category fits, create one.
6. Append to `wiki/log.md`:
   ```
   [INGEST] YYYY-MM-DD — <source file> → <wiki page(s) created/updated>
   ```

### QUERY

Trigger: any question asked against the knowledge base

Steps:
1. Identify which wiki pages are relevant to the question.
2. Read those pages (do **not** re-read raw sources unless the wiki is missing critical detail).
3. Synthesize an answer and cite the wiki pages used: `(→ wiki/<page>.md)`.
4. If the answer is substantive and reusable, offer to file it as a new wiki page.

### CAPTURE

Trigger: "capture: <item>", "add pending item", "remind me to <x>", or any task/commitment surfacing mid-conversation

Steps:
1. Append the item to the **Inbox** section of `wiki/pending.md` using the pending-item format (see below). Capture first, organize later — never lose an item because triage felt like work.
2. If the item clearly belongs to a project or topic, link it: `from: [[<page>]]`.
3. Append to `wiki/log.md`: `[CAPTURE] YYYY-MM-DD — <item>`

### TRIAGE

Trigger: "triage the inbox" or automatically when the Inbox exceeds ~10 items

Steps:
1. Move each Inbox item into **Next actions**, **Waiting on**, **Scheduled**, or demote it to `wiki/ideas.md` (someday/maybe) or delete it (no longer relevant).
2. Assign priority (`⏫ high / 🔼 normal / 🔽 low`) and a due date where one exists.
3. Update the counts line at the top of `wiki/pending.md`.

### COMPLETE

Trigger: "done: <item>" or noticing an item was finished

Steps:
1. Check the box and move the item to the **Recently completed** section of `wiki/pending.md` with a completion date (`✅ YYYY-MM-DD`).
2. If the item is a milestone worth remembering (shipped something, closed a goal, external recognition), also run **ACHIEVE**.
3. Append to `wiki/log.md`: `[DONE] YYYY-MM-DD — <item>`
4. During REVIEW, prune **Recently completed** entries older than 30 days (they survive in `log.md`).

### ACHIEVE

Trigger: "log achievement: <x>", COMPLETE of a milestone item, or a clear win surfacing in conversation

Steps:
1. Add an entry to `wiki/achievements.md` under the current year/month using the achievement format: what was achieved, why it mattered (impact), and links to related pages.
2. Append to `wiki/log.md`: `[ACHIEVE] YYYY-MM-DD — <achievement>`

### DECIDE

Trigger: "log decision: <x>" or a significant choice being settled in conversation

Steps:
1. Add an entry to `wiki/decisions.md`: date, decision, context, options considered, rationale, and status (`accepted` / `superseded by <entry>`).
2. Append to `wiki/log.md`: `[DECIDE] YYYY-MM-DD — <decision>`

### REVIEW (weekly)

Trigger: "weekly review" or "review the vault"

Steps:
1. **Sweep pending**: triage the Inbox to zero; flag overdue and stale (>30 days untouched) items; prune old **Recently completed** entries.
2. **Check goals**: for each active goal in `wiki/goals.md`, note progress and confirm at least one next action exists in `wiki/pending.md`; park stalled goals explicitly.
3. **Celebrate**: scan the week's `[DONE]` log entries and promote anything achievement-worthy to `wiki/achievements.md`.
4. **Feed the queue**: check `wiki/reading-list.md` — anything read gets ingested, anything obsolete gets dropped.
5. Run **LINT** (below).
6. Append to `wiki/log.md`: `[REVIEW] YYYY-MM-DD — <one-line summary of the week>`
7. Run **BUILD** (below) so `weekly.html` captures the reviewed state.

### BUILD

Trigger: after any wiki change, at the end of REVIEW, or "rebuild the site"

Steps:
1. Run `python3 tools/build_vault.py` (no dependencies). It regenerates:
   - the `FILES` manifest and embedded snapshot blocks in `index.html` — new topic pages
     appear in the deck automatically, with title and description derived from the page itself;
   - `weekly.html` — a dated, self-contained digest of the whole vault.
2. Never hand-edit the regions marked `BUILD:FILES` or `BUILD:SNAPSHOTS` in `index.html`,
   or `weekly.html` at all — the next build overwrites them.
3. `python3 tools/build_vault.py --check` exits non-zero when outputs are stale (used by CI).

### LINT

Trigger: "lint the wiki" or periodic health check

Steps:
1. Read `wiki/index.md` and all wiki pages.
2. Report:
   - **Contradictions**: claims in different pages that conflict.
   - **Orphan pages**: pages not linked from `index.md` or any cross-reference.
   - **Broken cross-references**: links pointing to pages that don't exist.
   - **Stale claims**: pages whose sources may have been superseded.
   - **Data gaps**: topics mentioned in cross-references but lacking their own page.
3. For each issue found, propose a fix and ask whether to apply it.

---

## Wiki Page Format

Each `wiki/<topic>.md` follows this template:

```markdown
# <Topic Name>

## Summary
<2–4 sentence abstract of what this page covers>

## Key Points
- <point 1>
- <point 2>
- ...

## Cross-references
- [[<related topic>]] — <one-line reason for the link>

## Sources
- `raw/<filename>` — <brief description of this source>
```

## Pending Item Format (`wiki/pending.md`)

One checkbox line per item, Obsidian-Tasks-style inline fields (only the ones that apply):

```markdown
- [ ] <action, starting with a verb> ⏫ 📅 2026-07-24 · from: [[<page>]] · waiting-on: <who>
```

- Priority: `⏫` high · `🔼` normal (default, may be omitted) · `🔽` low
- `📅 YYYY-MM-DD` — due date; `✅ YYYY-MM-DD` — completion date (added on COMPLETE)
- Sections in order: **Inbox** → **Next actions** → **Waiting on** → **Scheduled** → **Recently completed**

## Achievement Format (`wiki/achievements.md`)

Grouped by year, then month, newest first:

```markdown
### 🏆 <achievement title> — YYYY-MM-DD
**What:** <one or two sentences on what was accomplished>
**Impact:** <why it mattered — outcome, numbers, recognition>
**Links:** [[<related page>]]
```

## Decision Format (`wiki/decisions.md`)

```markdown
### YYYY-MM-DD — <decision title>  `accepted`
**Context:** <what forced the choice>
**Options:** <alternatives considered>
**Decision & rationale:** <what was chosen and why>
```

Status is `accepted` until superseded — never edit history; add a new entry and mark the old one `superseded by <new entry>`.

## Index Format (`wiki/index.md`)

Starts with the **five-pillar map** (the V.A.U.L.T table linking goals, achievements, decisions, log, and pending), then a **Queues** section (ideas, reading list), then the **Knowledge pages** catalog organized by category. Each catalog entry: `- [[<topic>]] — <one-line description>`. Ends with a `*Last updated: YYYY-MM-DD*` line.

## Log Format (`wiki/log.md`)

Append-only. Newest entries at the bottom. Parseable prefixes:

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
| `[BUILD]` | The site and weekly digest were rebuilt |

---

## Conventions

- The LLM **reads** `raw/` but **never modifies** it.
- The LLM **owns** `wiki/` entirely: creates, updates, and cross-links pages.
- Humans **read** `wiki/` and **curate** `raw/`.
- Cross-references use `[[page-name]]` notation (filename without `.md`). These are the edges in the site's graph view and drive its "Linked mentions" (backlinks) panel — link generously.
- Tags are Obsidian-style inline `#tag` words (hierarchies allowed: `#vault/pillar`). Put them on their own line under the page intro. They become filter chips in the deck.
- All dates use `YYYY-MM-DD` format.
- Keep pages focused: one entity or concept per page. Use cross-references rather than duplicating content.
- `index.html` reads the live `wiki/*.md` files when served over HTTP and falls back to embedded snapshots when opened from disk. **Never hand-edit those snapshots or the `FILES` manifest** — run **BUILD** (`python3 tools/build_vault.py`) after any wiki change and it regenerates both, plus `weekly.html`.
