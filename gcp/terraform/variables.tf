
#############################
### Common items to set 
#############################

variable "gcp_project_id" {}

variable "ssh_user" {}

variable "regionzone" {
  default="us-east4-b"
}

variable "creds_file" {
  default="gcp-account.json"
}


############################# 
############# Defaults
#############################




variable "bucket_location" {
  default="us"
}

variable "halyard_machine_type" {
  default="n1-standard-1"
}

variable "halyard_machine_name" {
  default="halyard-tunnel"
}

variable "ubuntu_image" {
  default="ubuntu-1604-xenial-v20190816"
}


variable "ssh_private_key_location" {
  default="~/.ssh/google_compute_engine"
}


variable "service_account_name" {
  default="halyard-tunnel-tools"
}

variable "spinnaker_service_account_name" {
  default = "gcp-spinnaker"
}

variable "created_by" {
  default="kenzan-capstan"
}

variable "gke_additional_zones" {
    description = ""
    type = "list"
    default = []
}

#############################
#### Advanced DNS TLS Oauth2  
#############################
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
