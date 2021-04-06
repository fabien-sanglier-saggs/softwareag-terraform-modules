####################################################
###### Rules Variables  ########
####################################################

variable "rules_ssh_ingress_cidr_list" {
  description = "list of cidrs accepted by the stack for any inbound SSH traffic"
  type    = list(string)
  default = []
}

variable "rules_ssh_egress_cidr_list" {
  description = "list of cidrs accepted by the stack for any outbound SSH traffic"
  type    = list(string)
  default = []
}

################################################
###### SSH ingress rules
################################################

resource "aws_security_group_rule" "ingress_ssh" {
  count = contains(var.rules_profiles, "ssh") && length(var.rules_ssh_ingress_cidr_list) > 0 ? 1 : 0
  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_ssh_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

################################################
###### SSH egress rules
################################################

resource "aws_security_group_rule" "egress_ssh" {
  count = contains(var.rules_profiles, "ssh") && length(var.rules_ssh_egress_cidr_list) > 0 ? 1 : 0

  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_ssh_egress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}