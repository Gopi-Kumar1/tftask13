data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "public" {
  for_each = toset(var.public_subnet_names)

  filter {
    name   = "tag:Name"
    values = [each.value]
  }
}

data "aws_security_group" "ssh" {
  name   = var.ssh_sg_name
  vpc_id = data.aws_vpc.main.id
}

data "aws_security_group" "http" {
  name   = var.http_sg_name
  vpc_id = data.aws_vpc.main.id
}

data "aws_security_group" "lb" {
  name   = var.lb_sg_name
  vpc_id = data.aws_vpc.main.id
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}