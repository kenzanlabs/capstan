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

resource "aws_instance" "bastion" {
  ami           = "${var.ec2_ami_id}"
  instance_type = "t2.large"
  key_name = "${var.ec2_key}"
  vpc_security_group_ids =["${aws_security_group.bastion.id}"]
  associate_public_ip_address = true
  provisioner "file" {
    source      = "${local_file.kubeconf.filename}"
    destination = "/home/${var.ec2_ssh_user}"
  }
  
}