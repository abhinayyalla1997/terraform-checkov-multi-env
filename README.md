# Terraform Multi-Environment Security with Checkov

This project demonstrates how to integrate **Checkov** into a real-world
Terraform multi-environment setup using **GitHub Actions CI/CD**.

## 📌 What this project shows

- Reusable Terraform modules (VPC, EC2, S3, KMS, NAT)
- Multiple environments (Dev & Prod)
- Static security scanning using Checkov
- CKV (resource-level) and CKV2 (architecture-level) checks
- CI/CD enforcement without deploying infrastructure

## 🔍 Security Scanning

Checkov is used to:
- Detect misconfigurations before deployment
- Highlight security gaps (public access, encryption, IAM)
- Demonstrate baseline vs gating behavior in CI/CD

Some failed checks are **intentional** to showcase:
- Realistic security findings
- Risk visibility
- Shift-left security practices

## 🚀 CI/CD Pipeline

The GitHub Actions pipeline:
- Runs Terraform init & validate
- Executes Checkov scans
- Produces security results on every PR

No AWS credentials or Terraform apply are required.

## 📂 Structure

```text
env/        → Environment-specific configs
modules/    → Reusable Terraform modules
.github/    → CI/CD workflows
