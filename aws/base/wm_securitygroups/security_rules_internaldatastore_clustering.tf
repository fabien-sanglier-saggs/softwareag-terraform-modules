####################################################
###### INTERNAL DATASTORE Clustering Rules   ###### 
####################################################

resource "aws_security_group_rule" "internaldatastore_clustering_rule1" {  
  count = contains(var.rules_profiles, "internaldatastore_clustering") ? 1 : 0

  type              = "ingress"
  from_port         = 9240
  to_port           = 9240
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "internaldatastore_clustering_rule2" {  
  count = contains(var.rules_profiles, "internaldatastore_clustering") ? 1 : 0
  
  type              = "ingress"
  from_port         = 9340
  to_port           = 9340
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "internaldatastore_clustering_rule3" {  
  count = contains(var.rules_profiles, "internaldatastore_clustering") ? 1 : 0
  
  type              = "egress"
  from_port         = 9240
  to_port           = 9240
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "internaldatastore_clustering_rule4" {  
  count = contains(var.rules_profiles, "internaldatastore_clustering") ? 1 : 0
  
  type              = "egress"
  from_port         = 9340
  to_port           = 9340
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.dynamicsecgroup.id
}