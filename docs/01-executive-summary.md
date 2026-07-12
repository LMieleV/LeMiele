# Executive Summary

## The company

**Kloer S.à r.l.** — an AI-native compliance operations platform, headquartered in
Luxembourg City, serving the Luxembourg fund industry first and EU-regulated SMEs
second.

## The problem

Luxembourg is the largest fund domicile in Europe (~€7.4 trillion AuM across
UCITS, AIFs, RAIFs and SIFs). Every one of its ~3,000+ regulated entities — ManCos,
AIFMs, fund administrators, transfer agents, depositaries — carries a permanent,
growing AML/KYC and regulatory-reporting burden:

- A single institutional KYC review costs **$1,500–$3,000**; large firms spend tens of
  millions per year on AML/KYC operations.
- **70% of financial firms lost clients in the past year** because onboarding was too slow.
- The CSSF's **2026 supervisory priorities** explicitly tighten AML/CFT supervision,
  third-party risk, cyber resilience, liquidity and valuation oversight — compliance
  workload only goes up.
- Mid-market entities (the hundreds of ManCos and administrators below the top-20)
  handle this with **spreadsheets, shared drives, and expensive Big-4 consultants**.

## The solution

Kloer is **continuous compliance as a subscription** — the model Vanta proved in the
US for SOC 2/ISO 27001, applied to CSSF/AML/KYC obligations:

1. **Connect** — integrations pull evidence continuously from the customer's systems
   (registers, TA systems, email, document stores, screening providers).
2. **Monitor** — a rules + AI engine maps evidence against CSSF circulars, AML law of
   12 November 2004 (as amended), AMLD6, DORA, and each entity's own RC/RR obligations;
   gaps surface as tasks, not audit findings.
3. **Automate** — AI agents draft KYC review files, risk assessments (BO/CRA), CSSF
   filings and board-ready compliance reports; humans approve, Kloer archives the
   audit trail.
4. **Prove** — one-click, always-current evidence room for auditors, depositaries and
   the CSSF.

## Why now

- **Regulatory forcing function:** CSSF 2026 priorities + DORA + AMLR/AMLA (EU AML
  Authority, live from 2026-2027) force every entity to re-tool.
- **AI capability step-change:** document-heavy KYC review work is now automatable at
  >90% quality with LLM pipelines + human-in-the-loop — impossible in 2021 when
  incumbents built their workflow tools.
- **Proven playbook:** Vanta reached $100M+ ARR selling exactly this motion
  (continuous monitoring + audit readiness) in an adjacent compliance vertical.

## Why us / why here

- Luxembourg gives instant credibility in fund compliance ("domiciled where our
  customers are regulated"), access to Fit4Start (€150k grant), the Digital Tech Fund,
  the LHoFT (Luxembourg House of Financial Technology), and a multilingual talent pool.
- The founding wedge is **narrow and deep** (ServiceTitan lesson): Luxembourg fund
  entities only, CSSF rulebook only — then expand to Ireland (the #2 EU fund domicile)
  with the same product.

## Business model

SaaS subscription, priced per regulated entity + volume of monitored relationships:

| Tier | Target | Price |
|---|---|---|
| Starter | SARL-S / small PSF, single entity | €850/month |
| Growth | Mid-market ManCo / administrator | €2,500/month |
| Enterprise | Multi-entity groups, ManCo platforms | from €6,000/month |

Later revenue engines (Ramp lesson — monetize the workflow you own): pay-per-use
screening & ID-verification margin, marketplace referral fees (auditors, RC-as-a-service),
and embedded regulatory filing services.

## The numbers (see `docs/07-financial-plan.md`)

| | Year 1 | Year 2 | Year 3 |
|---|---|---|---|
| Customers (EoY) | 15 | 60 | 150 |
| ARR (EoY) | €0.35M | €1.45M | €3.9M |
| Team | 6 | 14 | 26 |
| Net burn | −€0.55M | −€0.9M | ≈ break-even Q4 |

Funding path: Fit4Start (€150k, non-dilutive) → pre-seed €750k (LBAN angels +
Expon/Mangrove-type funds via LHoFT network) → seed €3M at ~€1M ARR.

## The ask (for this repo's reader)

Everything needed to execute is in this repository: market analysis, product spec,
financial model, incorporation checklist, funding roadmap, and a runnable full-stack
reference implementation. Next physical step: reserve the name with the LBR, open the
blocked capital account, and file the Fit4Start application before the next cohort
deadline.
