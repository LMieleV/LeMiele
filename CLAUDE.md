# LLM Wiki — Schema & Workflow

This repository implements [Karpathy's LLM-wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f): an LLM-maintained knowledge base that compounds over time instead of re-processing raw sources on every query.

## Directory Layout

```
raw/        ← immutable source documents (never modified by the LLM)
wiki/       ← LLM-owned markdown knowledge base
  index.md  ← content catalog, updated on every ingest
  log.md    ← append-only chronological record
  <topic>.md← one page per entity, concept, or summary
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

## Index Format (`wiki/index.md`)

Organized by category. Each entry: `- [[<topic>]] — <one-line description>`

## Log Format (`wiki/log.md`)

Append-only. Newest entries at the bottom. Parseable prefixes:

| Prefix | Meaning |
|--------|---------|
| `[INGEST]` | A new source was processed |
| `[QUERY]` | A query was filed as a wiki page |
| `[LINT]` | A lint run was completed |
| `[UPDATE]` | An existing wiki page was revised |

---

## Conventions

- The LLM **reads** `raw/` but **never modifies** it.
- The LLM **owns** `wiki/` entirely: creates, updates, and cross-links pages.
- Humans **read** `wiki/` and **curate** `raw/`.
- Cross-references use `[[page-name]]` notation (filename without `.md`).
- All dates use `YYYY-MM-DD` format.
- Keep pages focused: one entity or concept per page. Use cross-references rather than duplicating content.
