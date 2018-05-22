#!/usr/bin/env bash

##########################
# Kenzan LLC -> Helm packages GKE
##########################
source $PWD/env.sh

echo "******************************************"
echo "=========================================="
echo " - Let's Get this Jenkins Thing Together -"
echo "=========================================="

#expecting tiller is in the environment

##nginx Ingress
helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true
## Jenkins
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
