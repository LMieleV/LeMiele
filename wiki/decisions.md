# Decision Log

Significant choices, recorded so future-you knows *why* — not just *what*. Lightweight ADR pattern; never edit history, supersede instead.

#decisions #adr #vault/pillar

### 2026-07-17 — Extend the wiki into a full vault with plain-markdown features  `accepted`
**Context:** The wiki had knowledge pages but no way to track open loops, wins, or goals — items raised in conversation were being lost between sessions.
**Options:** (a) adopt an external tool (Obsidian/Notion) alongside the wiki; (b) extend the wiki itself with vault pages; (c) keep the wiki knowledge-only.
**Decision & rationale:** (b) — everything stays in one git-versioned, LLM-operable markdown vault; the best-of-market features (pending items, achievements, reviews) are conventions, not software, so they port cleanly.

### 2026-07-19 — Organize the vault as V.A.U.L.T with a clickable deck front-end  `accepted`
**Context:** The vault's layout and operation weren't clear — many files, no obvious structure, and no way to browse them visually alongside the initial Etex website.
**Options:** (a) keep the flat file list and improve docs only; (b) reorganize around a memorable five-pillar scheme (V.A.U.L.T) plus a single-file website in the style of the Etex procurement site.
**Decision & rationale:** (b) — V.A.U.L.T (Vision, Achievements, Understanding, Log, Tasks) gives every file one obvious home, and `index.html` makes each file clickable and shows what's missing at a glance, in the same visual language as the initial website.

### 2026-08-04 — Generate the site and a weekly digest from the markdown  `accepted`
**Context:** Two gaps: the site's offline snapshots and file manifest had to be hand-maintained (they drift), and there was no periodic snapshot of the vault as a whole — nothing to read, print, or mail once a week.
**Options:** (a) keep hand-editing `index.html` and skip the digest; (b) adopt a static-site generator (Eleventy/Hugo) and a Node toolchain; (c) one dependency-free Python script that regenerates the generated regions of `index.html` plus a standalone `weekly.html`, run on a weekly GitHub Actions cron.
**Decision & rationale:** (c) — keeps the zero-dependency, single-file character of the vault (nothing to install, works offline), removes the drift risk by construction, and the weekly cron makes the digest a rhythm rather than a chore. A generator would have bought templating we don't need at the price of a toolchain.

### 2026-08-04 — Mirror Obsidian's core reflexes in the site  `accepted`
**Context:** The vault holds Obsidian-shaped content (wikilinks, tags, tasks) but the site only browsed files — none of the moves that make Obsidian fast.
**Options:** (a) tell people to open the folder in Obsidian; (b) rebuild the vault inside Obsidian's format (plugins, config, `.obsidian/`); (c) implement the four reflexes that matter — quick switcher, graph view, backlinks, tag filters — directly in the page.
**Decision & rationale:** (c) — the vault stays plain markdown that Obsidian can still open, while the site works for anyone with a browser and no app installed. Backlinks and the graph fall out of the `[[wikilink]]` data we already keep, so they cost no new schema.

## Cross-references
- [[log]] — every decision also gets a `[DECIDE]` log line
