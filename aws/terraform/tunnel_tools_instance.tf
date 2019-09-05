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

resource "null_resource" "kubeconfigmap" {
  provisioner "local-exec" {
    command = "curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/darwin/amd64/kubectl"   
  }

    provisioner "local-exec" {
    command = "chmod +x kubectl"   
  }


#sleep to give extra time for EKS to actually be awake (angry face)
    provisioner "local-exec" {
    command = "sleep 60"   
  }

      provisioner "local-exec" {
    command = "./kubectl --kubeconfig=${local_file.kubeconf.filename} apply -f ${local_file.configmap.filename}"   
  }
}

#####

resource "aws_instance" "bastion" {
  ami           = "${var.ec2_ami_id}"
  instance_type = "t2.large"
  key_name = "${var.ec2_key}"
  vpc_security_group_ids =["${aws_security_group.bastion.id}"]
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.public_sbnet.*.id[0]}"
  iam_instance_profile ="${aws_iam_instance_profile.bastion-instance-profile.name}"

    depends_on = [
    "aws_autoscaling_group.worker-asg",
    "null_resource.kubeconfigmap"
  ]

 connection {
    user        = "${var.ec2_ssh_user}"
    private_key = "${file(var.ec2_key_file)}"
    agent       = false
  }

  provisioner "file" {
    source      = "${local_file.kubeconf.filename}"
    destination = "/home/${var.ec2_ssh_user}/${local_file.kubeconf.filename}"
  }

  provisioner "file" {
    source      = "${local_file.configmap.filename}"
    destination = "/home/${var.ec2_ssh_user}/${local_file.configmap.filename}"
  }

    provisioner "file" {
    source      = "../scripts/"
    destination = "/home/${var.ec2_ssh_user}"
  }

  provisioner "file" {
    source      = "../../pipelines"
    destination = "/home/${var.ec2_ssh_user}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ec2_ssh_user}/*.sh",
      "/home/${var.ec2_ssh_user}/instance_setup.sh",
      "/home/${var.ec2_ssh_user}/01_pltreq_helm.sh",
      "/home/${var.ec2_ssh_user}/02_pltreq_efk.sh ${var.efk_loggingnamespace} ",
      #"/home/${var.ec2_ssh_user}/02_pltopt_istio.sh",
      "/home/${var.ec2_ssh_user}/01_spin_k8.sh ${aws_eks_cluster.eks.name} ${var.spinnaker_version} ${var.dockerhub_address} ${var.spinnaker_dockerhubname} ${var.spinnaker_omitnamespace_list},${var.efk_loggingnamespace}",
      "/home/${var.ec2_ssh_user}/02_spin_storage.sh ${aws_s3_bucket.spin_bucket.id} role/${aws_iam_role.spin-role.id}",
      "/home/${var.ec2_ssh_user}/03_spin_artifact.sh ${aws_eks_cluster.eks.name}",
      "/home/${var.ec2_ssh_user}/10_spin_deploy.sh",
    #  "/home/${var.ec2_ssh_user}/03_pltreq_kube2iam.sh",
    #  "/home/${var.ec2_ssh_user}/04_pltreq_albingress.sh ${aws_eks_cluster.eks.name} ${aws_iam_role.alb-role.arn}",
    ]
  }


    tags = "${
    map(
     "Name", "${var.gen_solution_name}-tools",
     "Usage", "kubernetes.io/cluster/${var.gen_solution_name}",
    )
  }"

  
  
}
