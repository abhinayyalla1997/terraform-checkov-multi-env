# Terraform Multi-Environment Security with Checkov

This project demonstrates how to integrate **Checkov** into a real-world
Terraform multi-environment setup using **GitHub Actions CI/CD**.

## 🚀 What This Project Demonstrates

- Multi-environment Terraform structure (**Dev & Prod**)
- Reusable Terraform modules (VPC, EC2, S3, KMS, NAT)
- Static security analysis using **Checkov**
- Environment-based security enforcement:
  - **Dev** → visibility (soft fail)
  - **Prod** → enforcement (hard fail)
- CI/CD integration using **GitHub Actions**
- Generation of **Checkov reports** as pipeline artifacts

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

## 🏗 Repository Structure

```text
.
├── checkov-reports
│   ├── dev
│   │   ├── results_cli.txt
│   │   └── results_json.json
│   └── prod
│       ├── results_cli.txt
│       └── results_json.json
├── docs
│   └── CHECKOV_notes.pdf
├── env
│   ├── Dev
│   │   ├── .checkov.yaml
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── Prod
│   │   ├── .checkov.yaml
│       ├── main.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── modules
│   ├── ec2
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── kms
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── nat-igw
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── s3
│   │   ├── main.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
└── README.md
