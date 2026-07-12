# The US Playbook — what we're transplanting and why it transfers

The brief: *take the best businesses and solutions made in the US and implement them
in Luxembourg.* This document is the teardown. Five US companies define the pattern;
Kloer is the deliberate recombination of their proven mechanics onto Luxembourg's
highest-value niche.

---

## 1. Vanta — compliance automation as a subscription

**What it is:** Continuous monitoring of a company's systems against compliance
frameworks (SOC 2, ISO 27001, HIPAA), automated evidence collection, and one-click
audit readiness. Valued at ~$2.45B; the category it created ("trust management") now
has dozens of clones.

**The mechanic that matters:**
- It converted a **periodic, consultant-driven cost** (the annual audit scramble) into
  a **continuous, software-driven subscription**.
- Integrations are the moat: once 20+ systems feed evidence into Vanta, ripping it out
  means rebuilding your audit story from scratch.
- Sales motion is bottoms-up + compliance-deadline-driven: the buyer arrives with a
  forcing function (a customer demands SOC 2 → they need it in 8 weeks).

**Transfer to Luxembourg:** identical structure. Replace SOC 2 with the CSSF/AML
rulebook, replace "your enterprise customer demands SOC 2" with "the CSSF's 2026
supervisory priorities and your depositary demand demonstrable AML/CFT controls."
The forcing function is stronger: it's the law, not a sales blocker.

## 2. Ramp — own the workflow, then monetize the money flowing through it

**What it is:** Corporate cards + spend management. Grew payment volume 5.5× in two
years; expanded from cards → bill pay → procurement → treasury → lending.

**The mechanic that matters:**
- Entered with a **free/cheap workflow tool** that saved measurable money, then layered
  **take-rate revenue** (interchange, lending) on the flows it now controlled.
- "Savings" positioning, not "control" positioning — the CFO buys ROI, not features.

**Transfer to Luxembourg:** Kloer enters with the compliance workflow, then layers
per-use revenue on the flows it controls: sanctions/PEP screening calls, ID&V checks,
registry lookups (Middesk-style margin), regulatory filing submissions, and referral
fees to auditors/RC-as-a-service providers. Position as **savings**: "your KYC review
cost drops from €2,500 to €400 per file."

## 3. ServiceTitan — vertical depth beats horizontal breadth

**What it is:** The operating system for US home-services contractors (HVAC, plumbing,
electrical). IPO'd December 2024. Started painfully narrow, became irreplaceable, then
layered payments and lending.

**The mechanic that matters:**
- **Pick a niche the tech industry ignores because it looks small, then own 100% of its
  workflow.** Customers in vertical markets consolidate onto purpose-built software and
  buy everything from that vendor.
- Compliance, permissions, audit trails and industry-specific reporting built into the
  core product become a moat generic tools can't cross.

**Transfer to Luxembourg:** the Luxembourg fund-compliance niche looks small to a US
SaaS (3,000+ entities) but is extraordinarily dense and rich: entities are legally
obligated to buy, budgets are non-discretionary, and they all sit within 20km of each
other. Perfect ServiceTitan terrain. Ireland (the other EU fund domicile) doubles the
market with the same product later.

## 4. Toast — land with the painful workflow, expand with embedded fintech

**What it is:** Restaurant POS → payroll → capital → supplier marketplace. Public,
~$14B market cap. Proof that vertical SaaS + embedded fintech compounds.

**Transfer:** confirms the sequencing Kloer uses — workflow first (KYC reviews, the
single most painful recurring task), fintech-ish take-rates second, marketplace third.

## 5. Middesk / Alloy — KYB/KYC infrastructure as high-margin API

**What they are:** Middesk sells business-identity verification (KYB) as an API;
Alloy orchestrates identity/fraud decisioning for banks and fintechs.

**The mechanic that matters:** compliance data lookups carry SaaS-like margins with
usage-based pricing, and orchestration (routing to the cheapest adequate data source)
is itself the product.

**Transfer:** Kloer's screening layer orchestrates EU data sources (LBR/RCS,
RESA beneficial-ownership register, EU sanctions lists, PEP databases, commercial
providers) behind one API and one margin. In Luxembourg, nobody has built the
Middesk-equivalent for RCS/RBE data; Kloer's internal need becomes a sellable API.

---

## The recombination

| US mechanic | Kloer implementation |
|---|---|
| Vanta: continuous monitoring + evidence collection | Continuous CSSF/AML control monitoring, always-audit-ready evidence room |
| Vanta: deadline-driven sales motion | CSSF 2026 priorities, DORA, AMLA — regulatory deadlines as pipeline |
| Ramp: savings-led positioning | "€2,500 → €400 per KYC file" |
| Ramp/Toast: layered take-rate revenue | Screening/ID&V margin, filing services, marketplace |
| ServiceTitan: narrow niche, total workflow ownership | Luxembourg fund entities only, entire compliance calendar |
| Middesk: data orchestration as product | RCS/RBE/sanctions orchestration API |

## What does NOT transfer (and how we adapt)

| US assumption | Luxembourg reality | Adaptation |
|---|---|---|
| Bottoms-up self-serve credit-card signup | Regulated buyers procure carefully, want local presence | Self-serve trial + local founder-led sales; LHoFT membership for credibility |
| One language, one regulator | FR/DE/EN/LB + CSSF specificity | CSSF rulebook is the moat, not a bug — depth over breadth; UI in EN/FR |
| Venture-scale burn tolerated | Smaller local rounds | Non-dilutive Fit4Start €150k first; capital-efficient AI-lean team |
| US cloud default | Data-sovereignty expectations, DORA | EU-only hosting (OVHcloud/AWS eu-central with EU data boundary), CSSF cloud-outsourcing circular 22/806 compliance by design |
