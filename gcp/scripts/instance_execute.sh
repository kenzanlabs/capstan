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
#echo $PATH
#PATH="$PATH:/snap/bin"
PROJECT_NAME=$(gcloud info --format='value(config.project)')
echo $PATH


echo ">>>> Get Kubectl"
### We need to get kubectl instead of having gloud install it for us
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


echo ">>>> Get Halyard"
#### get halyard
curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh
sudo bash InstallHalyard.sh -y

hal -v
hal --ready

echo ">>>> Get Helm"
HELM_VERSION=$( get_latest_release "helm/helm" )
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

echo ">>>>> get spin"
curl -LO https://storage.googleapis.com/spinnaker-artifacts/spin/$(curl -s https://storage.googleapis.com/spinnaker-artifacts/spin/latest)/linux/amd64/spin
chmod +x spin
sudo mv spin /usr/local/bin/spin
mkdir ~/.spin
touch ~/.spin/config

echo $PWD
echo "=========================================="
echo " - Configuration Set-up Complete -"
echo "=========================================="
echo "******************************************"
