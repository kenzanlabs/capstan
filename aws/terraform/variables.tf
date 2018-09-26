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

#### EC2

variable "ec2_key" {
  default = "capstan"
  type    = "string"
}

variable "ec2_ami_id" {
  # We are looking for ubuntu 16 LTS +
  default = "ami-0e32ec5bc225539f5"
  type    = "string"
}

variable "ec2_ssh_user" {
  default = "ubuntu"
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