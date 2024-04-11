## VPC
resource "aws_vpc" "infrastructure" {
  name = var.VPC_NAME
  description = "Creating the main VPC"
  cidr_block = var.VPC_CIDR
}

## Internet Gateway
resource "aws_internet_gateway" "gateway" {
  name = var.IGW_NAME
  description = "Creating the Internet Gateway"
  vpc_id = aws_vpc.var.IGW_NAME.id
}

## Subnets
resource "aws_subnet" "subnet1" {
  name = var.SN_NAME
  description = "Creating subnet"
  vpc_id            = aws_vpc.var.VPC_NAME.id
  cidr_block        = var.SN_CIDR
  availability_zone = var.SN_AZ

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

## NAT
resource "aws_eip" "nat" {
  name = var.NAT_NAME
  description = "Creating NAT"
  vpc = true
  
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.var.NAT_NAME.id
  subnet_id     = aws_subnet.var.SN_NAME.id
  depends_on = [aws_internet_gateway.var.IGW_NAME]
}


## EKS
resource "aws_iam_role" "cluster" {
  name = var.EKS_ROLE
  description = "Creating the EKS for deplyment"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo_amazon_eks_cluster_policy" {
  name = var.CLUSTER_POLICY
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.var.EKS_ROLE
}

resource "aws_eks_cluster" "demo" {
  name     = var.EKS_NAME
  description = "Creation of EKS cluster"
  version  = "1.24"
  role_arn = aws_iam_role.var.EKS_NAME.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.var.SN_NAME.id,
    ]
  }

  depends_on = [var.IAM_POLICY.var.EKS_NAME]
}

## IAM
data "tls_certificate" "eks" {
  url = var.TLS_URL
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = var.CL_LIST_EKS
  thumbprint_list = var.TP_LIST_EKS
  url             = var.TLS_URL
}
