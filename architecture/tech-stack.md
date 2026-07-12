# The Full-Stack Reference — every layer, every choice, with rationale

The complete "G-stack" (ground-to-cloud stack) for Kloer. Optimized for: a 4-engineer
team shipping a regulated-industry SaaS, EU data residency by construction, and AI as
a first-class subsystem rather than a bolt-on.

## Layer map

| # | Layer | Choice | Why |
|---|---|---|---|
| 1 | Frontend | **Next.js 15 (App Router) + TypeScript + Tailwind + shadcn/ui** | Fast to ship, SSR for the public Obligations Index (SEO moat), one language across the stack |
| 2 | API | **Fastify (Node 22, TypeScript) + Zod** | Lightweight, schema-validated at the edge of every route; OpenAPI generated from Zod schemas so the customer-facing API docs are never stale |
| 3 | Contracts | **Zod schemas in a shared `packages/contracts`** | One source of truth for API + frontend + workers |
| 4 | Database | **PostgreSQL 16** | Boring and correct. Row-Level Security for tenant isolation (regulated buyers audit this), `pgvector` for document embeddings, logical replication for the audit mirror |
| 5 | Audit log | **Append-only Postgres table + hash chain** (each row carries SHA-256 of previous row) | Tamper-evidence without blockchain theater; exportable proof for CSSF inspections |
| 6 | Object storage | **S3-compatible, EU region** (AWS eu-central-1 with EU data boundary, or OVHcloud for sovereignty-sensitive customers) | KYC documents; SSE-KMS per-tenant keys |
| 7 | Queue/workers | **BullMQ on Redis** | Document ingestion, OCR, screening calls, AI drafting jobs; retries + dead-letter queues out of the box |
| 8 | AI gateway | **Internal inference service** → Claude via **AWS Bedrock eu-central-1** (primary), pluggable EU endpoints (fallback) | Model-agnostic per task (extraction / drafting / translation); EU-only inference is a hard sales requirement (CSSF 22/806, GDPR) |
| 9 | AI pipeline | **Structured-output extraction → evidence graph → retrieval → drafting with citations → human review UI** | Every generated sentence carries source refs; unverifiable claims flagged. This is the product's credibility |
| 10 | Rulebook-as-code | **Versioned YAML obligation library + TypeScript rule evaluators**, in-repo, PR-reviewed by compliance experts | Deterministic "what is required"; LLMs never decide requirements, only draft artifacts |
| 11 | Search | Postgres FTS + pgvector hybrid | No separate search infra until it hurts |
| 12 | AuthN/Z | **OIDC via Keycloak (self-hosted, EU)**; SSO/SAML for Enterprise; RBAC + per-entity permissions; SCIM at Enterprise tier | Regulated buyers demand SSO; self-hosting keeps identity data in-boundary |
| 13 | Multi-tenancy | Single DB, RLS-enforced tenant_id, per-tenant KMS keys for documents | Auditable isolation story without per-tenant infra cost |
| 14 | Infra | **Terraform + AWS eu-central-1** (ECS Fargate) — or full-sovereign OVHcloud/Kubernetes track for customers that require it | IaC from day one; the 22/806 exit-plan annex literally references the Terraform repo |
| 15 | CI/CD | GitHub Actions: typecheck, test, contract-diff, `docker build`, staged deploy with manual gate to prod | Change-management evidence doubles as our own ISO 27001 control evidence |
| 16 | Observability | OpenTelemetry → Grafana stack (Loki/Tempo/Mimir), Sentry for errors | DORA incident-reporting needs real timelines |
| 17 | Security | Tenant-key encryption at rest, TLS 1.3, immutable audit log, quarterly pen-test, ISO 27001 → SOC 2 Type II roadmap (managed in Vanta — dogfooding) | The security page is a sales page |
| 18 | Docs & API | OpenAPI from Zod + hosted docs; public status page | Middesk-style API productization of the screening layer |

## Monorepo layout (implemented in `/app`)

```
app/
├── docker-compose.yml        # postgres + redis + api + web, one command up
├── packages/
│   └── contracts/            # Zod schemas: entities, obligations, kyc-files, events
├── api/                      # Fastify: REST + webhooks + worker entrypoints
│   └── src/
│       ├── server.ts
│       ├── routes/           # /entities /kyc-files /obligations /screenings /evidence
│       ├── rulebook/         # obligation YAML + evaluators
│       ├── ai/               # inference gateway client, drafting pipeline
│       └── audit/            # hash-chained audit log writer
├── web/                      # Next.js: dashboard, KYC Studio, Evidence Room
└── db/
    └── schema.sql            # tables incl. RLS policies + audit chain
```

## AI pipeline detail (the wedge, engineered)

```
document in (PDF/IMG/email)
  → OCR + layout (Textract EU / open-source fallback)
  → structured extraction (LLM, JSON-schema-constrained)   ──┐
  → entity resolution vs. registry data (RCS/RBE)            │ evidence graph
  → screening calls (sanctions/PEP/adverse media)          ──┘   (Postgres)
  → risk-factor evaluation (deterministic rulebook evaluators)
  → memo drafting (LLM, retrieval over evidence graph, citation-required decoding)
  → reviewer UI: accept / edit / reject per section  → immutable approval record
```

Cost model: ~€0.60–1.80 inference per full KYC file at current EU-region pricing —
against €400 price and €2,500 replaced cost. COGS is a rounding error; the margin is
in the workflow.

## Build-vs-buy decisions

| Capability | Decision | Note |
|---|---|---|
| OCR | Buy (Textract EU) with OSS fallback (Tesseract) | Not differentiating |
| Sanctions/PEP data | Buy (2 providers, orchestrated) | Orchestration + margin is ours |
| Identity verification | Buy/resell | Margin layer |
| Rulebook library | **Build** | The moat |
| Evidence graph + drafting pipeline | **Build** | The moat |
| Auth | Self-host Keycloak | Sovereignty requirement |
| Billing | Buy (Stripe Billing, EU entity) | Annual invoicing + usage metering |
