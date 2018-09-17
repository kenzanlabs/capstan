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
  name = "${var.gen_solution_name}"
  role = "${aws_iam_role.worker-role.name}"
}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["eks-worker-*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/amazon-eks-nodegroup.yaml
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
  instance_type               = "${var.eks_instance_size}"
  name_prefix                 = "${var.gen_solution_name}"
  security_groups             = ["${aws_security_group.worker-node.id}"]
  user_data_base64            = "${base64encode(local.demo-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker-asg" {
  desired_capacity     = 2
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
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
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
        - "r"
        - "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
KUBECONFIG
}
