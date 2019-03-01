#!/usr/bin/env bash

######################
# Spinnaker helm repo
######################
source $PWD/env.sh

URL=$1


####
echo "========= Configure HELM Spinnaker =========="
echo "Url = $URL"
echo "URL should be https://<bucketname with FQDN/charts"
echo "See storage.tf"

####

hal config artifact helm account add s3HelmRepo --repository $URL
hal config artifact helm enable

##we are going to add this plugin for now just because
#helm plugin install https://github.com/hypnoglow/helm-s3.git
#helm repo add my-charts s3://my-helm-central-bucket/charts



echo "=========================================="
echo " - END Spin HELM configure -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10