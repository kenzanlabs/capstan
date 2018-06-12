#!/usr/bin/env bash

##########################
# Configure DNS TLS
##########################
###
source $PWD/env.sh

echo "******************************************"
echo "=========================================="
echo " - Let's get DNS & TLS Termination Together -"
echo "=========================================="

PROJECT_NAME=$1
UX_FQDN=$2
API_FQDN=$3
DNS_ZONENAME=$4

echo "Project : $PROJECT_NAME "
echo "UX      : $UX_FQDN "
echo "API     : $API_FQDN "
echo "        : $DNS_ZONENAME "
echo "=========================================="

kubectl apply -f spin-deck-nodeport.yml
kubectl apply -f spin-gate-nodeport.yml
# Time to search replace for hostnames
cp spinnaker-ingress.yml.orig spinnaker-ingress.yml
sed -i "s/SPINUX/$UX_FQDN/g" spinnaker-ingress.yml
sed -i "s/SPINAPI/$API_FQDN/g" spinnaker-ingress.yml
#create some time for the nodeports, yes this is an arbitrary number
sleep 30
kubectl apply -f spinnaker-ingress.yml 
echo " ***** ATTENTION ******"
echo " ** Kubectl Lies!  **"
echo " ** we need to wait for backend services **"
echo " ** For Maybe Fifteen Minutes, Yikes! **"
echo " ** Then the reported IP is the actual IP**"

HEALTH_BACKENDS_COUNT=0

echo "Healthy Backends: "

while [[ $HEALTH_BACKENDS_COUNT -lt 3 ]]
do 
    
    echo -e ". $HEALTH_BACKENDS_COUNT \c"
    HEALTHY_BACKENDS=$(kubectl describe ingress --namespace spinnaker spinnaker-app-ingress | grep "backends")
    HEALTH_BACKENDS_COUNT=$(echo $HEALTHY_BACKENDS | grep -wo "HEALTHY" | wc -w)
    sleep 30

done



IP_for_DNS=$(kubectl get ing --namespace spinnaker spinnaker-app-ingress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")

echo "=========================================="
echo " - IP is  $IP_for_DNS for $UX_FQDN and $API_FQDN -"
echo "=========================================="

gcloud dns --project=$PROJECT_NAME record-sets transaction start --zone=$DNS_ZONENAME
gcloud dns --project=$PROJECT_NAME record-sets transaction add $IP_for_DNS --name=$UX_FQDN. --ttl=300 --type=A --zone=$DNS_ZONENAME
gcloud dns --project=$PROJECT_NAME record-sets transaction add $IP_for_DNS --name=$API_FQDN. --ttl=300 --type=A --zone=$DNS_ZONENAME
gcloud dns --project=$PROJECT_NAME record-sets transaction execute --zone=$DNS_ZONENAME


echo "=========================================="
echo " - Hopefully we have DNS & TLS Setup -"
echo " If everything worked:"
echo " https://$UX_FQDN is the place to be"
echo " Please Be Advised that DNS may take a while to propagate"
echo "=========================================="
echo "******************************************"

