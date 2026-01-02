output "nat_gateway_ids" {
  value = aws_nat_gateway.this[*].id
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}
