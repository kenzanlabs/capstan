
############################################# Tools instance

TOOLS_SERVICE_ACCOUNT_NAME=halyard-tunnel-tools

############################################# GCP / GKE

#cloud storage location
BUCKET_LOCATION=us

############################################### Jenkins

##### TLS Paths if you have them enter them here and comment out line in create_jenkins.sh otherwise the files will be created at this locations
TLS_CERT="certificate.crt"
TLS_KEY="private.pem"
JENKINSNS="jenkins"
#only used for spinnaker configuration
JENKINS_ADMIN_USER="admin"
JENKINS_SAVED_PW=JenkinsPassword.txt
JENKINS_SAVED_IP=JenkinsIP.txt

JENKINS_PORT="8080"
JENKINS_NAMESPACE=$JENKINSNS
JENKINS_HELM_RELEASENAME="ci"

############################################ Halyard Spinnaker
ADDRESS=gcr.io
SERVICE_ACCOUNT_NAME=gcp-spinnaker
SERVICE_ACCOUNT_DEST=~/.gcp/gcp-account.json
REGISTRY_NAME=gcpimagerepository
SPINNAKER_VERSION="1.7.5"
CANARY_METRIC_STORE="stackdriver"

DOCKER_HUB_NAME="dockerhubimagerepository"
DOCKER_REPO="netflixoss/eureka netflixoss/zuul owasp/zap2docker-stable webgoat/webgoat-8.0"
DOCKER_ADDR="index.docker.io"

OMIT_NAMESPACES=$JENKINSNS
# we are assuming that glcoud credentials where added properly
KUBECONFIG=".kube/config"
