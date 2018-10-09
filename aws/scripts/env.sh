
############################################### TLS

TLS_CERT="certificate.crt"
TLS_KEY="private.pem"

############################################### Jenkins


JENKINSNS="jenkins"
#only used for spinnaker configuration
JENKINS_ADMIN_USER="admin"
JENKINS_PORT="8080"
JENKINS_HELM_RELEASENAME="ci"

############################################  Spinnaker

SPINNAKER_VERSION="1.9.5"


DOCKER_HUB_NAME="dockerhubimagerepository"
DOCKER_REPO="netflixoss/eureka netflixoss/zuul owasp/zap2docker-stable webgoat/webgoat-8.0 nparkskenzan/hellokenzan"
DOCKER_ADDR="index.docker.io"

OMIT_NAMESPACES="$JENKINSNS,istio-system,kube-system,spinnaker"
# we are assuming that glcoud credentials where added properly
KUBECONFIG=".kube/config"
