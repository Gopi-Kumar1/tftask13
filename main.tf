resource "aws_launch_template" "blue" {
  name          = "${local.blue_name}-template"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.instance_type
  user_data     = local.blue_user_data

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = local.instance_sg_ids
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.blue_tags
  }

  tags = merge(var.tags, { Name = "${local.blue_name}-template" })
}

resource "aws_launch_template" "green" {
  name          = "${local.green_name}-template"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.instance_type
  user_data     = local.green_user_data

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = local.instance_sg_ids
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.green_tags
  }

  tags = merge(var.tags, { Name = "${local.green_name}-template" })
}

resource "aws_lb_target_group" "blue" {
  name     = "${local.blue_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path    = "/"
    matcher = "200"
  }

  tags = merge(var.tags, { Name = "${local.blue_name}-tg" })
}

resource "aws_lb_target_group" "green" {
  name     = "${local.green_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path    = "/"
    matcher = "200"
  }

  tags = merge(var.tags, { Name = "${local.green_name}-tg" })
}

resource "aws_lb" "main" {
  name               = "${var.name_prefix}-lb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [data.aws_security_group.lb.id]
  subnets            = local.public_subnet_ids

  tags = merge(var.tags, { Name = "${var.name_prefix}-lb" })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = var.blue_weight
      }

      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = var.green_weight
      }
    }
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-listener-http" })
}

resource "aws_autoscaling_group" "blue" {
  name                      = "${local.blue_name}-asg"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = local.public_subnet_ids
  target_group_arns         = [aws_lb_target_group.blue.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = local.blue_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_group" "green" {
  name                      = "${local.green_name}-asg"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = local.public_subnet_ids
  target_group_arns         = [aws_lb_target_group.green.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = local.green_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}