####################################################
###### Rules Variables  ########
####################################################

variable "rules_full_ingress_cidr_list" {
  description = "list of cidrs accepted by the stack for any inbound traffic"
  type    = list(string)
  default = []
}

variable "rules_full_egress_cidr_list" {
  description = "list of cidrs accepted by the stack for any outbound traffic"
  type    = list(string)
  default = []
}

################################################
###### SSH ingress rules
################################################

resource "aws_security_group_rule" "ingress_all_traffic" {
  count = length(var.rules_full_ingress_cidr_list) > 0 ? 1 : 0
  
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = flatten(
    [
      var.rules_full_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

################################################
###### SSH egress rules
################################################

resource "aws_security_group_rule" "egress_all_traffic" {
  count = length(var.rules_full_egress_cidr_list) > 0 ? 1 : 0
  
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = flatten(
    [
      var.rules_full_egress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}