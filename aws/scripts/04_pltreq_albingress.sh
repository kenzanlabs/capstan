#!/usr/bin/env bash

######################
# We need and ingress controller for the ALB
# Depends on 
######################


ALB_VERISON=v1.1.0

echo "******************************************"
echo "=========================================="
echo " - BEGIN AWS ELB -"
echo "=========================================="


wget https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/$ALB_VERISON/docs/examples/alb-ingress-controller.yaml
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/$ALB_VERISON/docs/examples/rbac-role.yaml

## edit the YAML

## apply the yaml
kubectl apply -f rbac-role.yaml
kubectl apply -f alb-ingress-controller.yaml


echo "=========================================="
echo " - END AWS ELB -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10