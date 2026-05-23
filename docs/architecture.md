# Architecture

## Overview

This project extends the laboratory microservices reference application into a cloud-native distributed system deployed on AWS.

The system is composed of:

- API Gateway
- User Service
- Product Service
- Order Service
- PostgreSQL database using Amazon RDS
- Amazon SQS queue for asynchronous communication
- Docker containers
- Terraform infrastructure
- Ansible configuration management
- GitHub Actions CI/CD workflows

## Architecture Style

The project follows a microservices architecture. Each service has its own responsibility and communicates through REST APIs and asynchronous messages.

The application intentionally keeps the business logic simple because the main goal is to demonstrate cloud engineering practices: infrastructure automation, containerization, CI/CD, IAM, networking, deployment and operational reasoning.

## Main Flow

1. A client sends HTTP requests through the API Gateway.
2. The gateway routes requests to the correct microservice.
3. Services communicate through REST where synchronous communication is appropriate.
4. Product-related events are published to Amazon SQS.
5. Consumers process events asynchronously.
6. Persistent data is stored in Amazon RDS.

## AWS Infrastructure

The AWS infrastructure includes:

- Custom VPC
- Public subnet for internet-facing compute
- Private subnet for database resources
- Internet Gateway
- Route tables
- Security groups
- EC2 instances
- RDS PostgreSQL
- SQS queue and DLQ

## Why This Architecture

This architecture was chosen because it demonstrates the main concepts explored during the semester:

- Distributed services
- Containerized deployment
- Infrastructure as Code
- Event-driven communication
- Persistence with managed database services
- Configuration automation
- CI/CD
- IAM and security controls
