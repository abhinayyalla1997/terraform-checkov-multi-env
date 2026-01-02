
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = var.instance_tenancy

  tags = merge(
    {
      Name        = "${var.environment}-${var.vpc_name}"
      Environment = var.environment
      Project     = var.project
    },
    var.tags
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-public-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
  }
}

# Private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-private-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
  }
}

# Public RT
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_route_table_association" "public" {
  for_each = {
    for idx, subnet_id in aws_subnet.public :
    idx => subnet_id.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# Private RT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-private-rt"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_route_table_association" "private" {
  for_each = {
    for idx, subnet_id in aws_subnet.private :
    idx => subnet_id.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = "${var.environment}-${each.key}"
  description = each.value.description
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-${each.key}"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each = {
    for sg_name, sg in var.security_groups :
    sg_name => sg.ingress
  }

  security_group_id = aws_security_group.this[each.key].id
  type              = "ingress"

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  cidr_blocks = each.value.cidr_blocks
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for sg_name, sg in var.security_groups :
    sg_name => sg.egress
  }

  security_group_id = aws_security_group.this[each.key].id
  type              = "egress"

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  cidr_blocks = each.value.cidr_blocks
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}
