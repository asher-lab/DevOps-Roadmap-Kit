provider "aws" {
  region = "us-east-1"
}

# variable definitions
variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}


#data definition
# querying data

data "aws_availabiliy_zones" "azs" {}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"
  # insert the 21 required variables here
  
  name = "myapp-vpc"
  # specify the cidr block
  cidr = var.vpc_cidr_block
  
  # specify the cidr block of the subnet

  /*  best practice
  1 private and 1 public subnet in each AZ
  */
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks

  #deploy subnets in all availability zones
  azs = data.aws_availabiliy_zones.azs.names

  enable_nat_gateway = true

  # all private subnets will route their internet traffic
  # through ths single NAT gateway
  single_nat_gateway = true

  # will assign public and private ip
  # will assing public and private dns names
  enable_dns_hostnames = true


  # use case for tags is to have more information for human consumption
  # use case for tags is also referencing 
  # kubernetes cloud controller manager needs to know what tags to look for
  # in kubernetes resources, so it makes use of tags
  # this helps control identifier to know what vpc should it connect to


  # tagging vpc
  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

  # tagging public subnets
  public_subnet_tags {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1 
  }

  # tagging private subnets
  private_subnet_tags {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1 
  }



}
