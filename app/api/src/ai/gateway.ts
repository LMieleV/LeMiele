// AI gateway: single internal interface for all inference. Model-agnostic and
// EU-region only — swap providers per task without touching product code.
// Ships with a deterministic stub so the scaffold runs without credentials.

export interface MemoSection {
  title: string;
  body: string;
  citations: string[]; // evidence ids — a section without citations is invalid
}

export interface DraftRequest {
  relationshipName: string;
  riskRating: string;
  evidence: Array<{ id: string; kind: string; summary: string }>;
}

export interface AiGateway {
  draftKycMemo(req: DraftRequest): Promise<MemoSection[]>;
}

class StubGateway implements AiGateway {
  async draftKycMemo(req: DraftRequest): Promise<MemoSection[]> {
    const cite = (kind: string) =>
      req.evidence.filter((e) => e.kind === kind).map((e) => e.id);
    const all = req.evidence.map((e) => e.id);
    return [
      {
        title: "Identity & Ownership",
        body: `${req.relationshipName}: identity established from register extract and identification documents on file. Beneficial ownership traced to natural persons per RBE lookup.`,
        citations: cite("register_extract").length ? cite("register_extract") : all,
      },
      {
        title: "Screening",
        body: "Sanctions, PEP and adverse-media screening completed against connected providers; no true-positive matches. Alerts dispositioned with rationale.",
        citations: cite("screening").length ? cite("screening") : all,
      },
      {
        title: "Risk Assessment & Conclusion",
        body: `Deterministic rulebook evaluation rates this relationship ${req.riskRating}. Draft recommendation: maintain rating; schedule next periodic review per policy. Human approval required.`,
        citations: all,
      },
    ];
  }
}

// Production implementation targets Claude on AWS Bedrock eu-central-1 with
// JSON-schema-constrained output and citation-required decoding.
// class BedrockGateway implements AiGateway { ... }

export function createGateway(): AiGateway {
  const mode = process.env.AI_GATEWAY_MODE ?? "stub";
  if (mode !== "stub") {
    throw new Error(`AI_GATEWAY_MODE=${mode} not wired in scaffold — implement BedrockGateway`);
  }
  return new StubGateway();
}
