# Legal & Incorporation — Luxembourg step-by-step

> Practical checklist. Not legal advice; validate with a Luxembourg notary/counsel
> before filing.

## 1. Legal form decision

| Option | Capital | Notary | When |
|---|---|---|---|
| **SARL-S** (simplified) | €1–€11,999 | Not required | Fastest start; only natural persons as shareholders; fine for pre-funding phase |
| **SARL** | €12,000 min | Required | At pre-seed (funds/BSA-holders need a normal SARL or SA) |
| SA | €30,000 | Required | Later, if ESOP/board structure demands it |

**Plan:** incorporate **SARL-S now** (days, ~€1k total cost), convert to **SARL at
pre-seed closing** (standard, the notary handles it in the same deed as the round).
Fit4Start requires Luxembourg incorporation — SARL-S satisfies it.

## 2. Incorporation checklist (SARL-S)

1. Check name availability + reserve with **LBR** (Luxembourg Business Registers).
2. Draft articles (template acceptable for SARL-S; bilingual FR/EN recommended).
3. **Business permit (autorisation d'établissement)** from the Ministry of the Economy
   via MyGuichet — required before starting activity; needs a qualified manager
   resident/effectively managing from Luxembourg.
4. File with **RCS** (trade register), publish in **RESA**.
5. Register beneficial owners in the **RBE** within one month.
6. Tax registrations: **ACD** (direct tax), **AED** (VAT — register once turnover
   requires; SaaS to LU/EU B2B customers = reverse charge for EU, 17% VAT domestic).
7. **CCSS** registration as employer before first hire.
8. Open business bank account (Spuerkeess/BGL/ING or an EMI to start).
9. Insurance: professional liability (E&O) + cyber — customers will ask; get it early.

Budget: ~€1,000–1,500 (SARL-S) / ~€2,500–4,000 (SARL with notary) + permit fees.

## 3. Regulatory perimeter analysis (critical for a RegTech)

- Kloer sells **software and data orchestration**, not regulated financial services →
  **no CSSF licence required** at launch. Stay out of the "support PSF" perimeter by
  not operating IT systems *on behalf of* regulated entities beyond SaaS delivery;
  obtain counsel opinion at launch (this is also a sales FAQ).
- If later ambitions include operating as an outsourced KYC processor at scale, evaluate
  **support PSF (Art. 29-3/29-4)** status deliberately — it's a moat (Finologee chose
  this path) but heavy; decide at Series A, not before.
- **CSSF Circular 22/806 (outsourcing)**: our *customers* must treat Kloer as an ICT
  outsourcing provider — ship them the pre-filled register entry, exit plan, and audit
  rights annex as standard contract schedules. This converts a procurement blocker
  into a differentiator.
- **DORA**: as ICT third-party provider to financial entities, contract clauses per
  Art. 30 DORA baked into our MSA from day one.

## 4. Data protection (GDPR)

- Kloer processes special-category-adjacent data (IDs, PEP status, adverse media) as
  **processor** for customers (controllers). DPA with SCC-free EU-only processing.
- CNPD is the supervisory authority; appoint DPO (external service initially).
- Records of processing, DPIA for the screening module, retention aligned to AML law
  (5 years post-relationship, extendable).

## 5. IP, employment, stock

- IP assignment deeds from founders/contractors to the company at incorporation.
- Luxembourg **IP box**: 80% exemption on qualifying IP income — structure software IP
  ownership in-country from day one (real, non-trivial tax advantage vs. US-style
  Delaware defaults).
- Employment: Luxembourg contracts, CCSS social security ~12–15% employer side;
  cross-border workers standard (mind the telework tax thresholds FR/DE/BE).
- ESOP: warrant/BSPCE-style plans are clumsy in LU; use phantom shares or a
  Dutch/lux hybrid at seed — decide with counsel at the pre-seed round.

## 6. Contracts stack (templates to prepare)

- MSA + DPA + SLA (with 22/806/DORA annexes) — the single most important sales asset.
- Design-partner agreement (discount ↔ reference rights).
- Screening-provider reseller agreements.
