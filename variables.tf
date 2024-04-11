## VPC
variable VPC_NAME {
    description = "Main VPC name"
    type = string
    default = "main_infra"
}

variable VPC_CIDR {
    description = "Main VPC CIDR block"
    type = string
    default = "10.0.0.0/16"
}

## INTERNET GATEWAY
variable IGW_NAME_NAME {
    description = "Internet Gateway name"
    type = string
    default = "gateway"
}

##SUBNET
variable SN_NAME {
    description = "Subnet name"
    type = string
    default = "subnet"
}

variable SN_CIDR {
    description = "Subnet CIDR block"
    type = string
    default = "10.0.0.0/19"
}

variable SN_AZ {
    description = "Subnet availability zone"
    type = string
    default = "us-east-1a"
}

##NAT
variable NAT_NAME {
    description = "Name for NAT"
    type = string
    default = "project-nat"
}

##EKS
variable EKS_ROLE {
    description = "Name for EKS"
    type = string
    default = "eks-cluster-demo"
}

variable EKS_NAME {
    description = "Name for EKS"
    type = string
    default = "cluster"
}

variable CLUSTER_POLICY {  
    description = "Name for IAM policy"
    type = string
    default = "demo_amazon_eks_cluster_policy"
}

##OpenID Providers
variable "TLS_URL" {
    description = "Url for TLS"
    type = string
    default = "aws_eks_cluster.demo.identity[0].oidc[0].issuer"
}

variable "TP_LIST_EKS" {
    description = "Thumbprint list of EKS"
    type = list
    default = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
}

variable "CL_LIST_EKS" {
    description = "Thumbprint list of EKS"
    type = list
    default = ["sts.amazonaws.com"]
}
