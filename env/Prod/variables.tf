variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "vpc_name" {
  description = "VPC logical name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
}


variable "security_groups" {
  description = "Map of security groups and their rules. Example shape in tfvars provided in repo."
  type = map(object({
    description = string

    ingress = object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })

    egress = object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })
  }))
}


variable "key_name" {
  description = "SSH key pair name for EC2"
  type        = string
}
