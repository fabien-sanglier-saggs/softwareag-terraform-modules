################################################
################ Vars
################################################

variable "vpc_id" {
  description = "vpc id"
  type    = string
}

###################### network dependencies

data "aws_vpc" "main" {
  id = var.vpc_id
}

###################### Reference to the load balancer

data "aws_lb" "loadbalancer" {
  arn = var.loadbalancer_id
}

data "aws_lb_listener" "listener" {
  arn = var.loadbalancer_listener_arn
}
