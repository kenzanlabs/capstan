#!/usr/bin/env bash

##########################
# Create Spinnaker
##########################
###

echo "========= Deploy Spinnaker  =========="


hal deploy apply


echo "=========================================="
echo " - END Spinnaker Deploy Attempt -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10

