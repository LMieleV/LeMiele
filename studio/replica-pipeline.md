# Replica Pipeline — scored candidates (2026 Q3 assay)

Scoring: six gates × 5 points (see business case §4.1). **≥24/30 → validation
sprint.** Honest scores — two famous models score *low* on purpose; the discipline
is the product.

| # | Replica of (US proof) | EU/Lux venture concept | US proof | EU white-space | Reg. moat | Lux edge | Capital | Original's EU intent* | **Total** | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | **Vanta** ($2.45B, compliance automation) | **Kloer** — continuous CSSF/AML compliance for the €7.4T Luxembourg fund industry | 5 | 5 | 5 | 5 | 4 | 4 | **28** | ✅ **In build** — fully specified in this repo |
| 2 | **Basis / Accrual** (AI accounting; $1.15B unicorn; buy-at-6-7× EBITDA + automate) | **Fiduciaire rollup** — acquire Luxembourg fiduciaires (400+ firms, aging owners, sticky domiciliation revenue), install AI bookkeeping/reconciliation agents | 4 | 5 | 4 | 5 | 2 | 5 | **25** | ✅ Assay next — the SOPARFI/domiciliation angle is uniquely Luxembourgish |
| 3 | **Middesk** (KYB data API) | **EU KYB orchestration API** — RCS/RBE + BRIS + national registers behind one API; spins out of Kloer's screening layer | 4 | 4 | 4 | 5 | 5 | 4 | **26** | ✅ Assay next — cheapest build (shared chassis), Kloer is customer #1 |
| 4 | **Harvey** (legal AI, $190M ARR in 36 months) | **Fund-lawyer AI** — drafting/review for Luxembourg fund documentation (LPAs, prospectuses, side letters) in EN/FR | 5 | 3 | 4 | 5 | 3 | 2 | **22** | 🟡 Watch — Harvey is entering EU; partnership approach first |
| 5 | **PipeDreams** ($25.5M Series A; AI-enabled HVAC/plumbing rollup) | **Greater-Region trades rollup** — acquire top-quartile HVAC/sanitary firms in LU/Saar/Lorraine (succession wave, no buyers), install field-ops SaaS | 4 | 5 | 2 | 3 | 1 | 5 | **20** | 🟡 Hold — right thesis, wrong vehicle: needs PE-style capital, revisit as Vehicle II |
| 6 | **ServiceTitan** (IPO'd; trades operating system) | **EU multilingual field-service OS** | 5 | 3 | 2 | 3 | 2 | 3 | **18** | ❌ Pass — Simpro/Odoo-adjacent crowding, no reg moat |
| 7 | **Ramp** (spend management, 5.5× volume growth) | EU mid-market spend management | 5 | 1 | 2 | 2 | 2 | 2 | **14** | ❌ Pass — Pleo, Payhawk, Spendesk got here first; the window closed in 2021. Textbook example of why the white-space gate exists |
| 8 | **Toast** (~$14B; restaurant OS + embedded fintech) | EU restaurant OS | 5 | 2 | 1 | 2 | 1 | 3 | **14** | ❌ Pass — Lightspeed/SumUp entrenchment, capital-heavy hardware motion |
| 9 | **Vertical AI insurance underwriting** (US cohort: Federato et al.) | Underwriting workbench for Luxembourg/EU insurers (CAA-regulated) | 4 | 4 | 4 | 4 | 3 | 3 | **22** | 🟡 Watch — strong, needs an insurance-native EIR before assay |
| 10 | **Clinical-trial ops AI** (US cohort) | EU trial-site compliance automation (EMA/GDPR fork) | 3 | 4 | 4 | 2 | 2 | 3 | **18** | ❌ Pass for Vehicle I — outside studio's regulated-finance spine |

\* *"Original's EU intent" scores HIGH when the US original shows **no** sign of
building EU-sovereign infrastructure (= our window is open), LOW when they're
already landing (= partner or avoid).*

## Portfolio spine

The three greenlit/queued ventures (#1 Kloer, #2 fiduciaire rollup, #3 KYB API)
share one spine: **Luxembourg's regulated-finance data and workflow layer**. Each
makes the others stronger — Kloer consumes the KYB API; the fiduciaire rollup is
both a Kloer customer and a distribution channel into every SME it administers;
all three run on the same engineering chassis in [`/app`](../app). This
compounding is the studio's answer to Rocket Internet's scattered portfolio.

## Assay cadence

- Q3 2026: Kloer → Foundry. Assay sprints: #2 fiduciaire rollup, #3 KYB API.
- Q4 2026: decision on #2/#3; re-score #4 (Harvey partnership meeting first)
  and #9 (EIR search).
- Rolling: quarterly re-scan of US seed/Series-A cohorts for new entrants ≥ gate.
