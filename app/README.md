# Kloer — full-stack reference scaffold

Minimal but real implementation of the architecture in
[`../architecture/tech-stack.md`](../architecture/tech-stack.md): Fastify API with a
rulebook-as-code evaluator and hash-chained audit log, Postgres schema with RLS
tenant isolation, and a Next.js dashboard shell.

## Run it

```bash
docker compose up --build
# web → http://localhost:3000
# api → http://localhost:4000/health
# api → http://localhost:4000/obligations   (rulebook demo)
# api → http://localhost:4000/kyc-files     (seeded demo data)
```

## What's demonstrated

| Concern | Where |
|---|---|
| Tenant isolation via Postgres RLS | `db/schema.sql` |
| Hash-chained append-only audit log | `api/src/audit/auditLog.ts` + trigger in schema |
| Rulebook-as-code (YAML obligations + deterministic evaluators) | `api/src/rulebook/` |
| AI gateway abstraction (EU-region, model-agnostic, citation-required) | `api/src/ai/gateway.ts` |
| Shared Zod contracts | `packages/contracts/` |
| KYC file lifecycle API | `api/src/server.ts` routes |

The AI gateway ships with a deterministic stub so the scaffold runs with no API keys;
point `AI_GATEWAY_MODE=bedrock` + credentials at AWS Bedrock eu-central-1 for real
inference.
