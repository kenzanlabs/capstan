#!/usr/bin/env bash

######################
# Provide  Artifacts for Spinnaker
######################
source $PWD/env.sh

CLUSTER_NAME=$1


####
echo "========= Configure S3 as Artifact =========="
echo "CLUSTER_NAME = $CLUSTER_NAME"

####


hal config features edit --artifacts true


hal config artifact s3 account add "$CLUSTER_NAME-artifacts" --region us-west-2 


hal config artifact s3 enable