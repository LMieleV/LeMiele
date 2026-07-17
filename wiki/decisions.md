# Decision Log

Significant choices, recorded so future-you knows *why* — not just *what*. Lightweight ADR pattern; never edit history, supersede instead.

### 2026-07-17 — Extend the wiki into a full vault with plain-markdown features  `accepted`
**Context:** The wiki had knowledge pages but no way to track open loops, wins, or goals — items raised in conversation were being lost between sessions.
**Options:** (a) adopt an external tool (Obsidian/Notion) alongside the wiki; (b) extend the wiki itself with vault pages; (c) keep the wiki knowledge-only.
**Decision & rationale:** (b) — everything stays in one git-versioned, LLM-operable markdown vault; the best-of-market features (pending items, achievements, reviews) are conventions, not software, so they port cleanly.

## Cross-references
- [[log]] — every decision also gets a `[DECIDE]` log line
