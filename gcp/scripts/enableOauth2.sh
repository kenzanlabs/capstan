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

PROJECT_NAME=$1
DNSTLSUI=$2
DNSTLSAPI=$3
CLIENT_ID=$4
CLIENT_SECRET=$5
GSDOMAIN=$6

echo "Project : $PROJECT_NAME "
echo "UX      : $DNSTLSUI "
echo "API     : $DNSTLSAPI "
echo "GSuite  : $GSDOMAIN"
echo "=========================================="

hal config security ui edit --override-base-url "https://$DNSTLSUI"
hal config security api edit --override-base-url "https://$DNSTLSAPI"
hal config security authn oauth2 edit --client-id $CLIENT_ID  --client-secret $CLIENT_SECRET --provider google --user-info-requirements hd=$GSDOMAIN
hal config security authn oauth2 enable


echo "=========================================="
echo " - OAUTH2 config complete -"
echo "=========================================="
echo "******************************************"
