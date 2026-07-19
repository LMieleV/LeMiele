# LeMiele Ventures

Two layers, one thesis: **proven US business models, re-smelted for Europe from
Luxembourg.**

1. **[Schmelz](studio/business-case.md)** — the replica-first venture studio: the
   factory that enters every market through models already de-risked in the US
   (full business case, scored [replica pipeline](studio/replica-pipeline.md),
   [studio financial model](studio/financial-model.csv)).
2. **Kloer** (below) — Venture #1 off the line: the Vanta-replica for the Luxembourg
   fund industry, fully specified in this repository.

---

# Kloer — Compliance, kloer a simpel.

> **The Vanta of the Luxembourg fund industry.** An AI-native, continuous-compliance
> operations platform for Luxembourg ManCos, AIFMs, fund administrators and regulated
> SMEs — built by transplanting the three most successful US vertical-SaaS playbooks
> (Vanta, Ramp, ServiceTitan) into the world's #2 fund domicile.

---

## Why this business, why Luxembourg, why now

| Signal | Fact |
|---|---|
| Market size | Luxembourg funds hold **~€7.4 trillion AuM** (June 2025) — the #1 fund domicile in Europe, #2 worldwide |
| Pain | A single institutional KYC review costs **$1,500–$3,000**; 21% of firms spend **>$3,000 per review**; 70% of firms lost clients in the past year to slow onboarding |
| Regulatory forcing function | The CSSF's **2026 supervisory priorities** tighten scrutiny of AML/KYC governance, third-party risk, cyber resilience and valuation — every regulated entity must upgrade |
| Incumbent gap | Local players (Finologee, KYC3, Governance.com) sell **workflow tools** to large enterprises; nobody sells **AI-native, self-serve, continuous compliance** to the mid-market |
| US proof | Vanta ($2.45B valuation, compliance automation), Ramp (5.5× payment volume growth in 2 years), ServiceTitan (IPO'd on vertical SaaS + embedded fintech) all prove the model |
| Launchpad | Fit4Start grants **up to €150k** + coaching; SARL-S incorporation from **€1** capital |

## The one-sentence pitch

**Kloer turns AML/KYC compliance from a €200k/year manual back-office cost into a
€30k/year automated subscription** — continuous monitoring, AI-drafted regulatory
filings, and audit-ready evidence collection for Luxembourg's 3,000+ regulated fund
entities.

## Repository map — the whole business

| Path | What's inside |
|---|---|
| [`docs/01-executive-summary.md`](docs/01-executive-summary.md) | The business in two pages |
| [`docs/02-us-playbook.md`](docs/02-us-playbook.md) | Deep teardown of the US models we transplant (Vanta, Ramp, ServiceTitan, Toast, Middesk/Alloy) and exactly what transfers |
| [`docs/03-market-analysis.md`](docs/03-market-analysis.md) | Luxembourg TAM/SAM/SOM, competitor map, regulatory tailwinds |
| [`docs/04-product.md`](docs/04-product.md) | Product spec — modules, user journeys, AI architecture |
| [`docs/05-business-model.md`](docs/05-business-model.md) | Pricing, unit economics, revenue engines |
| [`docs/06-go-to-market.md`](docs/06-go-to-market.md) | GTM motion, channel strategy, first-10-customers plan |
| [`docs/07-financial-plan.md`](docs/07-financial-plan.md) | 3-year P&L, headcount plan, break-even analysis |
| [`docs/08-legal-incorporation.md`](docs/08-legal-incorporation.md) | Step-by-step Luxembourg incorporation (SARL-S → SARL), licences, GDPR/CSSF posture |
| [`docs/09-funding-roadmap.md`](docs/09-funding-roadmap.md) | Fit4Start → pre-seed → seed, with amounts and milestones |
| [`docs/10-risk-register.md`](docs/10-risk-register.md) | Honest risk register with mitigations |
| [`docs/11-roadmap.md`](docs/11-roadmap.md) | 24-month execution roadmap |
| [`finance/financial-model.csv`](finance/financial-model.csv) | The numbers behind the plan |
| [`architecture/tech-stack.md`](architecture/tech-stack.md) | **The full-stack reference** — every layer, every choice, with rationale |
| [`architecture/system-architecture.md`](architecture/system-architecture.md) | System diagrams (Mermaid) — data flows, AI pipeline, security model |
| [`app/`](app/) | Runnable full-stack scaffold: Fastify API + Next.js web + Postgres, `docker compose up` |
| [`pitch/one-pager.md`](pitch/one-pager.md) | Investor one-pager |

## Quick start (the scaffold)

```bash
cd app
docker compose up --build
# web  → http://localhost:3000
# api  → http://localhost:4000/health
```

---

*Kloer* /kloːɐ̯/ — Luxembourgish for "clear". Because compliance shouldn't be murky.
