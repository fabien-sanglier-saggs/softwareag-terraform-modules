variable vpc_cidr {
  type = string
}

variable private_subnets_cidr {
  type = list(string)
}

variable private_subnet_availability_zones {
  type = list(string)
}

variable public_subnets_cidr {
  type = list(string)
}

variable public_subnets_availability_zones {
  type = list(string)
}