variable "name_prefix_short" {
  description = "a short prefix to apply to all resource names"
  type    = string
}

variable "name_prefix_long" {
  description = "a longer prefix to apply to all resource Name tags"
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

variable "loadbalancer_id" {
  description = "load balancer id"
  type    = string
}

variable "loadbalancer_listener_arn" {
  description = "load balancer listener arn"
  type    = string
}
