# Setup Guide

## Required Tools

The project requires the following tools:

- Git
- Docker and Docker Compose
- AWS CLI v2
- Terraform >= 1.9
- Ansible
- Java JDK 21
- Maven
- GitHub account
- DockerHub account

## AWS Requirements

The project assumes an AWS account with:

- IAM user or role configured
- AWS CLI authenticated
- Permissions to create VPC, EC2, RDS, SQS, IAM and related resources
- Billing alarm configured
- Region selected consistently

The selected AWS region for this project is:

```text
eu-central-1
