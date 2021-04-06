resource "aws_security_group" "dynamicsecgroup" {
  name        = join(var.name_delimiter, [ var.name_prefix_short, var.group_name ] )
  description = var.group_description
  vpc_id      = data.aws_vpc.main.id

  //  Use our common tags and add a specific name.
  tags = merge(
    var.common_tags,
    {
      "Name" = join(var.name_delimiter, [ var.name_prefix_long, var.group_name ] )
    }
  )
}