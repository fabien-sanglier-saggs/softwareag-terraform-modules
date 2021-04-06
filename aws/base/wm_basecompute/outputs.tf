################################################
################ Outputs
################################################

output "ids" {
  value = aws_instance.wmbasecomputelinux.*.id
}

output "private_dns" {
  value = aws_instance.wmbasecomputelinux.*.private_dns
}

output "private_ip" {
  value = aws_instance.wmbasecomputelinux.*.private_ip
}

output "custom_dns" {
  value = aws_route53_record.wmbasecomputelinux.*.name
}