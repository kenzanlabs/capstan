#!/usr/bin/env bash

#### Setup instance ####

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

echo ">>>> Get Kubectl"
### We need to get kubectl from AMAZON for the time being
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

mkdir .kube
cp generated-kube.conf ~/.kube/config




echo ">>>> Get Halyard"
#### get halyard
curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/stable/InstallHalyard.sh
sudo bash InstallHalyard.sh -y

hal -v

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

echo ">>>>> Get AWS Authenticator"
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator
chmod +x aws-iam-authenticator
sudo mv aws-iam-authenticator /usr/local/bin/aws-iam-authenticator


echo $PWD
echo "=========================================="
echo " - Configuration Set-up Complete -"
echo "=========================================="
echo "******************************************"