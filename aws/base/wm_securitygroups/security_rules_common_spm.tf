####################################################
###### Rules Variables  ########
####################################################

variable "rules_spm_ingress_cidr_list" {
  description = "list of cidrs accepted by the stack for any inbound SPM traffic"
  type    = list(string)
  default = []
}

variable "rules_spm_egress_cidr_list" {
  description = "list of cidrs accepted by the stack for any outbound SPM traffic"
  type    = list(string)
  default = []
}

################################################
###### SPM ingress rules
################################################

resource "aws_security_group_rule" "ingress_spm" {
  count = contains(var.rules_profiles, "spm") && length(var.rules_spm_ingress_cidr_list) > 0 ? 1 : 0
  
  type              = "ingress"
  from_port         = 8092
  to_port           = 8093
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_spm_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "egress_spm" {
  count = contains(var.rules_profiles, "spm") && length(var.rules_spm_egress_cidr_list) > 0 ? 1 : 0

  type              = "egress"
  from_port         = 8092
  to_port           = 8093
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_spm_egress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}