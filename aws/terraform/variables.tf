#
#
#

#### General

variable "gen_solution_name" {
  default = "cd-env"
  type    = "string"
}

variable "gen_project_name" {
  default = "capstan"
  type    = "string"
}

#### Spinnaker Config

variable "spinnaker_version" {
  default = "1.12.1"
  type    = "string"
}

variable "spinnaker_omitnamespace_list" {
  default = "istio-system,kube-system,spinnaker"
  type    = "string"
}

variable "dockerhub_address" {
  default = "index.docker.io"
  type    = "string"
}

variable "dockerhub_container_list" {
  default = "netflixoss/eureka netflixoss/zuul owasp/zap2docker-stable webgoat/webgoat-8.0 nparkskenzan/hellokenzan"
  type    = "string"
}

variable "spinnaker_dockerhubname" {
  default = "dockerhubimagerepository"
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

variable "capstan_user_role_name" {
  default = "capstan-user"
  type    = "string"
}

#### EC2

variable "ec2_key" {
  default = "capstan"
  type    = "string"
}

variable "ec2_key_file" {
  default = "capstan.pem"
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


variable "capstan_bastion_role_name" {
  default = "capstan-bastion"
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