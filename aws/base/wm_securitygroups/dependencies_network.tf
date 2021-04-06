################################################
################ Vars
################################################

variable "vpc_id" {
  description = "vpc id"
  type    = string
}

###################### network dependencies

data "aws_vpc" "main" {
  id = var.vpc_id
}