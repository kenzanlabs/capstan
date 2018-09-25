#
# tools instance to run bash/ansible
#

##### We need the kubeconf an authenticator yaml file

resource "local_file" "configmap" {
    content     = "${local.config_map_aws_auth}"
    filename = "generated-configmap.yaml"
}

resource "local_file" "kubeconf" {
    content     = "${local.kubeconfig}"
    filename = "generated-kube.conf"
}

#####
