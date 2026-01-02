# data "aws_ami" "selected" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = [var.ami_filter.name]
#   }

#   owners = ["amazon"]
# }

data "aws_ami" "selected" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_filter.name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "this" {
  for_each = var.instances

  ami                    = data.aws_ami.selected.id
  instance_type          = each.value.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [each.value.sg_id]

  tags = {
    Name        = "${var.environment}-${each.key}"
    Environment = var.environment
    Project     = var.project
  }
}
