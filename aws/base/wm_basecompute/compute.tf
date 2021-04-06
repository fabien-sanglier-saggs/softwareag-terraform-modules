################################################
################ Locals
################################################

locals {
  wmbasecomputelinux_compute_tags = merge(
    var.common_tags,
    var.compute_common_tags
  )
}

resource "time_static" "resource_created" {
  triggers = {
    # Save the new time each switch of an AMI id
    ami_id = var.compute_image_per_region[var.region]
  }
}

################################################
################ DNS
################################################

resource "aws_route53_record" "wmbasecomputelinux" {
  count = var.compute_instancecount

  zone_id = data.aws_route53_zone.dns.zone_id
  name    = join(".", [ join("", [ var.compute_hostname, count.index + 1 ] ), var.name_prefix_short, local.dns_internal_apex ] ) 
  type    = "A"
  ttl     = 300
  records = [
    aws_instance.wmbasecomputelinux[count.index].private_ip
  ]
}

################################################
################ VM specifics
################################################

resource "aws_instance" "wmbasecomputelinux" {
  count = var.compute_instancecount

  subnet_id                   = data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].id
  ami                         = time_static.resource_created.triggers.ami_id
  instance_type               = var.compute_instancesize
  user_data                   = templatefile(
                                  join("/", [ path.module, "resources", "setup-server.sh.tpl" ] ),
                                  {
                                    logic_content_users = file(join("/", [ path.module, "resources", join("", [ "setup-server-", "users", ".sh"] ) ] ) )
                                    logic_content_disks = file(join("/", [ path.module, "resources", join("", [ "setup-server-", "disks", ".sh"] ) ] ) )
                                    logic_content_defaults = file(join("/", [ path.module, "resources", join("", [ "setup-server-", "defaults", ".sh"] ) ] ) )
                                    logic_content_custom = var.compute_setup_server_bootstrap_profile == "" ? "" : file(join("/", [ path.module, "resources", join("", [ "setup-server-", var.compute_setup_server_bootstrap_profile, ".sh"] ) ] ) )
                                    adminuser = var.compute_image_admin_user
                                    volume_id_user_home = var.compute_disk_userhomes_create == false ? "" : aws_ebs_volume.wmbasecomputelinux_home[count.index].id
                                    volume_id_software = var.compute_disk_softwares_create == false ? "" : aws_ebs_volume.wmbasecomputelinux_software[count.index].id
                                    volume_id_data = var.compute_disk_data_create == false ? "" : aws_ebs_volume.wmbasecomputelinux_data[count.index].id
                                    mount_dir_software = var.compute_disk_softwares_mount_dir
                                    mount_dir_data = var.compute_disk_data_mount_dir
                                    software_username = var.compute_disk_softwares_username
                                    software_userid = var.compute_disk_softwares_userid
                                    software_groupname = var.compute_disk_softwares_groupname
                                    software_groupid = var.compute_disk_softwares_groupid
                                    data_username = var.compute_disk_data_username
                                    data_userid = var.compute_disk_data_userid
                                    data_groupname = var.compute_disk_data_groupname
                                    data_groupid = var.compute_disk_data_groupid
                                  }
                                )

  key_name                    = var.compute_ssh_key_pair_name
  iam_instance_profile        = var.compute_iam_instance_profile_name
  associate_public_ip_address = "false"

  credit_specification {
    cpu_credits = var.compute_creditspecification
  }
    
  root_block_device {
    volume_type = var.compute_disk_root_storage_type
    delete_on_termination = true
  }

  volume_tags = merge(
    local.wmbasecomputelinux_compute_tags,
    {
      "Name" = join(var.name_delimiter, [ var.name_prefix_long, var.compute_instance_name, count.index + 1, "root", data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone ] )
      "az"   = data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone
      "Date-Created" = formatdate("DD MMM YYYY hh:mm ZZZ", time_static.resource_created.rfc3339)
      "Usage" = "root volume"
    },
  )

  vpc_security_group_ids = var.compute_securitygroup_ids
  
  //  Use our common tags and add a specific name.
  tags = merge(
    local.wmbasecomputelinux_compute_tags,
    {
      "Name" = join(var.name_delimiter, [ var.name_prefix_long, var.compute_instance_name, count.index + 1, data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone ] )
      "az"   = data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone
      "custom internal dns" = join(".", [ join("", [ var.compute_hostname, count.index + 1 ] ), var.name_prefix_short, local.dns_internal_apex ] )
      "Date-Created" = formatdate("DD MMM YYYY hh:mm ZZZ", time_static.resource_created.rfc3339)
    },
  )
}

resource "aws_ebs_volume" "wmbasecomputelinux_software" {
  count = var.compute_disk_softwares_create == false ? 0 : var.compute_instancecount

  availability_zone = data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone
  type              = var.compute_disk_softwares_storage_type
  size              = var.compute_disk_softwares_size_gb
  
  tags = merge(
    local.wmbasecomputelinux_compute_tags,
    {
      "Name" = join(var.name_delimiter, [ var.name_prefix_long, var.compute_instance_name, count.index + 1, "apps", data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone ] )
      "az"   = data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone
      "Date-Created" = formatdate("DD MMM YYYY hh:mm ZZZ", time_static.resource_created.rfc3339)
      "Usage" = "softwares"
    },
  )
}

resource "aws_ebs_volume" "wmbasecomputelinux_home" {
  count = var.compute_disk_userhomes_create == false ? 0 : var.compute_instancecount

  availability_zone = data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone
  type              = var.compute_disk_userhomes_storage_type
  size              = var.compute_disk_userhomes_size_gb

  tags = merge(
    local.wmbasecomputelinux_compute_tags,
    {
      "Name" = join(var.name_delimiter, [ var.name_prefix_long, var.compute_instance_name, count.index + 1, "home", data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone ] )
      "az"   = data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone
      "Date-Created" = formatdate("DD MMM YYYY hh:mm ZZZ", time_static.resource_created.rfc3339)
      "Usage" = "user-homes"
    },
  )
}

resource "aws_ebs_volume" "wmbasecomputelinux_data" {
  count = var.compute_disk_data_create == false ? 0 : var.compute_instancecount

  availability_zone = data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone
  type              = var.compute_disk_data_storage_type
  size              = var.compute_disk_data_size_gb

  tags = merge(
    local.wmbasecomputelinux_compute_tags,
    {
      "Name" = join(var.name_delimiter, [ var.name_prefix_long, var.compute_instance_name, count.index + 1, "home", data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone ] )
      "az"   = data.aws_subnet.compute[count.index%length(data.aws_subnet.compute)].availability_zone
      "Date-Created" = formatdate("DD MMM YYYY hh:mm ZZZ", time_static.resource_created.rfc3339)
      "Usage" = "data"
    },
  )
}

resource "aws_volume_attachment" "wmbasecomputelinux_home" {
  count = var.compute_disk_userhomes_create == false ? 0 : var.compute_instancecount
  
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.wmbasecomputelinux_home[count.index].id
  instance_id = aws_instance.wmbasecomputelinux[count.index].id
}

resource "aws_volume_attachment" "wmbasecomputelinux_software" {
  count = var.compute_disk_softwares_create == false ? 0 : var.compute_instancecount
  
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.wmbasecomputelinux_software[count.index].id
  instance_id = aws_instance.wmbasecomputelinux[count.index].id
}

resource "aws_volume_attachment" "wmbasecomputelinux_data" {
  count = var.compute_disk_data_create == false ? 0 : var.compute_instancecount
  
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.wmbasecomputelinux_data[count.index].id
  instance_id = aws_instance.wmbasecomputelinux[count.index].id
}