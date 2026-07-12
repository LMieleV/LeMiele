# Financial Plan (3 years)

Full line items in [`../finance/financial-model.csv`](../finance/financial-model.csv).
All figures EUR. Conservative-realistic case; assumptions listed at the bottom.

## Summary P&L

| | Year 1 | Year 2 | Year 3 |
|---|---|---|---|
| Customers (EoY) | 15 | 60 | 150 |
| — Starter / Growth / Enterprise | 8 / 6 / 1 | 28 / 26 / 6 | 70 / 65 / 15 |
| ARR (EoY, incl. usage) | €0.35M | €1.45M | €3.9M |
| Recognized revenue | €0.14M | €0.80M | €2.80M |
| COGS (inference, screening, hosting) | €0.03M | €0.15M | €0.50M |
| Gross margin | 79% | 81% | 82% |
| Team (EoY headcount) | 6 | 14 | 26 |
| People cost (loaded) | €0.51M | €1.30M | €2.50M |
| Other opex | €0.15M | €0.40M | €0.70M |
| **EBITDA** | **−€0.55M** | **−€1.05M** | **−€0.90M** |
| Grants (Fit4Start + follow-on) | +€0.15M | +€0.10M | — |
| **Net burn** | **−€0.40M** | **−€0.95M** | **−€0.90M** |
| Monthly run-rate at EoY | | | ≈ break-even Q4 Y3 |

Cumulative cash need before break-even: **≈ €2.3M** → covered by €150k Fit4Start +
€750k pre-seed + €3M seed with comfortable buffer (see `09-funding-roadmap.md`).

## Headcount plan

| Role | Y1 | Y2 | Y3 |
|---|---|---|---|
| Founders (CEO sales / CTO product) | 2 | 2 | 2 |
| Engineers (full-stack + AI) | 2 | 5 | 9 |
| Compliance domain experts (ex-Big-4/RC) | 1 | 3 | 5 |
| Sales / customer success | 1 | 3 | 7 |
| Ops/finance | 0 | 1 | 3 |
| **Total** | **6** | **14** | **26** |

Loaded cost avg €85k/FTE Y1 rising to €96k (Luxembourg salaries are high; offset by
cross-border talent pool and lean AI-leveraged team — a 26-person company at €3.9M ARR
is the deliberate capital-efficient EU pattern, not the US blitz pattern).

## Key assumptions (stress these first)

1. **Sales cycle**: 3 months (Starter/self-serve) to 6–9 months (Enterprise). Y1 is
   deliberately design-partner-heavy; only 15 logos.
2. **Pricing holds** at €850/€2,500/€6,000+/mo — anchored vs. consultant hours, tested
   with design partners in months 3–6.
3. **Churn** 8% gross, NRR 115%+ from relationship-volume growth and module expansion.
4. **Usage revenue** reaches 15% of total by Y3 at ~88% margin.
5. **AI COGS** falls per file over the plan (model prices trend down); modeled flat as
   buffer.
6. FX/none; all EUR. No debt. Standard 16.7% CIT+MBT+NWT Luxembourg corporate tax
   irrelevant until profitability (loss carry-forward applies).

## Sensitivity

| Scenario | Effect |
|---|---|
| Sales cycle +3 months across board | Break-even slips to mid-Y4; need +€0.7M seed buffer (already in ask) |
| Growth-tier price −20% | Y3 ARR €3.2M; still fundable; usage margin becomes critical |
| Ireland launch delayed past M24 | Y3 customer count −20; domestic long-tail (notaries/insurers) partially compensates |
| Design partners convert < 2/3 | Extend founder-led phase; cut hires 4→2 in Y1 eng |
