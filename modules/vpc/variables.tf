variable "environment" {
  type = string 
}

variable "project" { 
  type = string
}

variable "vpc_name" { 
  type = string 
}

variable "vpc_cidr" {
  type = string 
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "security_groups" {
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

variable "igw_id" {
  type = string
}

variable "nat_gateway_id" {
  type = string
}
