# Decision Log

Significant choices, recorded so future-you knows *why* — not just *what*. Lightweight ADR pattern; never edit history, supersede instead.

### 2026-07-17 — Extend the wiki into a full vault with plain-markdown features  `accepted`
**Context:** The wiki had knowledge pages but no way to track open loops, wins, or goals — items raised in conversation were being lost between sessions.
**Options:** (a) adopt an external tool (Obsidian/Notion) alongside the wiki; (b) extend the wiki itself with vault pages; (c) keep the wiki knowledge-only.
**Decision & rationale:** (b) — everything stays in one git-versioned, LLM-operable markdown vault; the best-of-market features (pending items, achievements, reviews) are conventions, not software, so they port cleanly.

### 2026-07-19 — Organize the vault as V.A.U.L.T with a clickable deck front-end  `accepted`
**Context:** The vault's layout and operation weren't clear — many files, no obvious structure, and no way to browse them visually alongside the initial Etex website.
**Options:** (a) keep the flat file list and improve docs only; (b) reorganize around a memorable five-pillar scheme (V.A.U.L.T) plus a single-file website in the style of the Etex procurement site.
**Decision & rationale:** (b) — V.A.U.L.T (Vision, Achievements, Understanding, Log, Tasks) gives every file one obvious home, and `index.html` makes each file clickable and shows what's missing at a glance, in the same visual language as the initial website.

## Cross-references
- [[log]] — every decision also gets a `[DECIDE]` log line
