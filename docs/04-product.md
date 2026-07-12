# Product Specification — Kloer Platform

## Product thesis

Own the **entire compliance calendar** of a Luxembourg regulated fund entity, the way
ServiceTitan owns a contractor's day. Every recurring obligation becomes a Kloer
workflow with AI doing the drafting and humans doing the approving.

## The four modules (launch order)

### Module 1 — KYC Studio (the wedge, MVP)

The single most expensive recurring task: periodic KYC reviews of investors,
counterparties and service providers.

- **Smart file assembly**: connect data rooms / TA systems / email; AI extracts and
  classifies documents (passports, registers, structure charts, source-of-wealth docs)
  into the review file.
- **AI-drafted review memo**: LLM pipeline drafts the risk-scored review against the
  entity's own AML/CFT policy + CSSF requirements; every claim linked to source
  evidence (no unsourced assertions — auditability by construction).
- **Screening orchestration**: sanctions / PEP / adverse media via pluggable providers,
  RCS + RBE (beneficial ownership) lookups, with per-check margin (Middesk mechanic).
- **Human-in-the-loop approval**: 4-eyes workflow, immutable audit log, e-signature.
- **Target metric**: KYC review file time 6–10 hours → **under 1 hour analyst time**;
  cost €2,500 → ~€400.

### Module 2 — Continuous Monitor (the Vanta mechanic)

- Obligation library: CSSF circulars (12/552, 18/698, 22/806…), AML law of 12 Nov 2004,
  AMLD5/6 → AMLR mapping, DORA register obligations — versioned rulebook-as-code.
- Control checks run continuously against connected systems; failures become assigned
  tasks with deadlines, not year-end findings.
- **Compliance calendar**: every filing (annual AML/CFT survey, RC report, RR report,
  board reporting) tracked with AI-drafted first versions.

### Module 3 — Evidence Room

- Always-current, permissioned portal for auditors, depositaries, and CSSF on-site
  inspections. One click: "show me our CDD refresh status for all high-risk investors."
- This is the retention moat: the longer Kloer runs, the more irreplaceable the
  evidence graph.

### Module 4 — Filing & Marketplace (Ramp/Toast expansion revenue)

- goAML STR/SAR filing assistance, CSSF eDesk filing preparation.
- Marketplace: vetted RC-as-a-service providers, auditors, data vendors — referral
  take-rate.

## AI architecture principles

1. **Rulebook-as-code, LLM-as-clerk**: deterministic rules decide *what* is required;
   LLMs draft, extract, summarize and translate. No LLM ever decides a risk rating
   alone — it proposes with citations, a human disposes.
2. **Every output is evidence-linked**: generated text carries source-document
   references; unverifiable statements are flagged, not hidden.
3. **EU-only inference**: models served from EU regions (Claude via AWS Bedrock
   eu-central / Frankfurt or equivalent EU endpoint), documents never leave the EU
   data boundary — a hard sales requirement under CSSF 22/806 and GDPR.
4. **Model-agnostic gateway**: one internal inference API so providers can be swapped
   per task (extraction vs. drafting vs. translation FR/DE/EN).

## User journey (Growth-tier ManCo, day 1 → day 30)

1. **Day 1**: sign up, entity profile wizard (legal form, licences, fund types) →
   Kloer instantiates the applicable obligation set automatically.
2. **Day 2–7**: connect integrations (SharePoint/Drive, TA export, screening provider,
   email intake). Import existing KYC files; AI gap-scans them against policy.
3. **Day 8**: dashboard shows the honest picture: % files current, overdue refreshes,
   missing evidence, upcoming filings. (This "compliance credit score" moment is the
   activation event.)
4. **Day 9–30**: analysts clear the AI-prioritized backlog at 5–8× speed; RC gets the
   first board-ready compliance report auto-drafted.

## Non-functional requirements (sales-critical)

- ISO 27001 + SOC 2 Type II on the roadmap (yes — we'll use Vanta; eat the dogfood of
  the model we're cloning).
- CSSF cloud-outsourcing circular 22/806 compliance pack shipped as a standard
  customer artifact (the sale accelerant incumbents make painful).
- Full data residency in EU, tenant-level encryption, immutable audit log (append-only).
- SLA 99.9%, RPO ≤ 15 min, RTO ≤ 4 h (DORA-aligned — our customers must report on us
  as an ICT third party, so we hand them the register entry pre-filled).
