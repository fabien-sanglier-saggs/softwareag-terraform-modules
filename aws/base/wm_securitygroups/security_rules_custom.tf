####################################################
###### Rules Variables  ########
####################################################

variable "rules_custom_ingress_ports" {
  description = "ports to allow on ingress"
  type    = list(string)
  default = []
}

variable "rules_custom_egress_ports" {
  description = "ports to allow on egress"
  type    = list(string)
  default = []
}

variable "rules_custom_ingress_security_group_id" {
  description = "source security group id for the ingress rule"
  type    = string
  default = ""
}

variable "rules_custom_ingress_cidr_list" {
  description = "source cidrs to accept for the ingress rule"
  type    = list(string)
  default = []
}

variable "rules_custom_egress_cidr_list" {
  description = "target cidrs to accept for the egress rule"
  type    = string
  default = ""
}

variable "rules_custom_egress_security_group_id" {
  description = "target security group id for the egress rule"
  type    = string
  default = ""
}

###################################################### 
###### INGRESS - Runtime Rules  ########## 
###################################################### 

resource "aws_security_group_rule" "custom_ingress_rule_bycidr" {
  count = (contains(var.rules_profiles, "custom") && 
          length(var.rules_custom_ingress_cidr_list) > 0 && 
          length(var.rules_custom_ingress_ports) > 0) ? length(var.rules_custom_ingress_ports) : 0
    
  type              = "ingress"
  from_port         = var.rules_custom_ingress_ports[count.index]
  to_port           = var.rules_custom_ingress_ports[count.index]
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_custom_ingress_cidr_list
    ]
  )
  security_group_id = aws_security_group.dynamicsecgroup.id
}

#############################################################################
###### EGRESS - Access to Terracotta Nodes  #####################
#############################################################################

resource "aws_security_group_rule" "custom_outbound_rule_bycidr" {
  count = (contains(var.rules_profiles, "custom") && 
          length(var.rules_custom_egress_cidr_list) > 0 && 
          length(var.rules_custom_egress_ports) > 0) ? length(var.rules_custom_egress_ports) : 0
          
  type              = "egress"
  from_port         = var.rules_custom_egress_ports[count.index]
  to_port           = var.rules_custom_egress_ports[count.index]
  protocol          = "tcp"
  cidr_blocks = flatten(
    [
      var.rules_custom_egress_cidr_list
    ]
  )
  
  security_group_id = aws_security_group.dynamicsecgroup.id
}
