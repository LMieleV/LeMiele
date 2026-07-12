import { z } from "zod";

export const RiskRating = z.enum(["low", "medium", "high"]);

export const Relationship = z.object({
  id: z.string().uuid(),
  kind: z.enum(["investor", "counterparty", "provider"]),
  displayName: z.string(),
  riskRating: RiskRating.nullable(),
  nextReviewDue: z.string().nullable(),
});

export const KycFileStatus = z.enum([
  "assembling",
  "drafted",
  "in_review",
  "approved",
  "rejected",
]);

// Every drafted sentence must reference evidence — enforced at the type level.
export const MemoSection = z.object({
  title: z.string(),
  body: z.string(),
  citations: z.array(z.string().uuid()).min(1),
});

export const KycFile = z.object({
  id: z.string().uuid(),
  relationshipId: z.string().uuid(),
  status: KycFileStatus,
  draftMemo: z.array(MemoSection).nullable(),
});

export const Obligation = z.object({
  id: z.string(),
  source: z.string(), // e.g. "CSSF 18/698 §5.3", "AML Law 2004 Art. 3"
  title: z.string(),
  frequency: z.enum(["continuous", "annual", "quarterly", "on_event"]),
  appliesTo: z.array(z.string()),
});

export const ObligationCheck = z.object({
  obligationId: z.string(),
  status: z.enum(["ok", "due_soon", "overdue", "not_applicable"]),
  detail: z.string(),
});

export type Relationship = z.infer<typeof Relationship>;
export type KycFile = z.infer<typeof KycFile>;
export type Obligation = z.infer<typeof Obligation>;
export type ObligationCheck = z.infer<typeof ObligationCheck>;
