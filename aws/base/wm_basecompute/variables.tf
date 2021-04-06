variable "region" {
  description = "cloud region"
  type    = string
}

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
  description = "tags for the module"
  type    = map(string)
  default = {}
}

variable "compute_instance_name" {
  description = "name of the compute resource"
  type    = string
}

variable "compute_securitygroup_ids" {
  description = "list of security groups to add to the ec2 instances"
  type    = list(string)
  default = []
}

variable "compute_common_tags" {
  description = "tags for the module specifically for the compute resources"
  type    = map(string)
  default = {}
}

variable "compute_setup_server_bootstrap_profile" {
  description = "The type of bootstrapping to do"
  type    = string
  default = ""
}

variable "compute_ssh_key_pair_name" {
  description = "SSH key pair id"
  type    = string
}

variable "compute_image_per_region" {
  description = "base image to use"
  type    = map(string)
  default = {}
}

variable "compute_instancesize" {
  description = "instance size (ie. cloud type)"
  type    = string
}

variable "compute_creditspecification" {
  description = "credit specification for burstable instances (unlimited or standard)"
  type    = string
  default = "standard"
}

variable "compute_instancecount" {
  description = "number of nodes"
  type    = number
  default = 1
}

variable "compute_hostname" {
  description = "hostname"
  type    = string
}

variable "compute_iam_instance_profile_name" {
  description = "The IAM profile to attach to the instances"
  type    = string
  default = ""
}

variable "compute_image_admin_user" {
  description = "admin user for the base image to use"
  type    = string
}

## disk for root
variable "compute_disk_root_storage_type" {
  description = "root disk type"
  type    = string
}

## disk for homes
variable "compute_disk_userhomes_create" {
  description = "create a userhomes disk"
  type    = bool
  default = false
}

variable "compute_disk_userhomes_storage_type" {
  description = "user homes disk type"
  type    = string
  default = ""
}

variable "compute_disk_userhomes_size_gb" {
  description = "user homes disk size (gb)"
  type    = number
  default = 0
}

## disk for softwares
variable "compute_disk_softwares_create" {
  description = "create a softwares disk"
  type    = bool
  default = false
}

variable "compute_disk_softwares_storage_type" {
  description = "softwares disk type"
  type    = string
  default = ""
}

variable "compute_disk_softwares_size_gb" {
  description = "softwares disk size (gb)"
  type    = number
  default = 0
}

variable "compute_disk_softwares_mount_dir" {
  description = "mount dir for softwares"
  type    = string
  default = ""
}

variable "compute_disk_softwares_username" {
  description = "softwares user to provision"
  type    = string
  default = ""
}

variable "compute_disk_softwares_userid" {
  description = "softwares user id to provision"
  type    = number
  default = 0
}

variable "compute_disk_softwares_groupname" {
  description = "softwares group to provision"
  type    = string
  default = ""
}

variable "compute_disk_softwares_groupid" {
  description = "softwares group id to provision"
  type    = number
  default = 0
}

## disk for data
variable "compute_disk_data_create" {
  description = "create a data disk"
  type    = bool
  default = false
}

variable "compute_disk_data_storage_type" {
  description = "data disk type"
  type    = string
  default = ""
}

variable "compute_disk_data_size_gb" {
  description = "data disk size (gb)"
  type    = number
  default = 0
}

variable "compute_disk_data_mount_dir" {
  description = "mount dir for data"
  type    = string
  default = ""
}

variable "compute_disk_data_username" {
  description = "data user to provision"
  type    = string
  default = ""
}

variable "compute_disk_data_userid" {
  description = "data user id to provision"
  type    = number
  default = 0
}

variable "compute_disk_data_groupname" {
  description = "data group to provision"
  type    = string
  default = ""
}

variable "compute_disk_data_groupid" {
  description = "data group id to provision"
  type    = number
  default = 0
}