#!/usr/bin/env bash

##########################
# Set-up the GCP Instance
##########################
###

echo "******************************************"
echo "=========================================="
echo " - Starting CD Environment Creation Process -"
echo "=========================================="

# From Gist: https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

sudo apt-get update

PROJECT_NAME=$(gcloud info --format='value(config.project)')

echo ">>>> Get Kubectl"
### We need to get kubectl instead of having gloud install it for us
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


echo ">>>> Get Halyard"
#### get halyard
curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/stable/InstallHalyard.sh
sudo bash InstallHalyard.sh -y

hal -v

echo ">>>> Get Helm"
HELM_VERSION=$( get_latest_release "kubernetes/helm" )
curl -LO https://kubernetes-helm.storage.googleapis.com/helm-$HELM_VERSION-linux-amd64.tar.gz
tar -xzf helm-$HELM_VERSION-linux-amd64.tar.gz # Faster to not print the filenames when extracting.
chmod +x linux-amd64/helm
sudo mv linux-amd64/helm /usr/local/bin/helm



echo ">>>> Get git and other good stuffs"
### get git
sudo apt-get install git golang-go -y

echo ">>>> Get Roer"
ROER_VERSION=$( get_latest_release "spinnaker/roer" )
curl -LO https://github.com/spinnaker/roer/releases/download/$ROER_VERSION/roer-linux-amd64
chmod a+x roer-linux-amd64
sudo mv roer-linux-amd64 /usr/local/bin/roer

echo ">>>> Add the SPINNAKER_API environ"
echo -e "\nexport SPINNAKER_API=http://127.0.0.1:8084\n" >> ~/.profile

#### We need expect also
#sudo apt-get install expect -y

echo ">>>> Get Docker"
#### this is not a version you would want to use but it will get the job done
sudo apt-get install -y docker.io

echo $PWD
echo "=========================================="
echo " - Configuration Set-up Complete -"
echo "=========================================="
echo "******************************************"
