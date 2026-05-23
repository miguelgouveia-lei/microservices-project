# Security Guide

## Overview

This document describes the security decisions and IAM design used in the project.

The main security goals are:

- Minimize attack surface
- Avoid hardcoded credentials
- Isolate infrastructure components
- Use least-privilege access
- Protect deployment workflows
- Secure cloud authentication
- Improve fault isolation

The project intentionally prioritizes practical cloud security engineering practices.

---

# Security Principles

The project follows several cloud security principles:

- Least privilege
- Separation of concerns
- Defense in depth
- Infrastructure isolation
- Secret externalization
- Automated authentication
- Failure containment

---

# AWS Identity and Access Management (IAM)

The project uses AWS IAM to control permissions for:

- GitHub Actions
- Terraform
- EC2 instances
- SQS access
- Infrastructure provisioning

---

# OIDC Authentication

The project uses OpenID Connect (OIDC) between GitHub Actions and AWS.

This eliminates the need to store permanent AWS access keys inside GitHub.

---

# Why OIDC Was Chosen

Traditional CI/CD pipelines often store:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

inside GitHub Secrets.

This approach creates long-lived credentials that may leak.

OIDC improves security because:

- No permanent credentials are stored
- Credentials are temporary
- Access is repository-scoped
- AWS validates GitHub identity dynamically
- Credential rotation becomes unnecessary

---

# OIDC Authentication Flow

1. GitHub Actions requests an identity token
2. AWS validates the GitHub OIDC provider
3. GitHub assumes an IAM role
4. Temporary AWS credentials are issued
5. Terraform and deployment workflows execute

---

# OIDC Provider

OIDC Provider URL:

```text
https://token.actions.githubusercontent.com
```

Audience:

```text
sts.amazonaws.com
```

---

# IAM Deployment Role

The project uses the following IAM role:

```text
gha-deployer
```

This role is assumed by GitHub Actions workflows.

---

# Repository Restriction

The IAM trust relationship restricts role assumption to:

```text
repo:miguelgouveia-lei/microservices-project:*
```

This prevents external repositories from assuming the role.

---

# GitHub Secrets

The project uses GitHub Secrets for sensitive configuration.

Configured secrets:

```text
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
AWS_ROLE_TO_ASSUME
```

---

# Why GitHub Secrets Were Used

Secrets are externalized from source code.

Benefits:

- No credentials committed to Git
- Centralized secret management
- Easier credential rotation
- Reduced accidental exposure

---

# No Hardcoded Credentials

The project avoids hardcoded credentials inside:

- Source code
- Terraform files
- Dockerfiles
- GitHub workflows

Sensitive values are externalized using:

- GitHub Secrets
- Environment variables
- IAM roles

---

# Network Isolation

The infrastructure uses a custom VPC with separated subnets.

---

# Public Resources

Public resources include:

- Internet-facing EC2 instances
- API Gateway access points

These components require internet access.

---

# Private Resources

Private resources include:

- Amazon RDS database
- Internal service communication

The database is intentionally isolated from direct public access.

---

# Why RDS Is Private

The database does not require direct internet exposure.

Keeping RDS in a private subnet:

- Reduces attack surface
- Prevents direct inbound internet access
- Restricts communication to application instances only

---

# Security Groups

Security groups are used as virtual firewalls.

Security groups restrict:

- Inbound traffic
- Outbound traffic
- Service-to-service communication

---

# Security Group Design

Examples:

| Resource | Allowed Access |
|---|---|
| API Gateway | HTTP from internet |
| EC2 instances | SSH from trusted IPs |
| RDS | PostgreSQL only from application SG |
| Kafka | Internal communication only |

---

# Principle of Least Privilege

Permissions are intentionally minimized.

Examples:

- GitHub Actions only receives temporary deployment permissions
- SQS access is restricted to required APIs
- Database access is limited to application services
- Security groups avoid unnecessary open ports

---

# SQS Security

Amazon SQS communication is protected using IAM permissions.

Producer permissions:

```text
sqs:SendMessage
sqs:GetQueueUrl
```

Consumer permissions:

```text
sqs:ReceiveMessage
sqs:DeleteMessage
sqs:GetQueueAttributes
```

---

# Dead-Letter Queue (DLQ)

The project uses a DLQ for fault isolation.

Messages are redirected when processing repeatedly fails.

Benefits:

- Prevents infinite retry loops
- Isolates poison messages
- Improves debugging
- Increases resilience

---

# Visibility Timeout

SQS visibility timeout prevents multiple consumers from processing the same message simultaneously.

If the consumer crashes before deleting the message:

- The message becomes visible again
- Another consumer may retry processing

This improves reliability and fault tolerance.

---

# Docker Security

The project uses containerization for service isolation.

Each service runs independently inside its own container.

Benefits:

- Dependency isolation
- Easier deployment
- Reproducible runtime environments
- Simplified scaling

---

# Docker Image Security

Docker images are:

- Built automatically
- Versioned using Git SHA
- Published to DockerHub

Using immutable image tags improves traceability.

---

# CI/CD Security

GitHub Actions workflows use:

- OIDC authentication
- Repository-scoped permissions
- Environment protection rules
- Manual production approval

---

# Production Environment Protection

GitHub Environments are configured to require approval before production deployments.

Environment:

```text
production
```

Benefits:

- Prevents accidental production deployments
- Adds human verification
- Improves operational control

---

# Terraform Security

Terraform infrastructure is versioned and validated automatically.

The pipeline executes:

- terraform fmt
- terraform validate
- terraform plan
- terraform apply

Benefits:

- Infrastructure review before deployment
- Reduced configuration drift
- Consistent environments

---

# Why Infrastructure as Code Improves Security

Manual infrastructure changes are error-prone.

Infrastructure as Code improves:

- Auditability
- Repeatability
- Reviewability
- Consistency

---

# Secrets Handling

Sensitive values are never stored directly in source code.

The project uses:

- GitHub Secrets
- Environment variables
- IAM authentication

Future improvement:

```text
AWS Secrets Manager
```

---

# SSH Access

EC2 access uses SSH key authentication.

Benefits:

- Stronger than password authentication
- Easier key rotation
- Reduced brute-force exposure

---

# Ansible Security

Ansible automates EC2 configuration.

Benefits:

- Reduces manual configuration errors
- Standardizes server setup
- Improves reproducibility

Ansible is executed from Ubuntu/WSL due to better compatibility.

---

# Failure Isolation

The architecture isolates failures through:

- Microservices separation
- Independent containers
- SQS buffering
- Dead-letter queues

This reduces cascading failures.

---

# Event-Driven Security Considerations

Asynchronous communication introduces operational concerns:

- Message duplication
- Delayed processing
- Consumer crashes
- Poison messages

The project addresses these risks using:

- Visibility timeout
- DLQ
- Retry mechanisms

---

# Security Limitations

Current limitations include:

- No HTTPS/TLS termination yet
- No centralized secrets manager
- No WAF
- No intrusion detection
- No centralized logging platform
- No vulnerability scanning pipeline

These were considered outside the scope of the semester project.

---

# Future Improvements

Possible future security improvements:

- AWS Secrets Manager
- HTTPS certificates with ACM
- Load balancer with TLS termination
- AWS WAF
- CloudWatch centralized logging
- Container vulnerability scanning
- IAM permission boundaries
- Multi-factor administrative access
- Private container registry
- Kubernetes RBAC

---

# Security Tradeoffs

The project intentionally prioritizes:

- Simplicity
- Reproducibility
- Demonstrability
- Educational value

Some production-grade hardening mechanisms were simplified to keep the project achievable within the semester timeline.

---

# Security Summary

The project demonstrates practical cloud security engineering through:

- IAM least privilege
- OIDC authentication
- Private subnet isolation
- Security groups
- Secret externalization
- Infrastructure as Code
- Environment protection
- Event-driven fault isolation
- CI/CD security automation

The overall objective was to balance simplicity, operational clarity and modern cloud security practices.
