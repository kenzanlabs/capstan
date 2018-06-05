#!/usr/bin/env bash

##########################
# Configure Oauth2
##########################
###
source $PWD/env.sh

echo "******************************************"
echo "=========================================="
echo " - Let's get Oauth2 Config Together -"
echo "=========================================="

hal config security ui edit --override-base-url $DNSTLSUI
hal config security api edit --override-base-url $DNSTLSAPI
hal config security authn oauth2 edit --client-id $CLIENT_ID  --client-secret $CLIENT_SECRET --provider $PROVIDER  --user-info-requirements hd=$GSDOMAIN
hal config security authn oauth2 enable


echo "=========================================="
echo " - OAUTH2 config -"
echo "=========================================="
echo "******************************************"
