# Introduction to Elastic Search and Kibana

According to stackshare.io
**Elasticsearch vs Kibana: What are the differences?**

**What is Elasticsearch?**  _Open Source, Distributed, RESTful Search Engine_. Elasticsearch is a distributed, RESTful search and analytics engine capable of storing data and searching it in near real time. Elasticsearch, Kibana, Beats and Logstash are the Elastic Stack (sometimes called the ELK Stack).

**What is Kibana?**  _Explore & Visualize Your Data_. Kibana is an open source (Apache Licensed), browser based analytics and search dashboard for Elasticsearch. Kibana is a snap to setup and start using. Kibana strives to be easy to get started with, while also being flexible and powerful, just like Elasticsearch.

Elasticsearch and Kibana are primarily classified as  **"Search as a Service"**  and  **"Monitoring"**  tools respectively.

Some of the features offered by Elasticsearch are:

-   Distributed and Highly Available Search Engine.
-   Multi Tenant with Multi Types.
-   Various set of APIs including RESTful

On the other hand, Kibana provides the following key features:

-   Flexible analytics and visualization platform
-   Real-time summary and charting of streaming data
-   Intuitive interface for a variety of users

**"Powerful api"**  is the primary reason why developers consider Elasticsearch over the competitors, whereas  **"Easy to setup"**  was stated as the key factor in picking Kibana.

Elasticsearch and Kibana are both open source tools. Elasticsearch with  **42.4K**  GitHub stars and  **14.2K**  forks on GitHub appears to be more popular than Kibana with  **12.4K**  GitHub stars and  **4.81K**  GitHub forks.




## Use Cases:


1. **Logging**, used to analyze data like logs for example ping, etc. ( e.g. game servers )
2. **Metrics**, mars rover, telemetry sensor, temperature
3. **Security Analytics**
4. **Business Analytics**, tinder to find match. 
- ELK is free

## Parts
- **ElasticSearch** is the heart, this is where you store and extract your data. Much like a database.

Use case: Retrieving data on large datasets. It can slow down the search. 

- Each node has a name and unique id, and belong to a single cluster. This unique architecture enables a node to be duplicated into a single cluster from single machine that accomplishes a same task.
- Nodes are member of the same cluster with the same goal.
- Even though nodes are on separate machines they are on the same cluster. 
- One of the roles that can be assign to all nodes is to hold data.

- **Kibana,** is like the web interface. Here you can create dashboards too. 

What is Sharding?
- Shard is where are the documents are stored. Like a fragment so to speak.
- What if you need more data to be stored? That's where shard are useful since you can just provision another node to your own cluster.

**Use CASE:** Suppose that you want to search for a string from a single shard which contains 500k data. It can take 10 seconds for that nodes with all that document in that shard to finish reading the data. BUT you can distribute the search request on 10 nodes, for which data are separated into shards like 50k each nodes. Meaning that running a search can only take 1 SEC! Parallel Execution!

What are replica shards?

USE CASE: Is if one node is down, we got replica P0 -> R0 . That's why it is important too to create replicas to maximize data availability and accessibility. 

USE CASE: Also Replica shards can also be served as a data source to mitigate traffic amount. 

# Hands On Lab: Performing CRUD Operations with ElasticSearch and Kibana

Goal: perform crud on ELK
https://www.youtube.com/watch?v=gS_nHTWZEJ8

to be continued....




# 👽 👽👽👽👽👽Deploy ElasticSearch, Kibana and FluentD on Kubernetes Cluster👽👽👽👽👽

- ensure that alerting are working
- lens ide: https://k8slens.dev/ this is a kubernetes ide
- Elastic.co
- Deploy it using helm charts
- https://artifacthub.io/
- Nodegroup via aws eks


## Step 1.  Provision an EKS Cluster using Terraform
```
Make sure that AWS Credentials are configured on your website.
Make sure kubectl is installed.
```
### Step 1.1 Create a VPC. 
Create: `terraform.tfvars`
```
vpc_cidr_block = "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet_cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
```
Create: `vpc.tf`
```
provider "aws" {
  region = "us-east-1"
}

# variable definitions
variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}


#data definition
# querying data

data "aws_availability_zones" "azs" {}


module "myapp-vpc" {
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
  azs = data.aws_availability_zones.azs.names

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
 public_subnet_tags = {
 "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
 "kubernetes.io/role/elb" = 1 
 }

  # tagging private subnets
  private_subnet_tags = {
 "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
 "kubernetes.io/role/internal-elb" = 1 
 }
}
```
Perform this steps:
```
terraform init
terraform plan
# don't apply yet terraform apply --auto-approve // terraform destroy
```
Here we have created:
```
On plan you can see: ( we already created the vpc )

Elastic IP address
Internet Gateway
NAT Gateway
RTB
Private and Public Subnet
```
### Step 1.2 Provision an EKS-Cluster on that VPC.
Create: `eks-cluster.tf`
```
# defining kubernetes provider
# this is important so that Terraform can access the cluster on the creds that are defined.
provider "kubernetes" {
  # load_config_file = "false"
  # enpoint of K8s cluster
  host = data.aws_eks_cluster.myapp-cluster.endpoint
  token = data.aws_eks_cluster_auth.myapp-cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}



# ---------- Defining Data -------------#
data "aws_eks_cluster" "myapp-cluster" {
  name =  module.eks.cluster_id
}

data "aws_eks_cluster_auth" "myapp-cluster" {
  name = module.eks.cluster_id
}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.20.0"
  # insert the 7 required variables here

  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.17"

  # provide a vpc id
  vpc_id = module.myapp-vpc.vpc_id

  # list of subnets we want worker node to start in
  # Private: workload to be scheduled
  # Public: Loadbalancer, etc.
  # reference an attribute created by module
  # this is where worker nodes where run:
  subnets = module.myapp-vpc.private_subnets

  tags = {
    environment = "development"
    application = "myapp"
  }

  # worker nodes: we can have:
  # we can have self managed (ec2), semi managed (node group) and managed (fargate)

  # defining worker groups
  # these are self managed
  worker_groups = [
      {
        instance_type =  "m5.large"
        name = "worker-group-1"
        asg_desired_capacity = 3
      }

  ]
}
```
Perform this steps:
```
terraform init
tree .terraform
terraform plan
terraform apply --auto-approve
```

## Step 2. Connect to the EKS Cluster using Kubectl
Perform this:
```
aws eks update-kubeconfig --name myapp-eks-cluster --region us-east-1
kubectl get node
kubectl get pod
kubectl cluster-info
kubectl cluster-info dump
```


## Step 3. Install things / dependencies via HELM Charts
```
Make sure helm is installed
```
Deploy Elasticsearch with Helm
```
helm repo add elastic https://helm.elastic.co
curl -O https://raw.githubusercontent.com/elastic/helm-charts/master/elasticsearch/examples/minikube/values.yaml
kubectl get pods --namespace=default -l app=elasticsearch-master -w
```
## Step 4. 


Status: There is a problem on route table on Terraform
