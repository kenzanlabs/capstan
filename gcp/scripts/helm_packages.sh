#!/usr/bin/env bash

##########################
# Kenzan LLC -> Jenkins on Existing GKE
# 
# Can your GCP Service Account do this?
# Did you create the GKE environment first?
#
# nparks@kenzan.com
##########################
source $PWD/env.sh

echo "******************************************"
echo "=========================================="
echo " - Let's Get this Jenkins Thing Together -"
echo "=========================================="

#expecting tiller is in the environment
#the wait flag means everything should be done...the replace flag means stop over existing
helm install stable/jenkins --name $JENKINS_HELM_RELEASENAME --namespace $JENKINSNS --replace --wait


JENKINS_ADDRESS=$(kubectl get svc --namespace jenkins ci-jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
JENKINS_PW=`printf $(kubectl get secret --namespace $JENKINS_NAMESPACE $JENKINS_HELM_RELEASENAME-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo`

echo "=========================================="
echo " - Jenkins with $JENKINS_PW at $JENKINS_ADDRESS -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10
