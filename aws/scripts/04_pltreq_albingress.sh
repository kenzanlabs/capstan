#!/usr/bin/env bash

######################
# We need and ingress controller for the ALB
# Depends on 
######################

CLUSTERNAME=$1
KUBE2IAMROLEARN=$2
ALB_VERISON=v1.0.0

echo "******************************************"
echo "=========================================="
echo " - BEGIN AWS ALB -"
echo "ClusterName = $CLUSTERNAME"
echo "ARN = $KUBE2IAMROLEARN"
echo "=========================================="


#wget https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/$ALB_VERISON/docs/examples/alb-ingress-controller.yaml
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/$ALB_VERISON/docs/examples/rbac-role.yaml

## edit the YAML
cp albingress_$ALB_VERISON.yml albingress.yml
sed -i "s/SEDCLUSTERNAMEHERE/$CLUSTERNAME/g" albingress.yml
#Arns have a slash in them, need to use different delimiters here
sed -i "s[SEDIAMROLEARN[$KUBE2IAMROLEARN[g" albingress.yml
## apply the yaml
kubectl apply -f rbac-role.yaml
kubectl apply -f albingress.yml



echo "=========================================="
echo " - END AWS ALB -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10