#
#
#


#### General

variable "gen_solution_name" {
  default = "cicd-runtime"
  type    = "string"
}

variable "gen_project_name" {
  default = "capstan"
  type    = "string"
}

#### Network

variable "net_name" {
  default = "capstan-network"
  type    = "string"
}


#### EKS

variable "eks_instance_size" {
  default = "m4.large"
  type    = "string"
}

variable "ec2_key" {
  default = "capstan"
  type    = "string"
}


#### PROVIDER VALUES OVER RIDE with TF_VAR as exports
variable "aws_access_key" {
  default = ""
  type    = "string"
}

variable "aws_secret_key" {
  default = ""
  type    = "string"
}

variable "aws_account_id" {
  default = ""
  type    = "string"
}

variable "aws_role_name" {
  default = ""
  type    = "string"
}