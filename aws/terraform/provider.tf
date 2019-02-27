#
#
# Provider using IAM user that can role assume

provider "aws" {
    ## Does your region have 3 AZs?
    region = "us-west-2"
    # keys of user that can role assume, these should be in the environment like:
    #export TF_VAR_ws_access_key="anaccesskey"
    #export TF_VAR_aws_secret_key="asecretkey"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"

 #   assume_role {
  #      # export TF_VAR_aws_account_id="numbers"
        # export TF_VAR_aws_role_name="name"
   #     role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
    #    session_name = "capstanOnAWS@kenzan.com"  
    #} 

}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}