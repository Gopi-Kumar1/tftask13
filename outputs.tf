output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "blue_target_group_arn" {
  description = "ARN of the Blue target group"
  value       = aws_lb_target_group.blue.arn
}

output "green_target_group_arn" {
  description = "ARN of the Green target group"
  value       = aws_lb_target_group.green.arn
}

output "blue_asg_name" {
  description = "Name of the Blue Auto Scaling group"
  value       = aws_autoscaling_group.blue.name
}

output "green_asg_name" {
  description = "Name of the Green Auto Scaling group"
  value       = aws_autoscaling_group.green.name
}

output "traffic_weights" {
  description = "Current traffic split between Blue and Green"
  value = {
    blue  = var.blue_weight
    green = var.green_weight
  }
}