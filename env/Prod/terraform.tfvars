aws_region  = "us-east-1"
environment = "prod"
project     = "checkov"

vpc_name = "checkov-Prod-VPC"
vpc_cidr = "10.1.0.0/16"

public_subnet_cidrs = [
  "10.1.0.0/20",
  "10.1.16.0/20"
]

private_subnet_cidrs = [
  "10.1.128.0/20",
  "10.1.144.0/20"
]

security_groups = {
  vpn = {
    description = "VPN SG"
    ingress = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  sonarqube = {
    description = "Sonarqube SG"
    ingress = {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  backend = {
    description = "Backend service SG"
    ingress = {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/20"] # frontend traffic
    }
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  db = {
    description = "Database SG"
    ingress = {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # replace with office/vpn IP
    }
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
key_name = "checkov-prod-key"
