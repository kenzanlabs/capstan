#
#
# Network


resource "aws_vpc" "containernet" {
  cidr_block = "${var.net_cidrblock}"

  tags = "${
    map(
     "Name", "${var.net_name}",
     "kubernetes.io/cluster/${var.gen_solution_name}", "shared",
    )
  }"
}

## Public network resources

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.containernet.id}"

  tags {
    Name = "${var.net_name}"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.containernet.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }
}



resource "aws_subnet" "public_sbnet" {
  count = "${var.net_numsaz}"

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${element(var.publicnet_subnetcidrblock, count.index)}"
  vpc_id            = "${aws_vpc.containernet.id}"

  tags = "${
    map(
     "Name", "${var.gen_solution_name}-publicsb-${count.index}",
     "kubernetes.io/cluster/${var.gen_solution_name}", "shared",
    )
  }"
}


resource "aws_route_table_association" "public_rta" {
  count = "${var.net_numsaz}"

  subnet_id      = "${aws_subnet.public_sbnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

## Private network resources

#resource "aws_network_interface" "netif" {
#  subnet_id      = "${aws_subnet.public_sbnet.*.id[0]}"
#  depends_on     = ["aws_subnet.public_sbnet"]
#}


resource "aws_eip" "nat" {
  vpc                       = true
#  network_interface         = "${aws_network_interface.netif.id}"
}


resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_sbnet.*.id[0]}"

  tags {
    Name = "capstan nat gateway"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.containernet.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw.id}"
  }
}



resource "aws_subnet" "private_sbnet" {
  count = "${var.net_numsaz}"

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${element(var.privatenet_subnetcidrblock, count.index)}"
  vpc_id            = "${aws_vpc.containernet.id}"

  tags = "${
    map(
     "Name", "${var.gen_solution_name}-privatesb-${count.index}",
     "kubernetes.io/cluster/${var.gen_solution_name}", "shared",
    )
  }"
}


resource "aws_route_table_association" "private_rta" {
  count = "${var.net_numsaz}"

  subnet_id      = "${aws_subnet.private_sbnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.private_rt.id}"
}

