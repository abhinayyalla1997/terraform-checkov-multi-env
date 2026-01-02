data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_kms_key" "this" {
  description             = "KMS key for ${var.project} RDS in ${var.environment} environment"
  key_usage               = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation     = true
  rotation_period_in_days = 365

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "env-${var.environment}-cmk"
    Statement = [

      # RDS
      {
        Sid    = "AllowRDS"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:CallerAccount" = data.aws_caller_identity.current.account_id
            "kms:ViaService"    = "rds.${data.aws_region.current.id}.amazonaws.com"
          }
        }
      },

      # S3
      {
        Sid    = "AllowS3"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*"
        ]
        Resource = "*"
      },

      # Secrets Manager
      {
        Sid    = "AllowSecretsManager"
        Effect = "Allow"
        Principal = {
          Service = "secretsmanager.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*"
        ]
        Resource = "*"
      },

      {
        Sid    = "AllowECR"
        Effect = "Allow"
        Principal = {
          Service = "ecr.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*"
        ]
        Resource = "*"
      },

      # Root safety net
      {
        Sid    = "EnableRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })


  tags = {
    Name        = "${var.environment}-${var.project}-rds-kms"
    Environment = var.environment
    Project     = var.project
  }
}
