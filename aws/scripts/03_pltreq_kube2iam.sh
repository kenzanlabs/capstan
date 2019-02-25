#!/usr/bin/env bash

######################
# We need Kube2iam because we a proper users of AWS IAM controllers
# Depends on Helm
######################


echo "******************************************"
echo "=========================================="
echo " - BEGIN KUBE2IAM -"
echo "=========================================="

#not installing extra IAM roles
helm install stable/kube2iam --name k2iam --set rbac.create=true,host.iptables=true,host.interface=eni+


echo "=========================================="
echo " - END KUBE2IAM -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10
