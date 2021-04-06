################################################
################ Vars
################################################

variable "targetgroup_name" {
  description = "target group name"
  type    = string
}

variable "targetgroup_protocol" {
  description = "target group protocol (HTTP,HTTPS)"
  type    = string
}

variable "targetgroup_port" {
  description = "target group port"
  type    = number
}

variable "targetgroup_targettype" {
  description = "target group target type (instance, ip)"
  type    = string
}

variable "targetgroup_target_ids" {
  description = "The IDs of the target. This is the Instance ID for an instance, or the container ID for an ECS container. If the target type is ip, specify an IP address. If the target type is lambda, specify the arn of lambda."
  type    = list(string)
}

variable "targetgroup_stickiness_enabled" {
  description = "target group stickiness"
  type    = bool
}

variable "targetgroup_stickiness_type" {
  description = "target group stickiness type"
  type    = string
  default = "lb_cookie"
}

variable "targetgroup_stickiness_duration" {
  description = "target group stickiness duration"
  type    = number
  default = 86400
}

variable "targetgroup_healthcheck_path" {
  description = "target group healthcheck path"
  type    = string
}

variable "targetgroup_healthcheck_protocol" {
  description = "target group healthcheck protocol (HTTP,HTTPS)"
  type    = string
}

variable "targetgroup_healthcheck_responsematch" {
  description = "target group healthcheck response code"
  type    = string
  default = "200"
}

################################################
################ Load Balancer
################################################

resource "random_id" "this" {
  keepers = {
    vpc_id      = data.aws_vpc.main.id
    protocol    = var.targetgroup_protocol
    port        = var.targetgroup_port
    target_type = var.targetgroup_targettype
  }
  byte_length = 2
}

################ API Gateway UI

resource "aws_lb_target_group" "this" {
  name                 = join(var.name_delimiter, [ replace(var.name_prefix_short, "/[^a-zA-Z0-9]/", ""), replace(var.targetgroup_name, "/[^a-zA-Z0-9]/", ""), random_id.this.hex ] )
  port                 = random_id.this.keepers.port
  protocol             = random_id.this.keepers.protocol
  vpc_id               = random_id.this.keepers.vpc_id
  target_type          = random_id.this.keepers.target_type

  slow_start           = 120
  deregistration_delay = 120

  lifecycle {
    create_before_destroy = true
  }

  stickiness {
    enabled         = var.targetgroup_stickiness_enabled
    type            = var.targetgroup_stickiness_type
    cookie_duration = var.targetgroup_stickiness_duration
  }

  health_check {
    path                = var.targetgroup_healthcheck_path
    protocol            = var.targetgroup_healthcheck_protocol
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = var.targetgroup_healthcheck_responsematch
  }

  //  Use our common tags and add a specific name.
  tags = merge(
    var.common_tags,
    {
      "Name" = join(var.name_delimiter, [ var.name_prefix_long, var.targetgroup_name, random_id.this.hex ] )
    },
  )
}

resource "aws_lb_target_group_attachment" "this" {
  count = length(var.targetgroup_target_ids)

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.targetgroup_target_ids[count.index]
}