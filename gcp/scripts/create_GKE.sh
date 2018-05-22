#!/usr/bin/env bash

##########################
# Kenzan LLC Create GKE for SpinnakerJenkins
#
## Can your GCP Service Account do this?
#
# nparks@kenzan.com
##########################
###

PROJECT_NAME=$1
CLUSTER_NAME=$2
CLUSTER_ZONE=$3

echo "******************************************"
echo "=========================================="
echo " - Let's Get this GKE Thing Together -"
echo "=========================================="
echo "  CLUSTER_NAME: $CLUSTER_NAME"
echo "  CLUSTER_ZONE: $CLUSTER_ZONE"

# enable commands
echo ">>>>> Enable gcloud API needs"

#make kubectl happy for later usage
gcloud config set container/use_client_certificate true
gcloud container clusters get-credentials --zone $CLUSTER_ZONE $CLUSTER_NAME

kubectl cluster-info
echo ">>>>> Helm Init"
kubectl create -f tiller_rbac.yml
#give k8 a break if your cluster is small
sleep 5
helm init --service-account tiller --wait
# give the cluster a break, if your K8 is small
helm version

echo "=========================================="
echo " - GKE Thing Together -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10
