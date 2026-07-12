# System Architecture

## 1. High-level system

```mermaid
flowchart LR
    subgraph Customer systems
        SP[SharePoint / Drive]
        TA[TA / register exports]
        MAIL[Email intake]
    end

    subgraph Kloer EU boundary
        ING[Ingestion workers<br/>BullMQ]
        API[Fastify API<br/>Zod contracts]
        WEB[Next.js app<br/>Dashboard · KYC Studio · Evidence Room]
        RB[Rulebook-as-code<br/>obligation evaluators]
        AIGW[AI gateway<br/>EU-region inference]
        PG[(PostgreSQL 16<br/>RLS + pgvector)]
        S3[(Object storage<br/>per-tenant KMS)]
        AUD[(Append-only audit log<br/>hash chain)]
    end

    subgraph External data
        SCR[Sanctions / PEP / media providers]
        RCS[RCS / RBE registries]
    end

    SP --> ING
    TA --> ING
    MAIL --> ING
    ING --> S3
    ING --> AIGW
    AIGW --> PG
    API --> RB
    API --> PG
    API --> S3
    API --> AUD
    API --> SCR
    API --> RCS
    WEB --> API
```

## 2. KYC Studio pipeline

```mermaid
sequenceDiagram
    participant A as Analyst
    participant W as Web (KYC Studio)
    participant API as API
    participant Q as Workers
    participant AI as AI Gateway (EU)
    participant DB as Evidence Graph (PG)

    A->>W: Open review for investor X
    W->>API: POST /kyc-files/:id/assemble
    API->>Q: enqueue ingest+extract jobs
    Q->>AI: structured extraction (schema-constrained)
    AI-->>DB: entities, attributes, source refs
    Q->>API: screening calls (sanctions/PEP/RBE)
    API-->>DB: screening results + evidence links
    API->>API: deterministic risk-factor evaluation (rulebook)
    API->>AI: draft memo (retrieval over evidence graph, citations required)
    AI-->>W: draft with per-sentence source links
    A->>W: review, edit, approve (4-eyes)
    W->>API: approval
    API->>DB: immutable approval + hash-chained audit entry
```

## 3. Tenant isolation & trust

```mermaid
flowchart TB
    REQ[Request + OIDC token] --> AZ[AuthZ: role + entity scope]
    AZ --> RLS[Postgres RLS: tenant_id enforced in DB, not app code]
    RLS --> DATA[(Tenant rows)]
    AZ --> KMS[Per-tenant KMS key] --> DOCS[(Documents in S3)]
    DATA --> AUDIT[(Hash-chained audit log)]
    DOCS --> AUDIT
```

Principles:
- **Isolation enforced in the database** (RLS), not only in application code — this is
  the line auditors probe first.
- **Nothing leaves the EU boundary**: inference, storage, telemetry all EU-region.
- **Audit log is append-only and hash-chained**; a CSSF inspector can verify
  integrity of the trail independently.
- **LLMs draft, rules decide, humans approve** — the separation is architectural,
  not a policy promise.
