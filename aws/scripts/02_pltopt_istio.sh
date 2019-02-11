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


cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: kiali
  namespace: $INAMESPACE
  labels:
    app: kiali
type: Opaque
data:
  username: $USRNM_H
  passphrase: $USRNM_H
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: grafana
  namespace: $INAMESPACE
  labels:
    app: grafana
type: Opaque
data:
  username: $USRNM_H
  passphrase: $USRNM_H
EOF

curl -L https://git.io/getLatestIstio | sh -

cd istio*




helm install install/kubernetes/helm/istio --name istio --namespace $INAMESPACE --set grafana.enabled=true,tracing.enabled=true,kiali.enabled=true

# return
cd

echo "=========================================="
echo " - END ISTIO -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10