-- Kloer core schema: multi-tenant with RLS, hash-chained audit log.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE tenants (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    legal_form text NOT NULL,           -- SARL, SA, SCSp ...
    cssf_id text,                        -- CSSF register id, if any
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL REFERENCES tenants(id),
    email text NOT NULL UNIQUE,
    role text NOT NULL CHECK (role IN ('analyst', 'approver', 'rc', 'admin')),
    created_at timestamptz NOT NULL DEFAULT now()
);

-- Monitored relationships: investors, counterparties, providers.
CREATE TABLE relationships (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL REFERENCES tenants(id),
    kind text NOT NULL CHECK (kind IN ('investor', 'counterparty', 'provider')),
    display_name text NOT NULL,
    risk_rating text CHECK (risk_rating IN ('low', 'medium', 'high')),
    next_review_due date,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE kyc_files (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL REFERENCES tenants(id),
    relationship_id uuid NOT NULL REFERENCES relationships(id),
    status text NOT NULL DEFAULT 'assembling'
        CHECK (status IN ('assembling', 'drafted', 'in_review', 'approved', 'rejected')),
    draft_memo jsonb,                    -- AI draft: sections with citation refs
    approved_by uuid REFERENCES users(id),
    approved_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now()
);

-- Evidence graph: every extracted fact links to its source document.
CREATE TABLE evidence (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL REFERENCES tenants(id),
    kyc_file_id uuid REFERENCES kyc_files(id),
    source_uri text NOT NULL,            -- s3 object of the source document
    kind text NOT NULL,                  -- passport, register_extract, structure_chart ...
    extracted jsonb NOT NULL,            -- structured extraction output
    created_at timestamptz NOT NULL DEFAULT now()
);

-- Append-only, hash-chained audit log. No UPDATE/DELETE possible (revoked + trigger).
CREATE TABLE audit_log (
    seq bigserial PRIMARY KEY,
    tenant_id uuid NOT NULL,
    actor text NOT NULL,
    action text NOT NULL,
    payload jsonb NOT NULL,
    prev_hash text NOT NULL,
    hash text NOT NULL,
    at timestamptz NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION forbid_mutation() RETURNS trigger AS $$
BEGIN
    RAISE EXCEPTION 'audit_log is append-only';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_log_immutable
    BEFORE UPDATE OR DELETE ON audit_log
    FOR EACH ROW EXECUTE FUNCTION forbid_mutation();

-- Row-level security: tenant isolation enforced in the database, not app code.
ALTER TABLE relationships ENABLE ROW LEVEL SECURITY;
ALTER TABLE kyc_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE evidence ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation_relationships ON relationships
    USING (tenant_id = current_setting('app.tenant_id', true)::uuid);
CREATE POLICY tenant_isolation_kyc_files ON kyc_files
    USING (tenant_id = current_setting('app.tenant_id', true)::uuid);
CREATE POLICY tenant_isolation_evidence ON evidence
    USING (tenant_id = current_setting('app.tenant_id', true)::uuid);

-- Demo seed: one tenant, one analyst, two relationships, one KYC file.
INSERT INTO tenants (id, name, legal_form, cssf_id) VALUES
    ('00000000-0000-0000-0000-000000000001', 'Demo ManCo S.à r.l.', 'SARL', 'S00001234');

INSERT INTO users (tenant_id, email, role) VALUES
    ('00000000-0000-0000-0000-000000000001', 'analyst@demo-manco.lu', 'analyst');

INSERT INTO relationships (id, tenant_id, kind, display_name, risk_rating, next_review_due) VALUES
    ('00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000001',
     'investor', 'Alpine Pension Trust', 'medium', now()::date + 30),
    ('00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000001',
     'investor', 'Meridian Family Office SCSp', 'high', now()::date - 5);

INSERT INTO kyc_files (tenant_id, relationship_id, status) VALUES
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'assembling');
