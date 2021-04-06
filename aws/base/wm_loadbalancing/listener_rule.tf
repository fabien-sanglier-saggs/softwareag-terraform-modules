################################################
################ Vars
################################################

variable "rule_priority" {
  description = "rule priority"
  type    = number
}

variable "rule_action_type" {
  description = "type of action (forward, redirect...)"
  type    = string
}

variable "rule_condition_host_headers" {
  description = "external host header names for this rule"
  type    = list(string)
}

variable "rule_condition_path_patterns" {
  description = "external path patterns for this rule"
  type    = list(string)
}

################################################
################ Load Balancer
################################################

resource "aws_alb_listener_rule" "newrule" {
  count = var.rule_action_type == "forward" ? 1 : 0

  listener_arn = data.aws_lb_listener.listener.arn
  priority     = var.rule_priority

  action {
    type             = var.rule_action_type
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = length(var.rule_condition_path_patterns) == 0 ? ["*"] : var.rule_condition_path_patterns
    }
  }

  condition {
    host_header {
      values = length(var.rule_condition_host_headers) == 0 ? ["*"] : var.rule_condition_host_headers
    }
  }
}