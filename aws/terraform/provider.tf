#
#
# Provider using IAM user that can role assume

provider "aws" {
    ## set the region in a different manner in the future...but there are only a couple EKS versions
    region = "us-west-2"
    # keys of user that can role assume, these should be in the environment like:
    #export AWS_ACCESS_KEY_ID="anaccesskey"
    #export AWS_SECRET_ACCESS_KEY="asecretkey"
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