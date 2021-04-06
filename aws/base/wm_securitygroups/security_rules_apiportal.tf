####################################################
###### Rules Variables  ########
####################################################

variable "rules_apiportal_runtime_ingress_security_group_id" {
  description = "source security group id to accept for ingress runtime trafic"
  type    = string
  default = ""
}

variable "rules_apiportal_runtime_ingress_cidr_list" {
  description = "delimiter of cidrs to accept for ingress runtime trafic"
  type    = list(string)
  default = []
}

variable "rules_apiportal_admin_ingress_security_group_id" {
  description = "source security group id to accept for ingress admin trafic"
  type    = string
  default = ""
}

variable "rules_apiportal_admin_ingress_cidr_list" {
  description = "delimiter of cidrs to accept for ingress admin trafic"
  type    = list(string)
  default = []
}

###################################################### 
###### INGRESS - Runtime Rules  ########## 
###################################################### 

resource "aws_security_group_rule" "apiportal_runtime_ingress_rule1_bycidr" {
  count = contains(var.rules_profiles, "apiportal") && length(var.rules_apiportal_runtime_ingress_cidr_list) > 0 ? 1 : 0
  
  type              = "ingress"
  from_port         = 18101
  to_port           = 18102
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_apiportal_runtime_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

################################################
###### INGRESS - ADMIN Rules   ###### 
################################################

resource "aws_security_group_rule" "apiportal_admin_ingress_rule1_bycidr" {
  count = contains(var.rules_profiles, "apiportal") && length(var.rules_apiportal_admin_ingress_cidr_list) > 0 ? 1 : 0
  
  type              = "ingress"
  from_port         = 18000
  to_port           = 18020
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_apiportal_admin_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}