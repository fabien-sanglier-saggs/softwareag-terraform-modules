####################################################
###### Rules Variables  ########
####################################################

variable "rules_http_ingress_cidr_list" {
  description = "list of target cidrs accepted by the stack for any inbound HTTP traffic"
  type    = list(string)
  default = []
}

variable "rules_http_egress_cidr_list" {
  description = "list of target cidrs accepted by the stack for any outbound HTTP traffic"
  type    = list(string)
  default = []
}

variable "rules_https_ingress_cidr_list" {
  description = "list of target cidrs accepted by the stack for any inbound HTTPS traffic"
  type    = list(string)
  default = []
}

variable "rules_https_egress_cidr_list" {
  description = "list of target cidrs accepted by the stack for any outbound HTTPS traffic"
  type    = list(string)
  default = []
}

################################################
###### HTTP/HTTPs ingress rules
################################################

resource "aws_security_group_rule" "ingress_http" {
  count = contains(var.rules_profiles, "http") && length(var.rules_http_ingress_cidr_list) > 0 ? 1 : 0
  
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_http_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "ingress_https" {
  count = contains(var.rules_profiles, "http") && length(var.rules_https_ingress_cidr_list) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_https_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

################################################
###### HTTP/HTTPs egress rules
################################################

resource "aws_security_group_rule" "egress_http" {
  count = contains(var.rules_profiles, "http") && length(var.rules_http_egress_cidr_list) > 0 ? 1 : 0
  
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_http_egress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "egress_https" {
  count = contains(var.rules_profiles, "http") && length(var.rules_https_egress_cidr_list) > 0 ? 1 : 0
  
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_https_egress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}