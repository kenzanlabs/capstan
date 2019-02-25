

############################################  Spinnaker

SPINNAKER_VERSION="1.12.3"


DOCKER_HUB_NAME="dockerhubimagerepository"
DOCKER_REPO="netflixoss/eureka netflixoss/zuul owasp/zap2docker-stable webgoat/webgoat-8.0 nparkskenzan/hellokenzan"
DOCKER_ADDR="index.docker.io"

OMIT_NAMESPACES="istio-system,kube-system,spinnaker"
# we are assuming that glcoud credentials where added properly
KUBECONFIG=".kube/config"
