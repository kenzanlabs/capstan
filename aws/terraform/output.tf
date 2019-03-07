#
#
#

output "ip_of_bastion" {
    value="${aws_instance.bastion.public_ip}"
}

output "dns_of_bastion" {
    value="${aws_instance.bastion.public_dns}"
}
