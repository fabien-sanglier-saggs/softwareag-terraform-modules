variable "name_prefix_short" {
  description = "a short prefix to apply to all resource names"
  type    = string
}

variable "name_prefix_long" {
  description = "a longer prefix to apply to all resource Name tags"
  type    = string
}

variable "group_name" {
  description = "name of the security group"
  type    = string
}

variable "group_description" {
  description = "description of the security group"
  type    = string
}

variable "name_delimiter" {
  description = "delimiter for names"
  type    = string
  default = "-"
}

variable "common_tags" {
  description = "common tags for all the resources in the module"
  type    = map(string)
  default = {}
}

variable "rules_profiles" {
  description = "List of security profiles to add to the security group"
  type    = list(string)
  default = []
}