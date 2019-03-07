#!/usr/bin/env bash

######################
# Add istio
# Depends on Helm configured
# istio is used to add Jaeger because reasons
# istio installer used to add prometheus and grafana because reasons
# If you do not use this you need to add prometheus a different way for Spinnaker/canary
# But you reall really really want to get all this done in one shot :wink:
######################


USRNM=$1
PASSPHRASE=$2

echo "******************************************"
echo "=========================================="
echo " - BEGIN ISTIO -"
echo "=========================================="


INAMESPACE=istio-system
kubectl create ns $INAMESPACE

USRNM_H=$(echo -n $USRNM | base64)
PASSPHRASE_H=$(echo -n $PASSPHRASE | base64)


sed -i "s/SEDINAMESPACE/$INAMESPACE/g" grafana_secret.yml
sed -i "s/SEDUSRNM_H/$USRNM_H/g" grafana_secret.yml
sed -i "s/SEDPASSWD_H/$PASSPHRASE_H/g" grafana_secret.yml

sed -i "s/SEDINAMESPACE/$INAMESPACE/g" kiali_secret.yml
sed -i "s/SEDUSRNM_H/$USRNM_H/g" kiali_secret.yml
sed -i "s/SEDPASSWD_H/$PASSPHRASE_H/g" kiali_secret.yml

kubectl apply -f grafana_secret.yml
kubectl apply -f kiali_secret.yml

curl -L https://git.io/getLatestIstio | sh -

cd istio*




helm install install/kubernetes/helm/istio --name istio --namespace $INAMESPACE --set grafana.enabled=true,tracing.enabled=true,kiali.enabled=true,ingress.enabled=false,gateways.istio-ingressgateway.enabled=false,gateways.istio-egressgateway.enabled=false

# return
cd

echo "=========================================="
echo " - END ISTIO -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10