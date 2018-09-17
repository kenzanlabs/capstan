#
# tools instance to run bash/ansible
#

##### We need the kubeconf file


resource "local_file" "kubeconf" {
    content     = "${local.kubeconfig}"
    filename = "generated-kube.conf"
}

#####
