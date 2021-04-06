
####################################################
###### TERRACOTTA - Rules Variables  ########
####################################################

variable "rules_terracotta_runtime_ingress_security_group_id" {
  description = "list of security group ids to accept for ingress runtime trafic"
  type    = string
  default = ""
}

variable "rules_terracotta_admin_ingress_security_group_id" {
  description = "list of security group ids to accept for ingress admin trafic"
  type    = string
  default = ""
}

variable "rules_terracotta_admin_ingress_cidr_list" {
  description = "delimiter of cidrs to accept for ingress admin trafic"
  type    = list(string)
  default = []
}

####################################################
######    TERRACOTTA - Client Access Rules  ########
####################################################

## by security group id
resource "aws_security_group_rule" "terracotta_external_rule1a" {  
  count = contains(var.rules_profiles, "terracotta_access") && length(var.rules_terracotta_runtime_ingress_security_group_id) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9510
  to_port           = 9510
  protocol          = "tcp"
  source_security_group_id = var.rules_terracotta_runtime_ingress_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "terracotta_external_rule2a" {  
  count = contains(var.rules_profiles, "terracotta_access") && length(var.rules_terracotta_runtime_ingress_security_group_id) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9520
  to_port           = 9520
  protocol          = "tcp"
  source_security_group_id = var.rules_terracotta_runtime_ingress_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "terracotta_external_rule3a" {  
  count = contains(var.rules_profiles, "terracotta_access") && length(var.rules_terracotta_runtime_ingress_security_group_id) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9530
  to_port           = 9530
  protocol          = "tcp"
  source_security_group_id = var.rules_terracotta_runtime_ingress_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "terracotta_external_rule4a" {  
  count = contains(var.rules_profiles, "terracotta_access") && length(var.rules_terracotta_runtime_ingress_security_group_id) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9540
  to_port           = 9540
  protocol          = "tcp"
  source_security_group_id = var.rules_terracotta_runtime_ingress_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

#############################################################
######    TERRACOTTA - Admin Access Rules (eg. TMC)  #########
#############################################################

resource "aws_security_group_rule" "terracotta_admin_rule1a" {  
  count = contains(var.rules_profiles, "terracotta_access") && length(var.rules_terracotta_admin_ingress_cidr_list) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9443
  to_port           = 9443
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_terracotta_admin_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "terracotta_admin_rule2a" {  
  count = contains(var.rules_profiles, "terracotta_access") && length(var.rules_terracotta_admin_ingress_cidr_list) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9889
  to_port           = 9889
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_terracotta_admin_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "terracotta_admin_rule1b" {  
  count = contains(var.rules_profiles, "terracotta_access") && length(var.rules_terracotta_admin_ingress_security_group_id) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9443
  to_port           = 9443
  protocol          = "tcp"
  source_security_group_id = var.rules_terracotta_admin_ingress_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "terracotta_admin_rule2b" {  
  count = contains(var.rules_profiles, "terracotta_access") && length(var.rules_terracotta_admin_ingress_security_group_id) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9889
  to_port           = 9889
  protocol          = "tcp"
  source_security_group_id = var.rules_terracotta_admin_ingress_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}