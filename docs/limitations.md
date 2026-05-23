# Limitations and Tradeoffs

## Overview

This document describes the current limitations, tradeoffs and future improvement opportunities of the project.

The project was developed within an academic semester environment with limited time, budget and operational scope.

The architecture intentionally prioritizes:

- Simplicity
- Demonstrability
- Infrastructure automation
- Cloud engineering concepts
- CI/CD integration
- Operational clarity

over production-scale complexity.

---

# Main Design Philosophy

The project follows the Approach A reference application strategy.

This means the existing laboratory microservices project was used as the application foundation while the focus shifted toward:

- Infrastructure as Code
- Cloud networking
- CI/CD
- Deployment automation
- IAM and security
- Containerization
- Distributed systems
- Operational practices

The business logic itself intentionally remains relatively simple.

---

# Academic Scope vs Production Scope

The project demonstrates realistic cloud engineering concepts, but some production-grade concerns were simplified to remain achievable within the semester timeline.

The objective was not to build a commercial-scale platform, but rather to demonstrate understanding of:

- AWS infrastructure
- Terraform
- Docker
- Ansible
- GitHub Actions
- IAM
- Networking
- Event-driven systems

---

# Single EC2 Deployment

Currently the application deploys onto a single EC2 instance.

Advantages:

- Simpler deployment
- Easier debugging
- Lower AWS costs
- Faster implementation
- Easier demonstration during defense

Limitations:

- Single point of failure
- No horizontal scaling
- Limited resilience
- Limited production realism

Future improvement:

```text
ECS / Fargate / Kubernetes
```

---

# Docker Compose in Production-Like Environment

Docker Compose is used for local orchestration and deployment simplicity.

Advantages:

- Fast implementation
- Easy service orchestration
- Good educational value
- Minimal operational complexity

Limitations:

- No orchestration scheduler
- No auto-healing
- No rolling updates
- No service discovery platform
- No native scaling orchestration

Future improvement:

```text
Amazon ECS
Kubernetes
Docker Swarm
```

---

# Publicly Exposed Application Ports

Ports:

```text
8080
8081
8082
8083
```

are exposed for demonstration purposes.

Advantages:

- Simplifies testing
- Easier API validation
- Faster development workflow

Limitations:

- Larger attack surface
- Not ideal for production environments

Future improvement:

- Only expose API Gateway publicly
- Keep internal services private
- Add load balancer
- Add reverse proxy

---

# No HTTPS/TLS

Currently the project uses HTTP instead of HTTPS.

Reason:

- Simplicity during development
- Faster implementation
- Reduced infrastructure complexity

Limitations:

- Traffic encryption absent
- Not production-grade security

Future improvement:

```text
AWS ACM
Application Load Balancer
TLS termination
HTTPS-only communication
```

---

# Simplified Authentication

The current application does not implement full application-level authentication and authorization.

Reason:

- Focus remained on infrastructure and cloud engineering
- Authentication systems were outside semester scope

Limitations:

- No JWT authentication
- No RBAC
- No OAuth integration

Future improvement:

```text
Keycloak
AWS Cognito
JWT security
Role-based authorization
```

---

# Database Simplifications

The local environment still uses H2 databases inside some services.

Advantages:

- Faster startup
- Easier testing
- Simpler development setup

Limitations:

- Not production-realistic
- In-memory persistence
- Data loss after container restart

The cloud deployment introduces Amazon RDS PostgreSQL to address this limitation.

---

# RDS Cost Considerations

Amazon RDS improves realism and persistence, but introduces AWS costs.

Tradeoff:

| Simplicity | Cost |
|---|---|
| H2 | Low |
| PostgreSQL RDS | Higher |

The project intentionally uses:

```text
db.t3.micro
```

to minimize costs.

---

# No Auto Scaling

The infrastructure does not implement Auto Scaling Groups.

Limitations:

- Fixed compute capacity
- Manual scaling required
- No elasticity

Future improvement:

```text
EC2 Auto Scaling Groups
ECS Service Auto Scaling
Kubernetes HPA
```

---

# No Load Balancer

Currently requests access the application instance directly.

Advantages:

- Simpler architecture
- Easier debugging
- Faster deployment

Limitations:

- No traffic distribution
- No high availability
- No TLS termination

Future improvement:

```text
Application Load Balancer
```

---

# Simplified Networking

The infrastructure includes:

- VPC
- Public subnets
- Private subnets
- Route tables
- Internet Gateway

However, it intentionally omits:

- NAT Gateway
- Transit Gateway
- VPN integration
- Peering

Reason:

- Cost reduction
- Simplicity
- Academic scope

---

# NAT Gateway Omission

Private subnets currently do not use NAT Gateway access.

Advantages:

- Lower AWS costs
- Simpler architecture

Limitations:

- Private resources cannot initiate internet outbound traffic directly

Future improvement:

```text
NAT Gateway
```

---

# CI/CD Simplifications

The CI/CD pipeline automates:

- Build
- Test
- Docker image publication
- Terraform validation
- Terraform deployment

However, it does not yet include:

- Blue/Green deployment
- Canary deployment
- Rollback automation
- Full integration testing
- Chaos engineering

Reason:

- Semester scope limitation

---

# Limited Observability

The project currently lacks:

- Centralized logging
- Distributed tracing
- Metrics dashboards
- Alerting systems

Limitations:

- Reduced operational visibility
- Harder production troubleshooting

Future improvement:

```text
CloudWatch
Prometheus
Grafana
OpenTelemetry
ELK Stack
```

---

# Simplified Monitoring

Health checks currently rely mainly on:

```text
/actuator/health
```

Advantages:

- Fast validation
- Simple implementation

Limitations:

- Limited operational insight

Future improvement:

```text
Micrometer
CloudWatch metrics
Prometheus exporters
```

---

# Event-Driven Limitations

The architecture uses Amazon SQS for asynchronous communication.

Current limitations:

- No message ordering guarantees
- No event replay system
- No event schema registry
- No event versioning

Future improvement:

```text
Kafka
EventBridge
Schema Registry
```

---

# No Infrastructure State Backend

Terraform currently uses local state.

Advantages:

- Simpler setup
- Faster implementation

Limitations:

- No remote state collaboration
- No state locking
- Higher risk of state inconsistency

Future improvement:

```text
S3 backend
DynamoDB state locking
```

---

# No Secret Manager

Sensitive values are simplified for demonstration purposes.

Current approach:

- GitHub Secrets
- Terraform variables

Limitations:

- Not ideal for enterprise-scale secret management

Future improvement:

```text
AWS Secrets Manager
HashiCorp Vault
```

---

# Security Simplifications

Security was improved compared to the labs, but still simplified.

Missing features include:

- WAF
- IDS/IPS
- Centralized SIEM
- Runtime threat detection
- Container scanning

Reason:

- Outside semester scope
- Complexity vs educational value tradeoff

---

# Cost vs Realism Tradeoff

The project intentionally balances:

| Goal | Tradeoff |
|---|---|
| Realistic AWS architecture | Increased cost |
| Lower cost | Reduced realism |
| Faster implementation | Simplified architecture |
| More advanced cloud features | Higher operational complexity |

---

# Why Simplicity Was Sometimes Preferred

The project prioritizes educational clarity.

Some production-grade mechanisms were intentionally simplified because:

- They increase debugging complexity
- They increase AWS costs
- They reduce explainability during defense
- They exceed semester scope

The focus remained on demonstrating core cloud engineering competencies effectively.

---

# Multi-AZ Networking Improvement

The infrastructure was upgraded from single-subnet architecture to multiple Availability Zones.

Benefits:

- RDS compatibility
- Better architecture realism
- Improved fault isolation

However:

- The application itself is still single-instance
- True high availability is not yet achieved

---

# Why This Architecture Is Still Valuable

Despite simplifications, the project successfully demonstrates:

- Infrastructure as Code
- Distributed microservices
- Containerization
- Event-driven communication
- CI/CD pipelines
- AWS IAM
- OIDC authentication
- Infrastructure modularization
- Automated provisioning
- Cloud deployment reasoning

The project intentionally prioritizes engineering understanding over excessive production complexity.

---

# Future Evolution Roadmap

Potential future evolution includes:

## Infrastructure

- ECS/Fargate
- Kubernetes
- Auto Scaling
- Multi-region deployment

## Security

- AWS Secrets Manager
- WAF
- TLS everywhere
- Zero Trust networking

## Observability

- CloudWatch dashboards
- OpenTelemetry
- Distributed tracing
- Centralized logs

## CI/CD

- Canary deployments
- Blue/Green deployments
- Rollbacks
- Progressive delivery

## Application

- Authentication
- Authorization
- Better persistence
- Service discovery
- Advanced event processing

---

# Final Reflection

The project intentionally evolved from independent laboratory exercises into a consolidated cloud-native platform.

The final architecture demonstrates practical integration of:

- Terraform
- AWS
- Docker
- Ansible
- GitHub Actions
- IAM/OIDC
- SQS
- RDS
- Distributed microservices

while balancing:

- implementation speed
- operational simplicity
- educational clarity
- cloud engineering realism

within the constraints of an academic semester project.
