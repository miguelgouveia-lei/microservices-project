# Setup Guide

# Overview

This document describes all prerequisites, tools, accounts and configurations required to run, provision and deploy the project locally and in AWS.

The setup process includes:

- local development environment
- Docker environment
- AWS configuration
- Terraform installation
- Ansible installation
- GitHub configuration
- DockerHub configuration
- CI/CD prerequisites
- cloud authentication setup

The project combines local containerized development with automated AWS cloud deployment.

---

# Required Tools

The following tools are required to run the project successfully.

| Tool | Purpose |
|---|---|
| Git | Source code management |
| Docker | Container runtime |
| Docker Compose | Local service orchestration |
| AWS CLI v2 | AWS authentication and resource interaction |
| Terraform >= 1.9 | Infrastructure provisioning |
| Ansible | EC2 configuration and deployment |
| Java JDK 21 | Spring Boot runtime |
| Maven | Java build system |
| GitHub Account | CI/CD workflows |
| DockerHub Account | Docker image registry |

---

# Recommended Development Environment

The project was primarily developed and tested using:

| Component | Recommended Environment |
|---|---|
| OS | Windows + Git Bash / WSL |
| IDE | IntelliJ IDEA |
| Container Runtime | Docker Desktop |
| Shell | Git Bash |
| AWS Interaction | AWS CLI |
| Infrastructure | Terraform CLI |

---

# Java Setup

## Install Java 21

The project requires Java JDK 21.

Verify installation:

```bash
java --version
```

Expected result:

```text
openjdk 21
```

---

# Maven Setup

Verify Maven installation:

```bash
mvn -version
```

---

# Docker Setup

## Install Docker Desktop

Docker Desktop must be installed and running.

Verify installation:

```bash
docker --version
docker compose version
```

---

# Docker Permissions

Ensure Docker Desktop is running before executing containers.

Validate Docker operation:

```bash
docker run hello-world
```

---

# Git Setup

Verify Git installation:

```bash
git --version
```

Clone repository:

```bash
git clone <repository-url>

cd microservices-project
```

---

# AWS Setup

## AWS Account Requirements

The project requires an AWS account with permissions to provision cloud infrastructure.

Required AWS services:

- EC2
- VPC
- RDS
- SQS
- IAM
- Security Groups
- Internet Gateway
- Route Tables

---

# AWS Region

The selected AWS region for this project is:

```text
eu-central-1
```

All AWS resources should be provisioned consistently in this region.

---

# AWS CLI Installation

Install AWS CLI v2.

Verify installation:

```bash
aws --version
```

---

# AWS Authentication

Configure AWS CLI:

```bash
aws configure
```

Required values:

| Field | Example |
|---|---|
| AWS Access Key ID | ******** |
| AWS Secret Access Key | ******** |
| Default region | eu-central-1 |
| Output format | json |

---

# AWS Infrastructure Requirements

The deployment provisions the following AWS resources automatically through Terraform:

- VPC
- Public subnet
- Security Groups
- Internet Gateway
- Route Tables
- EC2 instance
- Amazon RDS
- Amazon SQS

These resources are automatically managed through Infrastructure as Code.

# AWS Permissions

The AWS account or IAM role must allow:

- EC2 provisioning
- VPC management
- RDS creation
- SQS creation
- IAM role usage
- Security Group management

---

# Billing Protection

To avoid unexpected cloud costs:

- configure AWS billing alarms
- remove unused resources
- destroy infrastructure after testing

Terraform destroy command:

```bash
terraform destroy
```

---

# Terraform Setup

## Install Terraform

Terraform version required:

```text
>= 1.9
```

Verify installation:

```bash
terraform version
```

---

# Terraform Backend

The project uses Terraform remote state storage.

Terraform backend initialization:

```bash
terraform init
```

---

# Terraform Validation

Validate infrastructure configuration:

```bash
terraform validate
```

Generate execution plan:

```bash
terraform plan
```

---

# Ansible Setup

## Install Ansible

Linux/WSL installation example:

```bash
sudo apt update

sudo apt install ansible -y
```

Verify installation:

```bash
ansible --version
```

---

# Why WSL or Linux Is Recommended

Ansible has limited native support on Windows Git Bash.

For this reason:
- WSL
- Ubuntu
- Linux
- GitHub Actions runners

provide better compatibility.

---

# DockerHub Setup

## DockerHub Account

A DockerHub account is required for image publication.

DockerHub stores:
- api-gateway image
- user-service image
- product-service image
- order-service image

---

# DockerHub Authentication

Authenticate locally:

```bash
docker login
```

---

# GitHub Setup

## Required GitHub Features

The project requires:

- GitHub repository
- GitHub Actions
- GitHub Secrets
- GitHub Environments

---

# Required GitHub Secrets

| Secret | Purpose |
|---|---|
| AWS_ROLE_TO_ASSUME | AWS IAM role ARN |
| EC2_SSH_PRIVATE_KEY | SSH deployment key |

---

# OIDC Configuration

The project uses OIDC federation between GitHub Actions and AWS.

Benefits:

- no static AWS credentials
- temporary authentication
- improved CI/CD security

---

# Local Development Setup

## Start Local Environment

The local environment uses Docker Compose.

Run:

```bash
docker compose up -d --build
```

This command:
- builds all services
- creates Docker networking
- starts Kafka and Zookeeper
- deploys microservices locally

---

# Local Validation

Verify running containers:

```bash
docker compose ps
```

Validate health endpoints:

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

# Infrastructure Provisioning Setup

## Terraform Workflow

Navigate to Terraform directory:

```bash
cd infrastructure/terraform
```

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Generate infrastructure plan:

```bash
terraform plan
```

Apply infrastructure:

```bash
terraform apply
```

---

# CI/CD Setup

## GitHub Actions

The CI/CD pipeline executes automatically when changes are pushed into the `main` branch.

Example:

```bash
git push origin main
```

This automatically triggers:
- Docker image builds
- DockerHub publication
- Terraform provisioning
- AWS deployment
- Ansible deployment
- deployment validation

---

# SSH Key Setup

## EC2 SSH Access

The EC2 instance uses SSH key authentication.

Example access:

```bash
ssh -i week6-key.pem ec2-user@<EC2_PUBLIC_IP>
```

---

# Health Validation

After deployment:

```bash
curl http://<EC2_PUBLIC_IP>:8080/actuator/health
```

Expected response:

```json
{
  "status": "UP"
}
```

---

# Recommended Validation Checklist

Before running deployments verify:

- Docker Desktop running
- AWS CLI authenticated
- Terraform installed
- Ansible installed
- GitHub Secrets configured
- DockerHub login successful
- Java 21 installed
- Maven installed

---

# Common Issues

## Terraform Issues

Possible causes:
- invalid AWS credentials
- missing permissions
- VPC limits
- existing dependencies

---

# Docker Issues

Possible causes:
- Docker Desktop not running
- port conflicts
- insufficient memory allocation

---

# EC2 Issues

Possible causes:
- incorrect SSH key
- blocked Security Groups
- insufficient EC2 resources

---

# CI/CD Issues

Possible causes:
- invalid GitHub Secrets
- failed OIDC configuration
- DockerHub authentication failures
- Terraform validation errors

---

# Final Setup Result

After completing setup successfully the project should support:

- local containerized execution
- Terraform infrastructure provisioning
- automated AWS deployment
- GitHub Actions CI/CD
- Docker image publication
- cloud-native service execution
- health validation through API Gateway

The setup process establishes the complete environment required for practical cloud-native deployment automation.