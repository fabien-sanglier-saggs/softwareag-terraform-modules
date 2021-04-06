####################################################
###### Rules Variables  ########
####################################################

variable "rules_integrationserver_runtime_ingress_security_group_id" {
  description = "source security group id to accept for ingress runtime trafic"
  type    = string
  default = ""
}

variable "rules_integrationserver_runtime_ingress_cidr_list" {
  description = "delimiter of cidrs to accept for ingress runtime trafic"
  type    = list(string)
  default = []
}

variable "rules_integrationserver_runtime_ingress_terracotta_callback_security_group_id" {
  description = "source security group id of terracotta nodes for ingress terracotta callback traffic"
  type    = string
  default = ""
}

variable "rules_integrationserver_runtime_egress_terracotta_security_group_id" {
  description = "target security group id of terracotta nodes for egress terracotta traffic"
  type    = string
  default = ""
}

variable "rules_integrationserver_admin_ingress_security_group_id" {
  description = "source security group id to accept for ingress admin trafic"
  type    = string
  default = ""
}

variable "rules_integrationserver_admin_ingress_cidr_list" {
  description = "delimiter of cidrs to accept for ingress admin trafic"
  type    = list(string)
  default = []
}

###################################################### 
###### INGRESS - Runtime Rules  ########## 
###################################################### 

resource "aws_security_group_rule" "integrationserver_runtime_ingress_rule1_bycidr" {
  count = contains(var.rules_profiles, "integrationserver") && length(var.rules_integrationserver_runtime_ingress_cidr_list) > 0 ? 1 : 0
    
  type              = "ingress"
  from_port         = 5555
  to_port           = 5555
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_integrationserver_runtime_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "integrationserver_runtime_ingress_rule2_bycidr" {
  count = contains(var.rules_profiles, "integrationserver") && length(var.rules_integrationserver_runtime_ingress_cidr_list) > 0 ? 1 : 0
    
  type              = "ingress"
  from_port         = 5443
  to_port           = 5443
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_integrationserver_runtime_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

#############################################################################
###### INGRESS - Terracotta Healthchecks Callbacks Rules  ######### 
#############################################################################

resource "aws_security_group_rule" "integrationserver_terracotta_callback_rule" {
  count = contains(var.rules_profiles, "integrationserver") && length(var.rules_integrationserver_runtime_ingress_terracotta_callback_security_group_id) > 0 ? 1 : 0
  
  type              = "ingress"
  from_port         = 9500
  to_port           = 9509
  protocol          = "tcp"
  source_security_group_id = var.rules_integrationserver_runtime_ingress_terracotta_callback_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

################################################
###### INGRESS - ADMIN Rules   ###### 
################################################

resource "aws_security_group_rule" "integrationserver_admin_ingress_rule1_bycidr" {
  count = contains(var.rules_profiles, "integrationserver") && length(var.rules_integrationserver_admin_ingress_cidr_list) > 0 ? 1 : 0
  
  type              = "ingress"
  from_port         = 9999
  to_port           = 9999
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_integrationserver_admin_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

#############################################################################
###### EGRESS - Access to Terracotta Nodes  #####################
#############################################################################

resource "aws_security_group_rule" "integrationserver_outbound_terracotta_rule1" {
  count = contains(var.rules_profiles, "integrationserver") && length(var.rules_integrationserver_runtime_egress_terracotta_security_group_id) > 0 ? 1 : 0

  type              = "egress"
  from_port         = 9510
  to_port           = 9510
  protocol          = "tcp"
  source_security_group_id = var.rules_integrationserver_runtime_egress_terracotta_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "integrationserver_outbound_terracotta_rule2" {
  count = contains(var.rules_profiles, "integrationserver") && length(var.rules_integrationserver_runtime_egress_terracotta_security_group_id) > 0 ? 1 : 0

  type              = "egress"
  from_port         = 9530
  to_port           = 9530
  protocol          = "tcp"
  source_security_group_id = var.rules_integrationserver_runtime_egress_terracotta_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "integrationserver_outbound_terracotta_rule3" {
  count = contains(var.rules_profiles, "integrationserver") && length(var.rules_integrationserver_runtime_egress_terracotta_security_group_id) > 0 ? 1 : 0

  type              = "egress"
  from_port         = 9540
  to_port           = 9540
  protocol          = "tcp"
  source_security_group_id = var.rules_integrationserver_runtime_egress_terracotta_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}