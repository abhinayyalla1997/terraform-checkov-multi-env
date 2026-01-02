variable "instances" {
  description = "Map of EC2 instances to create"
  type = map(object({
    instance_type = string
    sg_id         = string
  }))
}

# variable "ami_filter" {
#   description = "AMI filter for EC2 lookup"
#   type        = map(string)
#   default = {
#     name = "amzn2-ami-hvm-*-x86_64-gp2"
#   }
# }

variable "ami_filter" {
  description = "AMI filter for EC2 lookup"
  type        = map(string)
  default = {
    name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  }
}

variable "subnet_id" {
  description = "Subnet ID where EC2 instances will be created"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

