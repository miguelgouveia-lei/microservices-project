# Cloud Information Systems — Final Project

## Overview

This project implements a cloud-native microservices architecture deployed on AWS using Infrastructure as Code and automated CI/CD pipelines.

The platform includes:
- Microservices developed with Spring Boot
- API Gateway
- Docker containerization
- Terraform infrastructure provisioning
- GitHub Actions CI/CD
- Ansible deployment automation
- AWS cloud deployment

---

## Technologies Used

- Java 21
- Spring Boot 3
- Spring Cloud Gateway
- Docker
- Docker Hub
- Terraform
- AWS EC2
- AWS VPC
- AWS SQS
- AWS RDS
- GitHub Actions
- Ansible

---

## Repository Structure

```text
project/
├── README.md
├── docs/
├── services/
├── infrastructure/
│   └── terraform/
├── ansible/
└── .github/
    └── workflows/
```

## Microservices

| Service | Port |
|---------|------|
| API Gateway | 8080 |
| User Service | 8081 |
| Product Service | 8082 |
| Order Service | 8083 |

## Deployment Pipeline

1. Developer pushes to GitHub
2. GitHub Actions starts CI/CD
3. Docker images are built and pushed to Docker Hub
4. Terraform provisions AWS infrastructure
5. Ansible deploys containers into EC2
6. Services become publicly accessible

## Infrastructure Components

- VPC
- Public Subnets
- Security Groups
- EC2 Instance
- RDS Database
- SQS Queue
- Internet Gateway
- Route Tables

## Health Check

Example:

```bash
curl http://<EC2_PUBLIC_IP>:8080/actuator/health
```

Expected response:

```json
{"status":"UP"}
```

---

## System Architecture

### Architecture Overview

The system follows a microservices architecture deployed in AWS.

### Components

- API Gateway
- User Service
- Product Service
- Order Service
- AWS SQS
- AWS RDS
- Docker Network
- GitHub Actions
- Terraform
- Ansible

### Request Flow

Client → API Gateway → Microservice → Database

### Event-Driven Communication

The Order Service publishes events into AWS SQS queues.

### CI/CD Flow

GitHub Push → GitHub Actions → Docker Hub → Terraform → AWS → Ansible → Docker Containers

### Networking Design

- Custom VPC
- Public subnets
- Security groups
- Internet gateway
- Internal Docker network

---

## Setup Guide

### Prerequisites

- AWS Account
- Docker
- Terraform
- Git
- Ansible
- Java 21

### AWS Requirements

- IAM Role
- OIDC Provider
- EC2 Key Pair
- GitHub Secrets

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| AWS_ROLE_TO_ASSUME | IAM role ARN |
| EC2_SSH_PRIVATE_KEY | SSH private key |

### Clone Repository

```bash
git clone <repository-url>
cd microservices-project
```

---

## Deployment Guide

### Terraform Deployment

```bash
cd infrastructure/terraform
terraform init
terraform plan
terraform apply
```

### CI/CD Deployment

Push directly to main:

```bash
git push origin main
```

GitHub Actions automatically:
- builds images
- pushes images to Docker Hub
- provisions infrastructure
- deploys services

### Verify Deployment

```bash
curl http://<EC2_PUBLIC_IP>:8080/actuator/health
```

---

## Security Decisions

### Security Controls

- IAM OIDC authentication
- GitHub Secrets
- Security Groups
- SSH key authentication
- Private AWS credentials
- Least privilege IAM policies

### Secrets Handling

Secrets are stored in GitHub Secrets and never committed into the repository.

### Network Isolation

Services communicate internally using Docker networking.

---

## Limitations and Future Improvements

### Current Limitations

- Single EC2 instance
- No HTTPS
- No Load Balancer
- No Auto Scaling
- Limited monitoring
- No Kubernetes orchestration

### Future Improvements

- ECS or EKS migration
- HTTPS with ACM
- Application Load Balancer
- Auto Scaling Groups
- CloudWatch monitoring
- Distributed tracing
- Blue/Green deployments
- Multi-environment support

## Final Result

The project successfully demonstrates:

- cloud-native deployment
- Infrastructure as Code
- automated CI/CD
- microservices architecture
- container orchestration
- AWS cloud integration
