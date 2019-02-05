#!/usr/bin/env bash

######################
# Configure K8 for Spinnaker
######################
source $PWD/env.sh

CLUSTER_NAME=$1

####
echo "========= Configure K8 for Spinnaker =========="
echo "Cluster Name = $CLUSTER_NAME"
####

hal config version edit --version $SPINNAKER_VERSION

hal config features edit --pipeline-templates true


hal config provider docker-registry account add $DOCKER_HUB_NAME  --address $DOCKER_ADDR --repositories $DOCKER_REPO
hal config provider docker-registry enable


IMAGE_REPOS=$DOCKER_HUB_NAME

CONTEXT=$(kubectl config current-context)

#create namespace
kubectl create namespace spinnaker
#create service account
kubectl create -f spinnaker-svcacct.yml
#don't trust kubectl so let's pause
sleep 5

TOKEN=$(kubectl get secret --context $CONTEXT  $(kubectl get serviceaccount spinnaker-service-account --context $CONTEXT -n spinnaker  -o jsonpath='{.secrets[0].name}')  -n spinnaker -o jsonpath='{.data.token}' | base64 --decode)

kubectl config set-credentials ${CONTEXT}-token-user --token $TOKEN
kubectl config set-context $CONTEXT --user ${CONTEXT}-token-user

hal config provider kubernetes account add $CLUSTER_NAME  --context $CONTEXT --docker-registries $IMAGE_REPOS --omit-namespaces $OMIT_NAMESPACES

hal config deploy edit --type distributed --account-name $CLUSTER_NAME

hal config provider kubernetes enable