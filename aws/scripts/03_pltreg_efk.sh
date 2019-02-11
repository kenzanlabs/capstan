#!/usr/bin/env bash

######################
# Add EFK
# Depends on Helm configured

######################


LGNAMESPACE=$1

echo "******************************************"
echo "=========================================="
echo " - BEGIN EFK -"
echo " - BLOCKS HELM on Elastic Install -"
echo "=========================================="

kubectl create ns $LGNAMESPACE

##elasticsearch 
# Not a fan of storing logs in same cluster because I could get IO cound nodes and then have to do
# a whole node selector blah blah blah
# If I had fluenX sending to cloudwatch logs I could either
# 1) use AWS elastic search offering
# 2) use elastic search on some nodes instead
helm install --name elasticsearch --namespace $LGNAMESPACE stable/elasticsearch --wait

##FluentX
#change to fluentbit
# So if we where REALLY doing AWS native leverage we would have this send to Cloud Watch Logs 
helm install --name fluentd --namespace $LGNAMESPACE stable/fluentd --set output.host=elasticsearch-client.$LGNAMESPACE.svc.cluster.local,output.port=9200

##kibana
#remember if you move elastic search you will need to move these references in the env
helm install --name kibana --namespace $LGNAMESPACE stable/kibana --set env.ELASTICSEARCH_URL=http://elasticsearch-client.$LGNAMESPACE.svc.cluster.local:9200,env.SERVER_BASEPATH=/api/v1/namespaces/$LGNAMESPACE/services/kibana/proxy


echo "=========================================="
echo " - END EFK -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10