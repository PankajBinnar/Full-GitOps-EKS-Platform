# Full GitOps EKS Platform

## Project Blueprint and Implementation Plan

**Repository:** `Full-GitOps-EKS-Platform`\
**Project type:** Cloud Infrastructure, DevOps, GitOps and Platform
Engineering\
**Primary cloud:** AWS\
**Application workload:** Food Delivery Platform (React frontend +
FastAPI backend)\
**Infrastructure as Code:** Terraform\
**CI:** GitHub Actions\
**Container platform:** Docker + Amazon EKS\
**GitOps/CD:** Argo CD + Helm\
**Observability:** Prometheus + Grafana + Loki + Grafana Alloy +
Alertmanager

------------------------------------------------------------------------

## 1. Project Overview

The Full GitOps EKS Platform is a production-style learning project that
demonstrates how a development team can build, deploy, operate, monitor
and maintain an application on AWS with automation.

The project uses Terraform to provision cloud infrastructure, Docker to
package the application, GitHub Actions to test and publish container
images, and Argo CD to continuously reconcile Kubernetes workloads with
configuration stored in Git. Prometheus, Grafana and logging/alerting
tools provide operational visibility.

### 1.1 Problem this project addresses

When application deployment and infrastructure management are performed
manually, teams can experience:

-   Repetitive and error-prone infrastructure setup.
-   Inconsistent environments between development and production.
-   Manual application builds and deployments.
-   Limited visibility into application and cluster health.
-   Slow detection and recovery from failures.
-   Unclear deployment history and configuration changes.

### 1.2 Main objective

Build an automated platform that provisions AWS infrastructure, deploys
an application to Amazon EKS through a GitOps workflow, and provides
monitoring, logging, alerting, security and recovery practices.

### 1.3 Final outcomes

At completion, the repository should contain:

1.  Reusable Terraform code for AWS infrastructure.
2.  A containerized application deployed on Amazon EKS.
3.  A GitHub Actions CI pipeline.
4.  An Argo CD GitOps deployment workflow.
5.  Kubernetes and Helm configuration.
6.  Monitoring dashboards, centralized logs and alerts.
7.  Security, backup, recovery and rollback procedures.
8.  Architecture diagrams, test evidence, metrics and runbooks.

> This is a learning project. Production readiness must be demonstrated
> through testing and documented controls; using production-style tools
> alone does not make a system production-ready.

------------------------------------------------------------------------

## 2. High-Level Architecture

``` mermaid
flowchart TD
    DEV[Developer] --> APP[Application Source Repository]
    APP --> CI[GitHub Actions CI]
    CI --> TEST[Tests and Security Checks]
    TEST --> BUILD[Build Docker Images]
    BUILD --> ECR[Amazon ECR]
    CI --> CONFIG[GitOps Configuration Repository]
    ECR --> CONFIG
    CONFIG --> ARGO[Argo CD on EKS]
    ARGO --> EKS[Amazon EKS Cluster]
    EKS --> WORKLOADS[Frontend and Backend Pods]
    WORKLOADS --> DATA[Database and Cache Services]
    EKS --> PROM[Prometheus]
    WORKLOADS --> LOGS[Grafana Alloy and Loki]
    PROM --> GRAFANA[Grafana Dashboards]
    LOGS --> GRAFANA
    PROM --> ALERT[Alertmanager]
    ALERT --> SLACK[Slack Notifications]

    TF[Terraform] --> AWS[AWS Network, IAM, ECR and EKS]
    AWS --> EKS
```

### 2.1 Important workflow distinction

-   **Terraform** provisions and updates cloud infrastructure.
-   **GitHub Actions** validates source code, builds images and
    publishes them to ECR.
-   **GitOps configuration in Git** declares the desired Kubernetes
    application version and configuration.
-   **Argo CD** watches the GitOps repository and reconciles the EKS
    cluster to that desired state.
-   **Kubernetes on EKS** runs and manages application workloads.
-   **Prometheus, Grafana, Loki and Alertmanager** provide metrics,
    dashboards, logs and notifications.

Argo CD does not automatically deploy a newly pushed ECR image merely
because the image exists. The desired image tag or digest must be
updated in the GitOps configuration repository, either by a controlled
CI step or an image automation tool. That Git change is then reconciled
by Argo CD.

------------------------------------------------------------------------

# 3. Development Lifecycle: Phase 1 to Phase 11

## Phase 1 --- Planning and Architecture Design

**Purpose:** Define what will be built, why it is needed, how the
components interact and what completion means.

### Tasks

1.  Write the project problem statement and objectives.
2.  Identify application components: frontend, backend, database and
    cache.
3.  Identify AWS services and DevOps tools.
4.  Draw the high-level architecture and deployment flow.
5.  Decide repository boundaries and branching strategy.
6.  Define development, staging and production-like environments.
7.  Identify cost, security and operational risks.
8.  Define measurable acceptance criteria.

### Key design decisions

-   Use AWS EKS as the managed Kubernetes control plane.
-   Use Terraform for repeatable infrastructure provisioning.
-   Use GitHub Actions for CI.
-   Use Amazon ECR for container image storage.
-   Use Argo CD and Helm for GitOps-based deployment.
-   Use private subnets for worker nodes where practical.
-   Use at least two Availability Zones for the learning architecture.
-   Prefer managed AWS data services for a more realistic deployment
    where budget permits.
-   Start with a small, cost-conscious environment and scale only when
    required.

### Deliverables

-   `docs/architecture/high-level-architecture.md`
-   `docs/architecture/deployment-flow.md`
-   Architecture diagram.
-   Technology selection and decision notes.
-   Project scope and acceptance criteria.

### Completion criteria

-   Every major component has a defined responsibility.
-   The path from source-code change to deployment is documented.
-   AWS resources and expected costs have been considered.
-   The project can be divided into independently testable phases.

------------------------------------------------------------------------

## Phase 2 --- Application Development and Local Validation

**Purpose:** Prepare a working application before introducing cloud
infrastructure.

### Application scope

Use the Food Delivery Platform as the workload.

-   React frontend.
-   FastAPI backend.
-   PostgreSQL database.
-   Redis cache.
-   Optional Kafka integration if the existing application requires it.

### Tasks

1.  Review the existing application and document how to run it.
2.  Configure environment variables without committing secrets.
3.  Confirm frontend-to-backend API communication.
4.  Confirm backend-to-database connectivity.
5.  Add or verify health endpoints, such as `/health` and `/ready`.
6.  Add structured application logging.
7.  Add automated unit and API tests.
8.  Verify error handling and database migrations.
9.  Run the complete application locally.

### Deliverables

-   Working frontend and backend.
-   Database schema and migration process.
-   Health and readiness endpoints.
-   Automated tests.
-   Local setup instructions in the application README.

### Completion criteria

-   The application starts reliably on a developer machine.
-   Critical APIs and database operations work.
-   Tests pass.
-   Secrets are supplied through environment variables and are not
    committed.

------------------------------------------------------------------------

## Phase 3 --- Containerization with Docker

**Purpose:** Package the application so it runs consistently across
environments.

### Tasks

1.  Write a Dockerfile for the backend.
2.  Write a Dockerfile for the frontend.
3.  Use appropriate production build stages and small base images.
4.  Run containers as non-root users where practical.
5.  Add `.dockerignore` files.
6.  Configure container ports and environment variables.
7.  Configure Docker Compose for local multi-service testing.
8.  Add container health checks where appropriate.
9.  Build, run and inspect the images.
10. Scan images for known vulnerabilities.

### Deliverables

-   Backend Dockerfile.
-   Frontend Dockerfile.
-   Docker Compose configuration.
-   `.dockerignore` files.
-   Container build and run documentation.

### Completion criteria

-   Frontend and backend images build successfully.
-   Containers start and communicate correctly.
-   Application health checks pass.
-   Images do not contain credentials or unnecessary build files.

------------------------------------------------------------------------

## Phase 4 --- AWS Infrastructure Design and Provisioning with Terraform

**Purpose:** Create repeatable, version-controlled AWS infrastructure.

### Infrastructure scope

**Networking** - VPC. - Public and private subnets across at least two
Availability Zones. - Internet Gateway. - Route tables and routes. - NAT
Gateway or a documented lower-cost alternative for non-production
learning. - Security groups and network access rules.

**Identity and access** - IAM roles and policies following least
privilege. - EKS cluster and node permissions. - GitHub Actions
authentication to AWS using OIDC rather than long-lived access keys.

**Container registry and Kubernetes infrastructure** - Amazon ECR
repositories. - EKS cluster. - Managed node group or another selected
compute model. - Required EKS add-ons and IAM integration.

**Terraform state** - Remote state in an S3 bucket. - State locking
using S3 lockfiles where supported by the selected Terraform version. -
State encryption and restricted access. - Separate state/environment
configuration for environments where appropriate.

### Tasks

1.  Install and configure Terraform and AWS CLI.
2.  Set up an AWS account and a least-privilege deployment identity.
3.  Create reusable Terraform modules.
4.  Define variables, outputs and environment-specific values.
5.  Configure remote state and locking.
6.  Run `terraform fmt` and `terraform validate`.
7.  Review changes with `terraform plan`.
8.  Provision the network, IAM, ECR and EKS resources.
9.  Verify resources in AWS and through the AWS CLI.
10. Document safe infrastructure destruction and recovery.

### Suggested Terraform layout

``` text
terraform/
├── modules/
│   ├── vpc/
│   ├── iam/
│   ├── ecr/
│   └── eks/
└── environments/
    ├── dev/
    └── prod/
```

### Deliverables

-   Reusable Terraform modules.
-   Environment-specific Terraform configuration.
-   Remote state configuration.
-   AWS infrastructure.
-   Provisioning and cleanup instructions.

### Completion criteria

-   Terraform can plan and provision the intended resources.
-   Infrastructure is reproducible from code.
-   State is stored remotely and protected.
-   IAM permissions and network access are restricted appropriately.
-   Resource costs and cleanup steps are documented.

------------------------------------------------------------------------

## Phase 5 --- Kubernetes Configuration and Initial EKS Deployment

**Purpose:** Configure Kubernetes resources and run the application on
EKS.

### Topics and resources

-   Namespaces.
-   Pods.
-   Deployments.
-   Services.
-   ConfigMaps.
-   Secrets.
-   Ingress and AWS Load Balancer Controller, if selected.
-   Resource requests and limits.
-   Startup, readiness and liveness probes.
-   Horizontal Pod Autoscaler.
-   Pod disruption budgets where appropriate.

### Tasks

1.  Configure `kubectl` access to the EKS cluster.
2.  Verify cluster nodes and system pods.
3.  Create application namespaces.
4.  Write Kubernetes manifests or Helm charts.
5.  Configure frontend and backend Deployments.
6.  Configure Services and external access.
7.  Supply application configuration securely.
8.  Configure health probes and resource limits.
9.  Deploy the application manually for the initial validation.
10. Test connectivity, scaling and recovery.

### Deliverables

-   Kubernetes manifests or Helm charts.
-   Namespace and service configuration.
-   Working application on EKS.
-   Deployment and troubleshooting instructions.

### Completion criteria

-   Application Pods become Ready.
-   Frontend can reach the backend.
-   Backend can reach required data services.
-   Application can be accessed through the configured entry point.
-   Failed Pods are detected and handled as expected.

------------------------------------------------------------------------

## Phase 6 --- CI Pipeline Development with GitHub Actions

**Purpose:** Automate code validation, testing, image creation and image
publishing.

### Pipeline stages

1.  Trigger on pull requests and selected branch pushes.
2.  Check out source code.
3.  Install dependencies.
4.  Run formatting, linting and tests.
5.  Run security and dependency checks.
6.  Build frontend and backend Docker images.
7.  Scan images.
8.  Authenticate to AWS using GitHub OIDC.
9.  Push versioned images to Amazon ECR.
10. Publish build results and image references.

### Image tagging strategy

Use immutable identifiers such as the Git commit SHA. Avoid relying only
on the mutable `latest` tag.

Example:

``` text
<account-id>.dkr.ecr.<region>.amazonaws.com/food-delivery-api:<git-sha>
```

### Deliverables

-   GitHub Actions workflow files.
-   Automated test and build pipeline.
-   ECR repositories containing versioned images.
-   CI documentation.

### Completion criteria

-   Pull requests run validation checks.
-   Failed tests prevent publishing.
-   Successful builds publish images to ECR.
-   GitHub authenticates to AWS through OIDC.
-   Image tags can be traced to source commits.

------------------------------------------------------------------------

## Phase 7 --- GitOps Implementation with Argo CD

**Purpose:** Make Git the source of truth for the desired application
deployment state.

### Tasks

1.  Create a GitOps configuration repository or a clearly separated
    GitOps directory.
2.  Store Helm charts or Kubernetes deployment configuration.
3.  Configure environment-specific values.
4.  Install Argo CD on EKS.
5.  Configure Argo CD access to the GitOps repository.
6.  Create Argo CD Application resources.
7.  Configure automated sync and pruning carefully.
8.  Configure self-healing where appropriate.
9.  Define how CI updates the image tag or digest in Git.
10. Test synchronization, drift correction and rollback.

### Suggested repository layout

``` text
gitops-config/
├── apps/
│   ├── food-delivery-frontend/
│   └── food-delivery-backend/
├── charts/
│   └── food-delivery/
└── environments/
    ├── dev/
    └── prod/
```

### Deployment flow

1.  A developer pushes application code.
2.  GitHub Actions tests and builds the application.
3.  CI pushes an immutable image to ECR.
4.  CI updates the desired image reference in the GitOps repository, or
    an image automation controller proposes that update.
5.  Argo CD detects the Git change.
6.  Argo CD applies the desired configuration to EKS.
7.  Kubernetes rolls out the new application version.
8.  Argo CD reports synchronization and health status.

### Deliverables

-   Argo CD installation and configuration.
-   GitOps repository.
-   Helm charts or Kubernetes configuration.
-   Automated image-reference update workflow.
-   Rollback instructions.

### Completion criteria

-   GitOps configuration is the declared source of truth.
-   A Git change triggers the expected deployment.
-   Argo CD reports sync and health status.
-   Manual drift is detected and handled according to policy.
-   Previous known-good versions can be restored.

------------------------------------------------------------------------

## Phase 8 --- Monitoring, Observability and Logging

**Purpose:** Understand application and infrastructure health and
troubleshoot problems.

### Metrics and dashboards

**Prometheus** - Scrape application and cluster metrics. - Monitor CPU
and memory. - Monitor Pod and node health. - Monitor request rate,
latency and errors where application instrumentation exists.

**Grafana** - Build Kubernetes cluster dashboards. - Build application
dashboards. - Display API latency, request rate and error rate. -
Display resource usage and capacity.

**Logging** - Use Grafana Alloy to collect and forward logs. - Use Loki
to store and query logs. - Include useful metadata such as namespace,
Pod and application labels. - Avoid logging credentials or sensitive
user data.

### Tasks

1.  Deploy Prometheus using a maintained Helm chart or operator
    distribution.
2.  Configure metrics collection.
3.  Install Grafana and create dashboards.
4.  Configure application instrumentation where required.
5.  Deploy Loki and Grafana Alloy.
6.  Verify log collection and querying.
7.  Define basic service-level indicators.
8.  Document dashboard usage and troubleshooting queries.

### Deliverables

-   Prometheus configuration.
-   Grafana dashboards.
-   Loki and Alloy configuration.
-   Monitoring and logging documentation.

### Completion criteria

-   Cluster and application metrics are visible.
-   Logs can be searched by application and Kubernetes metadata.
-   Dashboards help identify common failures and resource pressure.
-   Monitoring components themselves are checked for health.

------------------------------------------------------------------------

## Phase 9 --- Security and Reliability

**Purpose:** Reduce security risk and improve the platform's ability to
handle failures.

### Security tasks

-   Apply least-privilege IAM policies.
-   Use GitHub OIDC for CI authentication.
-   Store application secrets in AWS Secrets Manager or another approved
    secret manager.
-   Integrate secrets into Kubernetes through a secure mechanism.
-   Encrypt data in transit and at rest where applicable.
-   Scan container images and dependencies.
-   Restrict network access with security groups and Kubernetes
    NetworkPolicies where supported.
-   Protect GitHub branches and require reviews for important changes.
-   Avoid committing credentials, tokens or private keys.

### Reliability tasks

-   Configure readiness, liveness and startup probes as appropriate.
-   Configure resource requests and limits.
-   Configure Horizontal Pod Autoscaler.
-   Configure Pod Disruption Budgets for workloads that need them.
-   Test node and Pod failures.
-   Implement controlled rolling, blue-green or canary releases.
-   Configure backup and recovery for persistent data.
-   Document rollback and incident procedures.

### Deliverables

-   Security configuration.
-   Secret-management workflow.
-   Deployment strategy.
-   Backup and restore runbooks.
-   Reliability test results.

### Completion criteria

-   No application credentials are stored in source control.
-   Access follows least privilege.
-   Image and dependency scanning is included.
-   Recovery and rollback procedures have been tested.
-   Known security and reliability limitations are documented.

------------------------------------------------------------------------

## Phase 10 --- Testing, Performance and Optimization

**Purpose:** Verify the whole platform, measure its behavior and improve
it based on evidence.

### Test scenarios

1.  Successful application deployment.
2.  Failed test blocks image publishing.
3.  Failed image build is reported.
4.  New image is deployed through GitOps.
5.  Invalid configuration is detected.
6.  Pod crash and recovery.
7.  High CPU or memory usage.
8.  Application endpoint failure and alert delivery.
9.  GitOps drift detection and reconciliation.
10. Rollback to a previous working version.
11. Database backup and restore.
12. Load testing under controlled traffic.

### Metrics to record

-   CI pipeline duration.
-   Deployment duration.
-   Deployment frequency during testing.
-   Rollback duration.
-   API response latency (for example p50, p95 and p99).
-   Request throughput.
-   Error rate.
-   CPU and memory utilization.
-   Recovery time in defined failure scenarios.
-   Estimated AWS cost for the test period.

Do not invent performance or availability claims. Record the workload,
test conditions, date and actual measured results.

### Cost optimization

-   Use small instance sizes suitable for the workload.
-   Stop or destroy non-production resources when not in use.
-   Review NAT Gateway, load balancer, EKS, EC2, EBS, ECR and
    data-transfer charges.
-   Set AWS Budgets and billing alerts.
-   Remove unused volumes, snapshots, addresses and load balancers.
-   Keep a resource cleanup checklist.

### Deliverables

-   Test plan and test results.
-   Load-test report.
-   Failure and recovery evidence.
-   Performance metrics.
-   Cost review and optimization notes.

### Completion criteria

-   Critical deployment and recovery scenarios pass.
-   Performance results are reproducible and documented.
-   Alerts are verified.
-   Cost and resource cleanup procedures are documented.

------------------------------------------------------------------------

## Phase 11 --- Documentation, Portfolio and Final Presentation

**Purpose:** Make the project understandable, reproducible and
demonstrable to another engineer or interviewer.

### Documentation to prepare

-   Project overview and problem statement.
-   High-level and detailed architecture diagrams.
-   Technology choices and trade-offs.
-   Repository structure.
-   Prerequisites and setup instructions.
-   Terraform provisioning instructions.
-   Application deployment instructions.
-   CI and GitOps workflow.
-   Monitoring and logging guide.
-   Security considerations.
-   Troubleshooting guide.
-   Backup, restore and rollback runbooks.
-   Test results and measured metrics.
-   Cost notes and cleanup instructions.

### Portfolio evidence

Capture screenshots or sanitized evidence of:

-   Terraform plan and provisioned AWS resources.
-   EKS nodes and application Pods.
-   GitHub Actions successful and failed runs.
-   ECR image versions.
-   Argo CD application sync and health.
-   Grafana dashboards.
-   Loki log queries.
-   Alert notifications.
-   A successful rollback or recovery test.

Never include account IDs if they are not needed, access keys,
passwords, tokens, private endpoints or other sensitive information in
public screenshots.

### Completion criteria

-   A new reader can understand the architecture.
-   Setup and deployment steps are reproducible.
-   All major phases have evidence.
-   Actual metrics and limitations are reported honestly.
-   Cleanup instructions are clear.
-   The GitHub repository is ready to share.

------------------------------------------------------------------------

# 4. Suggested GitHub Repository Structure

Use one main repository for project documentation, Terraform,
application deployment configuration and automation. The application
source can remain in its existing repository and be referenced here, or
be included as a subdirectory if that is easier to maintain.

``` text
Full-GitOps-EKS-Platform/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── docs/
│   ├── project-overview.md
│   ├── architecture/
│   │   ├── high-level-architecture.md
│   │   ├── infrastructure-architecture.md
│   │   └── deployment-flow.md
│   ├── decisions/
│   ├── runbooks/
│   ├── testing/
│   └── screenshots/
│
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── iam/
│   │   ├── ecr/
│   │   └── eks/
│   └── environments/
│       ├── dev/
│       └── prod/
│
├── kubernetes/
│   ├── namespaces/
│   ├── manifests/
│   └── helm/
│
├── gitops/
│   ├── applications/
│   ├── charts/
│   └── environments/
│       ├── dev/
│       └── prod/
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── image-build-push.yml
│       └── terraform-checks.yml
│
├── observability/
│   ├── prometheus/
│   ├── grafana/
│   ├── loki/
│   └── alertmanager/
│
├── security/
│   ├── image-scanning/
│   └── policies/
│
└── scripts/
    ├── setup/
    ├── validation/
    └── cleanup/
```

Adapt this structure as the implementation evolves. Do not create empty
folders or duplicate configuration just to match the diagram.

------------------------------------------------------------------------

# 5. Git Branching and Collaboration Strategy

A simple strategy for an individual learning project:

-   `main`: reviewed, stable project state.
-   `development`: integration branch for completed work.
-   `feature/<name>`: isolated implementation work.

Example:

``` text
main
 └── development
      ├── feature/terraform-vpc
      ├── feature/terraform-eks
      ├── feature/docker-images
      ├── feature/github-actions
      ├── feature/argocd-gitops
      └── feature/observability
```

Use pull requests, even when working alone, to practice review and
change tracking. Protect `main` from direct unreviewed changes.

------------------------------------------------------------------------

# 6. Project Milestone Tracker

Update this table as each phase is implemented. A phase is complete only
after its acceptance criteria and evidence are recorded.

  Phase   Milestone                          Status        Evidence / Notes
  ------- ---------------------------------- ------------- ------------------
  1       Planning and architecture          Not started   
  2       Application development            Not started   
  3       Docker containerization            Not started   
  4       Terraform and AWS infrastructure   Not started   
  5       Kubernetes and EKS deployment      Not started   
  6       GitHub Actions CI                  Not started   
  7       Argo CD GitOps                     Not started   
  8       Monitoring and logging             Not started   
  9       Security and reliability           Not started   
  10      Testing and optimization           Not started   
  11      Documentation and portfolio        Not started   

Suggested status values: `Not started`, `In progress`, `Blocked`,
`Completed`.

------------------------------------------------------------------------

# 7. Recommended Implementation Rules

1.  Build and test locally before deploying to AWS.
2.  Understand each AWS resource before provisioning it.
3.  Use Terraform plans and code review before applying infrastructure
    changes.
4.  Never commit secrets, Terraform state files, kubeconfig files or
    credentials.
5.  Use GitHub OIDC instead of long-lived AWS keys for CI.
6.  Use immutable container image tags.
7.  Update GitOps configuration explicitly when publishing a new image.
8.  Keep application source and deployment configuration
    responsibilities clear.
9.  Test failure and recovery scenarios, not only successful
    deployments.
10. Record actual metrics and costs.
11. Destroy temporary AWS resources when they are not required.
12. Keep a short engineering decision log explaining important choices
    and trade-offs.

------------------------------------------------------------------------

# 8. Cost and Safety Checklist

Before creating AWS resources:

-   [ ] Enable MFA for the AWS account.
-   [ ] Configure an AWS Budget and billing alerts.
-   [ ] Choose a region and check service availability.
-   [ ] Estimate EKS, EC2, NAT Gateway, load balancer, EBS and
    data-transfer costs.
-   [ ] Use least-privilege IAM.
-   [ ] Avoid public access to worker nodes and databases.
-   [ ] Confirm Terraform state storage and protection.
-   [ ] Document the resources that must be destroyed.
-   [ ] Verify cleanup after each temporary experiment.

**Important:** EKS clusters and related AWS resources can generate
charges even when the application receives no traffic. Review current
AWS pricing before provisioning. A local Kubernetes environment such as
kind or Minikube can be used for early Kubernetes practice before
creating EKS.

------------------------------------------------------------------------

# 9. Definition of Done

The project is complete when:

-   [ ] Infrastructure can be provisioned through Terraform.
-   [ ] The application runs on AWS EKS.
-   [ ] GitHub Actions tests and builds application images.
-   [ ] Images are published to Amazon ECR.
-   [ ] GitOps configuration controls the desired deployment state.
-   [ ] Argo CD deploys and reconciles application changes.
-   [ ] Prometheus and Grafana show useful operational metrics.
-   [ ] Logs can be searched centrally.
-   [ ] Alerts are delivered and verified.
-   [ ] Security controls and secret management are documented.
-   [ ] Rollback and recovery procedures have been tested.
-   [ ] Performance, reliability and cost results are documented.
-   [ ] The repository has clear setup instructions, diagrams and
    evidence.

## Final Project Goal

Build and demonstrate an end-to-end platform in which a developer can
commit application code, have it tested and packaged automatically,
publish a versioned image, update the desired deployment state in Git,
and let Argo CD deploy that version to AWS EKS. The running platform
should be observable, secured appropriately, testable and recoverable.

**Recommended execution order:** Complete Phase 1 first, review its
architecture and decisions, then proceed one phase at a time. Do not
provision the full AWS environment until the design, application
requirements and cost controls are understood.
