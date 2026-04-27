-- Devopstrio Application Landing Zone (ALZ)
-- Enterprise Database Schema definition
-- Target: PostgreSQL 14+

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tenant / Business Unit Separation
CREATE TABLE IF NOT EXISTS tenants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) UNIQUE NOT NULL,
    domain VARCHAR(255) UNIQUE NOT NULL,
    tier VARCHAR(50) DEFAULT 'Standard',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Users & RBAC
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'Developer', -- Admin, Platform Engineer, Developer, FinOps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Application Portfolio
CREATE TABLE IF NOT EXISTS applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    system_of_record VARCHAR(255),
    business_criticality INT DEFAULT 3, -- 1=Low, 5=Mission Critical
    owner_id UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tenant_id, name)
);

-- Golden Template Catalog
CREATE TABLE IF NOT EXISTS templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) UNIQUE NOT NULL,
    version VARCHAR(50) NOT NULL,
    architecture_type VARCHAR(100) NOT NULL, -- e.g., 'Next.js Frontend', 'FastAPI Backend', 'Worker'
    repository_url VARCHAR(512),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Deployed Environments (e.g., App X in 'Prod' region 'UK South')
CREATE TABLE IF NOT EXISTS environments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    app_id UUID REFERENCES applications(id) ON DELETE CASCADE,
    env_name VARCHAR(50) NOT NULL, -- Dev, Test, Prod
    region VARCHAR(100) NOT NULL,
    template_id UUID REFERENCES templates(id),
    cluster_ref VARCHAR(255), -- Reference to AKS cluster
    status VARCHAR(50) DEFAULT 'Provisioning',
    deployed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP WITH TIME ZONE -- For transient Dev environments
);

-- Provisioning Requests (Audit & Status)
CREATE TABLE IF NOT EXISTS requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    requested_by UUID REFERENCES users(id),
    app_id UUID REFERENCES applications(id),
    request_type VARCHAR(100) NOT NULL, -- 'New Provisioning', 'Scale', 'Deprovision'
    payload JSONB NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending', -- Pending, Approved, Provisioning, Complete, Failed
    governance_score INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- FinOps Cost Records
CREATE TABLE IF NOT EXISTS cost_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    env_id UUID REFERENCES environments(id) ON DELETE CASCADE,
    tenant_id UUID REFERENCES tenants(id),
    billing_month DATE NOT NULL,
    compute_cost FLOAT DEFAULT 0.0,
    storage_cost FLOAT DEFAULT 0.0,
    network_cost FLOAT DEFAULT 0.0,
    total_cost FLOAT GENERATED ALWAYS AS (compute_cost + storage_cost + network_cost) STORED,
    UNIQUE(env_id, billing_month)
);

-- Security Findings
CREATE TABLE IF NOT EXISTS security_findings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    env_id UUID REFERENCES environments(id) ON DELETE CASCADE,
    scanner VARCHAR(100) NOT NULL, -- 'Trivy', 'SonarQube', 'Defender'
    severity VARCHAR(50) NOT NULL,
    finding_details TEXT NOT NULL,
    is_resolved BOOLEAN DEFAULT false,
    discovered_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Quotas and Limits
CREATE TABLE IF NOT EXISTS quotas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    max_apps INT DEFAULT 10,
    max_monthly_budget FLOAT DEFAULT 5000.0,
    allowed_regions JSONB DEFAULT '["uksouth", "ukwest"]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for standard access paths
CREATE INDEX idx_apps_tenant ON applications(tenant_id);
CREATE INDEX idx_envs_app ON environments(app_id);
CREATE INDEX idx_costs_tenant ON cost_records(tenant_id, billing_month);
CREATE INDEX idx_requests_status on requests(status);
