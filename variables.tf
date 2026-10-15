variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to build all resource names"
  type        = string
}

variable "vpc_name" {
  description = "Name tag of the existing VPC"
  type        = string
}

variable "public_subnet_names" {
  description = "Name tags of the existing public subnets"
  type        = list(string)
}

variable "ssh_sg_name" {
  description = "Name of the existing SSH security group"
  type        = string
}

variable "http_sg_name" {
  description = "Name of the existing HTTP security group for EC2 instances"
  type        = string
}

variable "lb_sg_name" {
  description = "Name of the existing security group for the load balancer"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Blue and Green environments"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum number of instances in each Auto Scaling group"
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of instances in each Auto Scaling group"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in each Auto Scaling group"
  type        = number
}

variable "blue_weight" {
  description = "Traffic weight (0-100) sent to the Blue target group"
  type        = number

  validation {
    condition     = var.blue_weight >= 0 && var.blue_weight <= 100
    error_message = "blue_weight must be between 0 and 100."
  }
}

variable "green_weight" {
  description = "Traffic weight (0-100) sent to the Green target group"
  type        = number

  validation {
    condition     = var.green_weight >= 0 && var.green_weight <= 100
    error_message = "green_weight must be between 0 and 100."
  }
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
}