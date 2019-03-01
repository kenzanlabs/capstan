#
#
#


#### Cluster Definitions
resource "aws_eks_cluster" "eks" {
  name     = "${var.gen_solution_name}"
  role_arn = "${aws_iam_role.cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.cluster.id}"]
    subnet_ids         = ["${aws_subnet.sbnet.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy",
  ]
}


#### Cluster Worker

resource "aws_iam_instance_profile" "instprofile" {
  name = "${aws_iam_role.worker-role.name}"
  role = "${aws_iam_role.worker-role.name}"
}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

#
locals {
  demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority.0.data}' '${var.gen_solution_name}'
USERDATA
}

resource "aws_launch_configuration" "alc" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.instprofile.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  #image_id = "ami-0a54c984b9f908c81"
  instance_type               = "${var.eks_instance_size}"
  name_prefix                 = "${var.gen_solution_name}"
  security_groups             = ["${aws_security_group.worker-node.id}"]
  user_data_base64            = "${base64encode(local.demo-node-userdata)}"
  key_name ="${var.ec2_key}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker-asg" {
  desired_capacity     = 3
  launch_configuration = "${aws_launch_configuration.alc.id}"
  max_size             = 10
  min_size             = 1
  name                 = "${var.gen_solution_name}"
  vpc_zone_identifier  = ["${aws_subnet.sbnet.*.id}"]

  tag {
    key                 = "Name"
    value               = "${var.gen_solution_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.gen_solution_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}


####### Usefull data

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.worker-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${aws_iam_role.capstain-user-role.arn}
      username: capstan-user
      groups:
        - system:masters
    - rolearn: ${aws_iam_role.bastion-role.arn}
      username: capstan-bastion
      groups:
        - system:masters
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority.0.data}
  name: cd-kubernetes
contexts:
- context:
    cluster: cd-kubernetes
    user: aws
  name: aws-cd-management
current-context: aws-cd-management
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.eks.name}"

KUBECONFIG
}
