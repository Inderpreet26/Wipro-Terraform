module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  name     = var.name
}

module "internet_gateway" {
  source = "./modules/internet-gateway"
  vpc_id = module.vpc.vpc_id
  name   = var.name
}

module "public_subnet" {
  source     = "./modules/public-subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.public_subnet_cidr
  az         = var.az
  name       = var.name
}

module "private_subnet" {
  source     = "./modules/private-subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.private_subnet_cidr
  az         = var.az
  name       = var.name
}

module "public_route_table" {
  source    = "./modules/public-route-table"
  vpc_id    = module.vpc.vpc_id
  igw_id    = module.internet_gateway.igw_id
  subnet_id = module.public_subnet.subnet_id
  name      = var.name
}

module "elastic_ip" {
  source = "./modules/elastic-ip"
  name   = var.name
}

module "nat_gateway" {
  source    = "./modules/nat-gateway"
  eip_id    = module.elastic_ip.eip_id
  subnet_id = module.public_subnet.subnet_id
  name      = var.name
}

module "private_route_table" {
  source         = "./modules/private-route-table"
  vpc_id         = module.vpc.vpc_id
  nat_gateway_id = module.nat_gateway.nat_gw_id
  subnet_id      = module.private_subnet.subnet_id
  name           = var.name
}

module "security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
  name   = var.name
}

module "ec2" {
  source        = "./modules/ec2"
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = module.public_subnet.subnet_id
  sg_id         = module.security_group.sg_id
  key_path      = var.key_path
  name          = var.name
}

module "eks_iam" {
  source = "./modules/eks-iam"
  name   = var.name
}

module "nodegroup_iam" {
  source = "./modules/nodegroup-iam"
  name   = var.name
}

module "eks_cluster" {
  source = "./modules/eks-cluster"

  name      = var.name
  role_arn  = module.eks_iam.role_arn

  subnet_ids = [
  module.public_subnet.subnet_id,
  module.private_subnet.subnet_id,
  module.private_subnet_2.subnet_id
]

  depends_on = [module.eks_iam]
}

module "eks_nodegroup" {
  source = "./modules/eks-nodegroup"

  name         = var.name
  cluster_name = module.eks_cluster.cluster_name
  role_arn     = module.nodegroup_iam.role_arn

  subnet_ids = [
    module.private_subnet.subnet_id
  ]
  depends_on = [module.eks_cluster]
}

module "private_subnet_2" {
  source     = "./modules/private-subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.private_subnet2_cidr
  az         = var.az2
  name       = var.name
}