#!/usr/bin/env bash

##########################
# Additional Helm Setup
##########################



echo "******************************************"
echo "=========================================="
echo " - BEGIN HELM -"
echo "=========================================="

kubectl cluster-info
echo ">>>>> Helm Init"
kubectl create -f tiller_rbac.yml
#give k8 a break if your cluster is small
sleep 5
helm init --service-account tiller --wait
helm version

## create apps namespace
kubectl create namespace apps
kubectl create namespace meshapps
kubectl create namespace cdtools

#side car injection for meshapps
kubectl label namespace meshapps istio-injection=enabled
#kubectl label namespace default istio-injection=enabled #add back once we move logging out of this namespace



echo "=========================================="
echo " - END HELM -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10