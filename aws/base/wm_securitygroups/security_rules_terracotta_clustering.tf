
####################################################
######    TERRACOTTA - Clustering Rules     ########
####################################################

resource "aws_security_group_rule" "terracotta_clustering_rule1" {  
  count = contains(var.rules_profiles, "terracotta_clustering") ? 1 : 0

  type              = "ingress"
  from_port         = 9530
  to_port           = 9530
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "terracotta_clustering_rule2" {  
  count = contains(var.rules_profiles, "terracotta_clustering") ? 1 : 0
  
  type              = "ingress"
  from_port         = 9540
  to_port           = 9540
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "terracotta_clustering_rule3" {  
  count = contains(var.rules_profiles, "terracotta_clustering") ? 1 : 0
  
  type              = "egress"
  from_port         = 9530
  to_port           = 9530
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.dynamicsecgroup.id
}

resource "aws_security_group_rule" "terracotta_clustering_rule4" {  
  count = contains(var.rules_profiles, "terracotta_clustering") ? 1 : 0
  
  type              = "egress"
  from_port         = 9540
  to_port           = 9540
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.dynamicsecgroup.id
}