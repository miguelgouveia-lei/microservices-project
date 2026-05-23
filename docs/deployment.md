# Deployment Guide

## Overview

This document describes the deployment workflow of the project, including:

- Local deployment using Docker Compose
- AWS infrastructure provisioning using Terraform
- EC2 configuration using Ansible
- CI/CD automation using GitHub Actions
- Docker image publishing
- AWS authentication using OIDC

The project follows a cloud-native deployment model combining Infrastructure as Code, containerization and deployment automation.

---

# Repository Structure

```text
Final Project/
├── services/
│   ├── api-gateway/
│   ├── user-service/
│   ├── product-service/
│   └── order-service/
├── infrastructure/
│   └── terraform/
├── ansible/
├── docs/
├── .github/
│   └── workflows/
├── docker-compose.yml
└── README.md
```

---

# Local Deployment

## Start Local Environment

The local environment uses Docker Compose to orchestrate all services.

Required:

- Docker Desktop
- Docker Compose

Run:

```bash
docker compose up -d --build
```

This command:

- Builds all microservices
- Starts Kafka and Zookeeper
- Starts the API Gateway
- Starts User, Product and Order services
- Creates the internal Docker network

---

# Local Services

| Service | Port |
|---|---|
| API Gateway | 8080 |
| User Service | 8081 |
| Product Service | 8082 |
| Order Service | 8083 |
| Kafka | 9092 |
| Zookeeper | 2181 |

---

# Health Validation

The application exposes Spring Boot Actuator health endpoints.

Validation commands:

```bash
curl http://localhost:8080/actuator/health
curl http://localhost:8081/actuator/health
curl http://localhost:8082/actuator/health
curl http://localhost:8083/actuator/health
```

Expected result:

```json
{
  "status": "UP"
}
```

---

# Docker Compose Validation

To inspect the deployment configuration:

```bash
docker compose config
```

To verify running containers:

```bash
docker compose ps
```

---

# Terraform Infrastructure Deployment

Terraform is responsible for provisioning AWS infrastructure.

Terraform directory:

```text
infrastructure/terraform
```

---

# Provisioned AWS Resources

The Terraform configuration provisions:

- VPC
- Public subnet
- Private subnet
- Internet Gateway
- Route tables
- Security groups
- EC2 instances
- Amazon RDS PostgreSQL
- Amazon SQS queues
- Dead-letter queue (DLQ)

---

# Terraform Workflow

## Initialize Terraform

```bash
cd infrastructure/terraform
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## Generate Execution Plan

```bash
terraform plan
```

## Apply Infrastructure

```bash
terraform apply
```

---

# Why Terraform Was Used

Terraform allows:

- Infrastructure versioning
- Reproducible environments
- Automated provisioning
- Modular infrastructure design
- Separation between network, compute and messaging resources

Infrastructure is organized using reusable modules.

---

# Ansible Configuration Management

Terraform provisions infrastructure, while Ansible configures EC2 instances after creation.

Ansible responsibilities:

- Install Docker
- Configure Linux packages
- Configure users
- Deploy containers
- Configure application services

---

# Ansible Directory

```text
ansible/
├── inventory.ini
├── playbook.yml
├── configure-ec2.yml
├── deploy-app.yml
└── roles/
```

---

# Why Ansible Was Used

Terraform focuses on infrastructure provisioning.

Ansible focuses on operating system configuration and application deployment.

This separation improves maintainability and follows common DevOps practices.

---

# Ansible Execution

Ansible is executed from Ubuntu/WSL because Ansible has limited native support on Windows Git Bash.

Example:

```bash
cd ansible

ansible all -i inventory.ini -m ping

ansible-playbook -i inventory.ini playbook.yml

ansible-playbook -i inventory.ini configure-ec2.yml

ansible-playbook -i inventory.ini deploy-app.yml
```

---

# Docker Image Deployment

Each service includes its own Dockerfile.

Images are automatically:

- Built
- Tagged
- Published to DockerHub

The project uses immutable tags based on Git commit SHA.

---

# DockerHub Image Validation

Example:

```bash
docker pull <dockerhub-user>/product-service:latest
```

---

# GitHub Actions CI/CD

The project uses GitHub Actions for CI/CD automation.

Workflows are located under:

.github/workflows/
```
---

# Main Workflows
|---|---|
| hello.yml | GitHub Actions validation |
| ci.yml | Maven validation and tests |
| matrix.yml | Parallel service builds |
| production.yml | Protected production deployment |
| release.yml | Tag-based release workflow |
---


The CI workflow performs:
- Maven validation
- Compilation
- Test artifact upload

- Pull requests
- Pushes to main

---


The Docker pipeline:

1. Builds Docker images
2. Pushes images to DockerHub
3. Tags images using:
   - Git SHA

---

# AWS Authentication Using OIDC

The project uses OpenID Connect (OIDC) between GitHub Actions and AWS.

This avoids storing permanent AWS access keys inside GitHub Secrets.

---

# OIDC Flow

1. GitHub Actions requests a temporary identity token
2. AWS validates the GitHub identity provider
3. GitHub assumes the IAM role `gha-deployer`
4. Temporary credentials are issued automatically

---

# AWS Role

IAM Role:

```text
gha-deployer
```

Repository secret:

```text
AWS_ROLE_TO_ASSUME
```

---

# Why OIDC Was Chosen

OIDC improves security because:

- No static AWS credentials are stored
- Credentials are temporary
- Access is restricted to the repository
- Blast radius is reduced if secrets leak

---

# Terraform Automation Pipeline

Terraform workflows automatically execute:

- terraform fmt
- terraform validate
- terraform plan
- terraform apply

Behavior:

| Event | Action |
|---|---|
| Pull Request | terraform plan |
| Push to main | terraform apply |

---

# Matrix Builds

The project uses matrix builds to build services in parallel.

Services:

- user-service
- product-service
- order-service

Benefits:

- Faster pipelines
- Better scalability
- Independent builds

---

# Environment Protection

GitHub Environments are used to protect production deployments.

Environment:

```text
production
```

Deployments require manual approval before execution.

---

# Event-Driven Communication

The project uses Amazon SQS for asynchronous communication.

Producer:

- product-service

Consumer:

- order-service

---

# SQS Benefits

Using SQS allows:

- Service decoupling
- Retry mechanisms
- Failure isolation
- Asynchronous processing
- Dead-letter queues

---

# Dead-Letter Queue

The project includes a DLQ (Dead-Letter Queue).

Messages are redirected to the DLQ when:

- The consumer repeatedly fails
- Visibility timeout expires repeatedly
- Message processing cannot complete

---

# Why SQS Instead of HTTP Only

Synchronous HTTP creates temporal coupling.

If the consumer is unavailable:

- HTTP calls fail immediately

With SQS:

- Producers continue working
- Messages remain durable in the queue
- Consumers process later

---

# Deployment Strategy

The deployment workflow follows:

1. Developer pushes code
2. GitHub Actions runs CI
3. Docker images are built and published
4. Terraform validates infrastructure
5. Infrastructure is applied
6. Ansible configures EC2
7. Containers are deployed

---

# Security Decisions

Security measures include:

- IAM least privilege
- OIDC authentication
- GitHub Secrets
- Private RDS subnet
- Security groups
- No hardcoded credentials
- DLQ for failure isolation

---

# Public vs Private Resources

Public resources:

- API Gateway
- Internet-facing EC2 instances

Private resources:

- Amazon RDS
- Internal service communication

This reduces attack surface and improves isolation.

---

# Validation Checklist

Before demonstration:

- All Docker containers running
- Terraform validated
- GitHub Actions workflows green
- OIDC authentication working
- DockerHub images published
- SQS queues operational
- Health endpoints responding
- EC2 reachable through Ansible

---

# Demonstration Flow

During the defense the following should be demonstrated:

1. GitHub repository structure
2. Terraform code organization
3. GitHub Actions workflow execution
4. DockerHub image publication
5. AWS Console infrastructure
6. Docker Compose local deployment
7. SQS queue communication
8. Health endpoints
9. Ansible execution

---

# Future Improvements

Possible future improvements include:

- ECS/Fargate deployment
- Auto Scaling Groups
- AWS Secrets Manager
- CloudWatch centralized logging
- OpenTelemetry tracing
- Multi-AZ deployment
- Load balancers
- HTTPS/TLS certificates
- Kubernetes orchestration

---

# Conclusion

The project demonstrates the practical application of:

- Cloud infrastructure provisioning
- Infrastructure as Code
- Containerization
- Distributed systems
- Event-driven architecture
- CI/CD automation
- Security and IAM
- Operational cloud engineering practices

The project intentionally prioritizes engineering quality, automation and infrastructure reasoning over complex business logic.   - latest
# Docker Pipeline
The CI workflow executes automatically on:

- Unit tests

# CI Pipeline

| reusable-image.yml | Reusable Docker workflow |
| terraform.yml | Terraform plan/apply |
| aws-test.yml | AWS OIDC validation |
| image.yml | Docker image build and push |
| Workflow | Purpose |



