###################################################################
################ Network Dependencies Vars
###################################################################

variable "vpc_id" {
  description = "vpc id"
  type    = string
}

variable "dns_zoneid" {
  description = "dns zone id"
  type    = string
}

variable "compute_subnet_shortname" {
  description = "shortname of the subnets where this resource should be"
  type    = string
}

###################################################################
################  VPC reference
###################################################################

data "aws_vpc" "main" {
  id = var.vpc_id
}

###################################################################
################  Reference the DNS to register the resources
###################################################################

data "aws_route53_zone" "dns" {
  zone_id = var.dns_zoneid
}

locals {
  dns_internal_apex = substr(
    data.aws_route53_zone.dns.name,
    0,
    length(data.aws_route53_zone.dns.name),
  )
}

###################################################################
################ Subnets by "shortname" tags
###################################################################

data "aws_subnet_ids" "compute" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    ShortName = var.compute_subnet_shortname
  }
}

data "aws_subnet" "compute_unsorted" {
  count = length(data.aws_subnet_ids.compute.ids)
  id    = tolist(data.aws_subnet_ids.compute.ids)[count.index]
}

data "aws_subnet" "compute" {
  count = length(local.subnet_compute_ids_sorted_by_az)
  id    = element(local.subnet_compute_ids_sorted_by_az, count.index)
}

locals {
  subnet_compute_ids_sorted_by_az = values(
    zipmap(
      data.aws_subnet.compute_unsorted.*.availability_zone,
      data.aws_subnet.compute_unsorted.*.id,
    ),
  )
}