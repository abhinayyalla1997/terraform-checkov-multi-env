variable "vpc_id" {
  type        = string
  description = "VPC ID to attach the Internet Gateway"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "List of public subnet IDs for NAT placement"
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "enable_nat" {
  type    = bool
  default = true
}
