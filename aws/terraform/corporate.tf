#
# Corporate External IP
# Inspired by: https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started 
#
#

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Override with ipv4 corporate cidr block if required or 0.0.0.0/0 
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}
