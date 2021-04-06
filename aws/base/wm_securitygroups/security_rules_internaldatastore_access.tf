####################################################
###### INTERNAL DATASTORE - Rules Variables  ########
####################################################

variable "rules_internaldatastore_runtime_ingress_security_group_id" {
  description = "source security group id to accept for ingress runtime trafic"
  type    = string
  default = ""
}

variable "rules_internaldatastore_admin_ingress_security_group_id" {
  description = "source security group id to accept for ingress admin trafic"
  type    = string
  default = ""
}

variable "rules_internaldatastore_admin_ingress_cidr_list" {
  description = "delimiter of cidrs to accept for ingress admin trafic"
  type    = list(string)
  default = []
}

####################################################
###### INTERNAL DATASTORE Client Access Rules ###### 
####################################################

resource "aws_security_group_rule" "internaldatastore_client_access_rule1" {  
  count = contains(var.rules_profiles, "internaldatastore_access") && length(var.rules_internaldatastore_runtime_ingress_security_group_id) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9240
  to_port           = 9240
  protocol          = "tcp"
  source_security_group_id = var.rules_internaldatastore_runtime_ingress_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "internaldatastore_client_access_rule2" {  
  count = contains(var.rules_profiles, "internaldatastore_access") && length(var.rules_internaldatastore_runtime_ingress_security_group_id) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9340
  to_port           = 9340
  protocol          = "tcp"
  source_security_group_id = var.rules_internaldatastore_runtime_ingress_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

####################################################
###### INTERNAL DATASTORE Admin Access Rules ###### 
####################################################

resource "aws_security_group_rule" "internaldatastore_admin_access_rule1_bysecgroupid" {  
  count = contains(var.rules_profiles, "internaldatastore_access") && length(var.rules_internaldatastore_admin_ingress_security_group_id) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9240
  to_port           = 9240
  protocol          = "tcp"
  source_security_group_id = var.rules_internaldatastore_admin_ingress_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "internaldatastore_admin_access_rule2_bysecgroupid" {  
  count = contains(var.rules_profiles, "internaldatastore_access") && length(var.rules_internaldatastore_admin_ingress_security_group_id) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9340
  to_port           = 9340
  protocol          = "tcp"
  source_security_group_id = var.rules_internaldatastore_admin_ingress_security_group_id
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "internaldatastore_admin_access_rule1_bycidrs" {  
  count = contains(var.rules_profiles, "internaldatastore_access") && length(var.rules_internaldatastore_admin_ingress_cidr_list) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9240
  to_port           = 9240
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_internaldatastore_admin_ingress_cidr_list
    ]
  )  
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "internaldatastore_admin_access_rule2_bycidrs" {  
  count = contains(var.rules_profiles, "internaldatastore_access") && length(var.rules_internaldatastore_admin_ingress_cidr_list) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 9340
  to_port           = 9340
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_internaldatastore_admin_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}