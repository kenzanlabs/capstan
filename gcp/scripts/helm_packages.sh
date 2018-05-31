#!/usr/bin/env bash

##########################
#  Helm packages for GKE
##########################
source $PWD/env.sh

echo "******************************************"
echo "=========================================="
echo " - Let's Get Some K8 Packages Together -"
echo "=========================================="

#expecting tiller is in the environment
################## Optional Charts
###nginx Ingress
#helm install stable/nginx-ingress --name nginx-ingress --namespace nginxingress --set rbac.create=true

### Istio with sidecar injection Requires K8 1.9
#helm install install/kubernetes/helm/istio --name istio --namespace istio-system

### Cert-Manager
#helm install stable/cert-manage --name cert-mngr --namespace certmngr --set rbac.create=true

### DNS because if you have cert manager you might want the DNS help also
#helm install stable/external-dns --name dns --namespace dns -f external-dns.values

################ Required Charts
### Jenkins
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
