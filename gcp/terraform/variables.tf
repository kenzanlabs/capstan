variable "region" {}
variable "gcp_project_id" {}
variable "zone" {}

variable "halyard_machine_type" {}
variable "halyard_machine_name" {}
variable "ubuntu_image" {}

variable "ssh_user" {}
variable "ssh_private_key_location" {}
variable "creds_file" {}
variable "service_account_name" {}

variable "created_by" {}

#### Advanced DNS TLS Oauth2  
variable "ux_fqdn" {
  default = "spinnaker.example.com"
}

variable "api_fqdn" {
  default = "spinnaker-api.example.com"
}

variable "gcp_dns_zonename" {
  # IF you are no using GCP DNS but your own DNS just leave this to be this name
  # IE when we seen this name on provision we just skip the GCP DNS step
  default = "xxxx-some-xxxx-zone-xxx-name"
}

variable "oauth2_clientid" {
  default = "123413241234123412341234.apps.googleusercontent.com"
}

variable "oauth2_secret" {
  default = "asdinaaskdjadfikahsdkhf"
}

variable "gsuite" {
  default = "yourgsuitedomain.com"
}
