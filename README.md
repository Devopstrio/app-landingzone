<div align="center">

<img src="https://raw.githubusercontent.com/Devopstrio/.github/main/assets/Browser_logo.png" height="85" alt="Devopstrio Logo" />

<h1>Application Landing Zone (ALZ)</h1>

<p><strong>The Golden Path Foundation for Launching Secure, Standardized, and Compliant Cloud Applications</strong></p>

[![Architecture](https://img.shields.io/badge/Architecture-Platform_Eng-522c72?style=for-the-badge&labelColor=000000)](https://devopstrio.co.uk/)
[![Cloud](https://img.shields.io/badge/Platform-Azure_Native-0078d4?style=for-the-badge&logo=microsoftazure&labelColor=000000)](/terraform)
[![Governance](https://img.shields.io/badge/Standard-Enterprise_Strict-962964?style=for-the-badge&labelColor=000000)](/apps/governance-engine)
[![Status](https://img.shields.io/badge/Status-Production_Ready-success?style=for-the-badge&labelColor=000000)](https://devopstrio.co.uk/)

</div>

---

## 🏛️ Executive Summary

![App Landing Zone Architecture](assets/diagram-architecture.png)

The **Application Landing Zone (ALZ)** is the central developer platform engineered to accelerate the delivery of modern microservices, web apps, and API backends. Acting as an Internal Developer Portal (IDP), it abstracts away brutal infrastructure complexity by providing pre-vetted "Golden Path Templates."

### Strategic Business Outcomes
- **"Day 1" Productivity**: Developers provision fully compliant Dev, Test, and Prod application environments in under 5 minutes.
- **Security by Default**: All workloads are deployed behind Azure Front Door WAFs, bounded by Private Link, and integrated with Key Vaults.
- **FinOps Observability**: The embedded Cost Engine assigns hard quotas and predicts chargebacks at the application-namespace level.
- **Automated Governance**: Infrastructure drift and tagging non-conformities are caught dynamically during the provisioning pipelines.

---

## 🏗️ Technical Architecture Details

### 1. High-Level App Provisioning Flow
```mermaid
graph TD
    UI[Self-Service Portal] --> API[Provisioning API]
    API --> CAT[Template Catalog]
    API --> GOV[Governance Engine]
    GOV -->|Validation Passed| PIPE[GitHub Actions Orchestrator]
    PIPE --> IAC[Terraform / Bicep Run]
    IAC --> TFState[(Azure Storage State)]
    IAC --> K8S[AKS Namespace Created]
    IAC --> ACR[ACR Bound]
```

### 2. Multi-Environment Promotion Lifecycle
```mermaid
sequenceDiagram
    participant Dev
    participant Sandbox
    participant Staging
    participant Prod
    
    Dev->>Sandbox: Provision via Next.js Portal (Temp Expiry: 72h)
    Sandbox->>Sandbox: Dev & Test iterations
    Dev->>Staging: PR Merged to Main -> Auto Deploy
    Staging->>Staging: QA & Security Scanning
    Staging->>Prod: Manual Gate Approval / ITSM Release
```

### 3. Golden Template Architecture
```mermaid
graph LR
    subgraph Template_Catalog
        Web[Next.js Web Template]
        API[FastAPI Backend Template]
        Worker[Event-Driven Worker]
    end
    
    subgraph Deployed_Stack
        AKS[Kubernetes Deployments]
        RDS[Azure PostgreSQL]
        KV[Key Vault Secrets]
    end
    
    Web -->|Scaffolded| AKS
    API -->|Scaffolded| AKS
    API -->|Bound| RDS
    API -->|Bound| KV
```

### 4. Governance Validation Flow
```mermaid
graph TD
    Req[Provisioning Request] --> Naming[Naming Convention Check]
    Naming --> Tags[Cost Tag Check]
    Tags --> Network[Private Link Requirement Check]
    Network --> Approve[Provision Authorized]
    Network -->|Violation| Reject[Request Rejected]
```

### 5. Cost Optimization Engine
```mermaid
graph TD
    App1[Payments App] --> Billing[Azure Cost API]
    App2[Auth App] --> Billing
    Billing --> Engine[Cost Engine]
    Engine --> Dashboard[FinOps Dashboard]
    Engine --> Alert[Quota Slack Alert]
```

### 6. Security Trust Boundary
```mermaid
graph TD
    User --> CDN[Azure Front Door / WAF]
    CDN --> AppGW[App Gateway Internal]
    AppGW --> AKS[AKS Application Pods]
    AKS --> KV[Azure Key Vault via Workload ID]
    AKS --> DB[Private Endpoint PostgreSQL]
```

### 7. AKS Workload Topology
```mermaid
graph TD
    subgraph Cluster
        subgraph Tenant_A
            A_UI[React UI]
            A_API[Node API]
        end
        subgraph Tenant_B
            B_API[Spring Boot API]
        end
    end
    A_UI -.-|Network Policy Deny| B_API
```

### 8. API Request Lifecycle
```mermaid
sequenceDiagram
    participant Client
    participant APIM as API Gateway
    participant Backend as App Backend
    
    Client->>APIM: Request payload
    APIM->>APIM: Validate JWT
    APIM->>APIM: Rate Limit Check
    APIM->>Backend: Forward Authorized Request
```

### 9. Multi-Tenant Model
```mermaid
graph TD
    DB[(Control Plane DB)]
    DB --> TeamA[Team: Checkout]
    DB --> TeamB[Team: Fulfillment]
    TeamA --> QuotaA[Quota: 5 Apps]
    TeamB --> QuotaB[Quota: 10 Apps]
```

### 10. Centralized Logging & Monitoring
```mermaid
graph LR
    Pods[App Pods] --> Prom[Prometheus]
    Pods --> Fluent[Fluent Bit]
    Prom --> Grafana[Dashboards]
    Fluent --> LogAnalytics[Azure Log Analytics]
```

### 11. CI/CD CI/CD Pipeline
```mermaid
graph LR
    Code[Git Push] --> Lint[SonarQube Lint]
    Lint --> Build[Docker Build]
    Build --> Scan[Trivy Scan]
    Scan --> Push[ACR Push]
    Push --> Deploy[ArgoCD Sync]
```

### 12. Disaster Recovery Topology
```mermaid
graph TD
    FrontDoor[Azure Front Door] --> UKS[Primary Region - UK South]
    FrontDoor -.->|Traffic Failover| UKW[Secondary Region - UK West]
    UKS_DB[(Cosmos DB)] <-->|Geo-Replication| UKW_DB[(Cosmos DB)]
```

### 13. Developer Onboarding
```mermaid
sequenceDiagram
    participant Dev
    participant Portal
    participant IAM
    
    Dev->>Portal: Login via SSO
    Portal->>IAM: Resolve Azure AD Groups
    IAM-->>Portal: Role: Developer
    Portal->>Dev: Show Template Catalog & Environment Status
```

### 14. Template Publishing Flow
```mermaid
graph LR
    Arch[Cloud Architect] --> Git[Platform Repo]
    Git --> CI[Test Template Syntax]
    CI --> Publish[Update Catalog DB]
    Publish --> Portal[Available in Portal UI]
```

### 15. Operational Auto-Remediation
```mermaid
graph TD
    Alert[High Memory Alert] --> OpsEngine[Ops Engine]
    OpsEngine --> Policy[Check Remediation Policy]
    Policy --> Restart[Restart Pod via API]
    Restart --> Slack[Notify Team via Slack]
```

---

## 🛠️ Global Platform Engines

| Engine | Directory | Purpose |
|:---|:---|:---|
| **Self-Service Portal** | `apps/portal/` | The Next.js developer interface. |
| **Provisioning API** | `apps/provisioning-api/` | FastAPI orchestration engine for IaC automation. |
| **Governance Engine** | `apps/governance-engine/`| Enforces tags, naming, and architectural validations. |
| **Cost Engine** | `apps/cost-engine/` | Aggregates application spend and predicts budget burn. |
| **Template Catalog** | `apps/template-catalog/` | Versioned store of "Golden" application topologies. |
| **Ops Engine** | `apps/ops-engine/` | Automates health checks, restarts, and routine maintenance. |

---

## 🚀 Environment Bootstrapping

Deploy the foundation infrastructure to establish the overarching Application Landing Zone environments.

```bash
cd terraform/environments/prod
terraform init
terraform apply -auto-approve
```

---
<sub>&copy; 2026 Devopstrio &mdash; Standardizing the Application Enterprise.</sub>
