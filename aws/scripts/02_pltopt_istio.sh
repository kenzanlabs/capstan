#!/usr/bin/env bash

######################
# Add istio
# Depends on Helm configured
# istio is used to add EFK + Jaeger because reasons
# istio installer used to add prometheus and grafana because reasons
# If you do not use this you need to add prometheus a different way for Spinnaker/canary
# But you reall really really want to get all this done in one shot :wink:
######################


echo "******************************************"
echo "=========================================="
echo " - BEGIN ISTIO -"
echo "=========================================="


echo "=========================================="
echo " - END ISTIO -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10