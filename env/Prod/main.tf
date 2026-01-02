
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.14.0"
#     }
#   }
# }

terraform {
  backend "s3" {
    bucket  = "checkov-terraform-statefile"
    key     = "Prod/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  project     = var.project

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  igw_id               = module.nat_igw.igw_id
  nat_gateway_id       = module.nat_igw.nat_gateway_ids[0]

  security_groups = var.security_groups

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

module "nat_igw" {
  source = "../../modules/nat-igw"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  environment = var.environment
  project     = var.project
}

module "ec2" {
  source   = "../../modules/ec2"
  key_name = var.key_name

  subnet_id = module.vpc.public_subnet_ids[0]

  instances = {
    vpn = {
      instance_type = "t2.micro"
      sg_id         = module.vpc.security_group_ids["vpn"]
    }
    sonarqube = {
      instance_type = "t2.small"
      sg_id         = module.vpc.security_group_ids["sonarqube"]
    }
  }

  environment = var.environment
  project     = var.project
}


module "s3" {
  source      = "../../modules/s3"
  environment = var.environment
  kms_key_arn = module.kms.arn
  project     = var.project
}


module "kms" {
  source      = "../../modules/kms"
  environment = var.environment
  project     = var.project
}

