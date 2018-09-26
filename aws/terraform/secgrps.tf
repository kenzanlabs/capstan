#
#
#


#### Cluster
resource "aws_security_group" "cluster" {
  name        = "${var.gen_solution_name}-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.containernet.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.gen_solution_name}"
  }
}

resource "aws_security_group_rule" "cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.cluster.id}"
  source_security_group_id = "${aws_security_group.worker-node.id}"
  to_port                  = 443
  type                     = "ingress"
}


resource "aws_security_group_rule" "cluster-ingress-tools-https" {
  description              = "Allow bastion to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.cluster.id}"
  source_security_group_id = "${aws_security_group.bastion.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.cluster.id}"
  to_port           = 443
  type              = "ingress"
}

#### Worker 
resource "aws_security_group" "worker-node" {
  name        = "${var.gen_solution_name}-worker-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.containernet.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "${var.gen_solution_name}-worker-node",
     "kubernetes.io/cluster/${var.gen_solution_name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "worker-node-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.worker-node.id}"
  source_security_group_id = "${aws_security_group.worker-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.worker-node.id}"
  source_security_group_id = "${aws_security_group.cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}


###### Bastion/Tunnel/Tools instance


resource "aws_security_group" "bastion" {
  name        = "${var.gen_solution_name}-tools"
  description = "Security group for the tools-tunnel-bastion"
  vpc_id      = "${aws_vpc.containernet.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "${var.gen_solution_name}-tools",
     "Usage", "kubernetes.io/cluster/${var.gen_solution_name}",
    )
  }"
}


resource "aws_security_group_rule" "tools-ingress-workstation-https" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allow workstation to ssh into bastion"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion.id}"
  to_port           = 22
  type              = "ingress"
}