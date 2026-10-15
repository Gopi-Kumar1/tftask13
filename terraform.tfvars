region      = "eu-west-1"
name_prefix = "cmtr-35arqg4r"
vpc_name    = "cmtr-35arqg4r-vpc"

public_subnet_names = [
  "cmtr-35arqg4r-public-subnet1",
  "cmtr-35arqg4r-public-subnet2"
]

ssh_sg_name  = "cmtr-35arqg4r-sg-ssh"
http_sg_name = "cmtr-35arqg4r-sg-http"
lb_sg_name   = "cmtr-35arqg4r-sg-lb"

instance_type        = "t3.micro"
asg_min_size         = 1
asg_max_size         = 2
asg_desired_capacity = 1

blue_weight  = 50
green_weight = 50

tags = {
  Project   = "blue-green-deployment"
  ManagedBy = "terraform"
  Task      = "task-13"
}