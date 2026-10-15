locals {
  blue_name  = "${var.name_prefix}-blue"
  green_name = "${var.name_prefix}-green"

  public_subnet_ids = [for s in data.aws_subnet.public : s.id]
  instance_sg_ids   = [data.aws_security_group.ssh.id, data.aws_security_group.http.id]

  blue_tags = merge(var.tags, {
    Name       = "${local.blue_name}-instance"
    Deployment = "blue"
  })

  green_tags = merge(var.tags, {
    Name       = "${local.green_name}-instance"
    Deployment = "green"
  })

  blue_user_data  = base64encode(templatefile("${path.module}/user_data.sh.tpl", { environment = "Blue" }))
  green_user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", { environment = "Green" }))
}