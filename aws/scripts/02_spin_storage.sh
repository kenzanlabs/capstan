#!/usr/bin/env bash

######################
# Provide  Storage Spinnaker
######################
source $PWD/env.sh

BUCKET_NAME=$1
ROLE_NAME=$2

####
echo "========= Configure S3 Spinnaker =========="
echo "BucketName = $BUCKET_NAME"
echo "RoleName = $ROLE_NAME"
####

hal config storage s3 edit --assume-role $ROLE_NAME --bucket $BUCKET_NAME --region us-west-2

hal config storage edit --type s3

echo "=========================================="
echo " - END Spin s3 configure -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10