#!/usr/bin/env bash

######################
# Add EFK
# Depends on Helm configured

######################


LGNAMESPACE=$1
RNAME="efk"
echo "******************************************"
echo "=========================================="
echo " - BEGIN EFK -"
echo " - BLOCKS HELM on Elastic Install -"
echo " - ignores passed namespace - installed into default -"
echo "=========================================="

kubectl create ns $LGNAMESPACE

##### All in one go ###########
### Elastic Stack with Fluent Bit and not Log Stash, blocking
#helm install --name $RNAME stable/elastic-stack --namespace $LGNAMESPACE --set logstash.enabled=false,fluent-bit.enabled=true,kibana.env.ELASTICSEARCH_URL=http://$RNAME-elasticsearch-client:9200 --wait

##### Below for individual ######

#### elasticsearch 
# Not a fan of storing logs in same cluster because I could get IO cound nodes and then have to do
# a whole node selector blah blah blah
# If I had fluenX sending to cloudwatch logs I could either
# 1) use AWS elastic search offering
# 2) use elastic search on some nodes instead
#helm install --name elasticsearch --namespace $LGNAMESPACE stable/elasticsearch --wait
helm install --name elasticsearch stable/elasticsearch --wait 


#### FluentX
#change to fluentbit
# So if we where REALLY doing AWS native leverage we would have this send to Cloud Watch Logs OR AWS Elastic Search
#helm install --name fluentx --namespace $LGNAMESPACE stable/fluent-bit --set backend.type=es,backend.es.host=elasticsearch-client
helm install --name fluent-bit  stable/fluent-bit --set backend.type=es,backend.es.host=elasticsearch-client


##### kibana
#remember if you move elastic search you will need to move these references in the env
#helm install --name kibana --namespace $LGNAMESPACE stable/kibana --set env.ELASTICSEARCH_URL=http://elasticsearch-client.$LGNAMESPACE.svc.cluster.local:9200
helm install --name kibana stable/kibana --set env.ELASTICSEARCH_URL=http://elasticsearch-client:9200

echo "=========================================="
echo " - END EFK -"
echo "=========================================="
echo "******************************************"
#pause log dump
sleep 10