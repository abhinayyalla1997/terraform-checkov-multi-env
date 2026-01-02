
resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_eip" "nat" {
  count  = var.enable_nat ? 1 : 0
  domain = "vpc"

  tags = {
    Name        = "${var.environment}-nat-eip"
    Environment = var.environment
    Project     = var.project
  }
}

# NAT Gateway (just 1)
resource "aws_nat_gateway" "this" {
  count = var.enable_nat ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id = var.public_subnet_ids[0]

  connectivity_type = "public"

  tags = {
    Name        = "${var.environment}-nat"
    Environment = var.environment
    Project     = var.project
  }
}
