terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.4.2"
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "nomedoseubucket"
    key     = "terraformeks.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "vpc" {
  source                 = "./vpc"
  cluster_name           = var.cluster_name
  environment            = var.environment
  cidr_block             = var.cidr_vpc
  number_private_subnets = var.number_private_subnets
  number_public_subnets  = var.number_publics_subnets
}

module "iam" {
  source = "./iam"
}

module "eks_cluster" {
  source                    = "./eks_cluster"
  cluster_name              = var.cluster_name
  iam_role_arn              = module.iam.iam_role_arn
  iam_role_policy_attach    = module.iam.iam_role_policy_attach
  public_subnets_ids        = module.vpc.number_public_subnets_ids
  private_subnets_ids       = module.vpc.number_private_subnets_ids
  iam_node_arn              = module.iam.iam_role_arn_node
  eks_policy_attach_workers = module.iam.eks_policy_attach_workers
  eks_policy_attach_cni     = module.iam.eks_policy_attach_cni
  eks_policy_attach_ec2     = module.iam.eks_policy_attach_ec2
}
