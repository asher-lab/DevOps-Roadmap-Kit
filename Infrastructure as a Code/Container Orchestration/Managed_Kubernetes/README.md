# Managed Kubernetes Service - AWS
FUN FACT: Did you know that half of all Kubernetes that are running are all managed by AWS.

To learn:
- Container Services on AWS
- Create K8s cluster with UI.
- Configure Autoscaling to reduce the costs.
- Create EKS cluster with eksctl ( CLI ).
- Build Pipeline to deploy EKS cluster (Continuous Deployment)

# Container Services on AWS
**Elastic Container Service vs Elastic Kubernetes Service** clusters
also 
**EC2 vs Fargate** workers
also
**ECR**

Different orchestration tools:
1. Docker Swarm
2. Kubernetes
3. Mesos
4. Nomad
5. ECS ( Amazon Elastic Container Service)

What is ECS?
- manage the containers
- run containerized application cluster on AWS
- contains all services necessary for managing individual containers.
- act a **control plane** in managing all your virtual containers. (e.g. Scheduling)

Which virtual machines these containers are running?
- EC2 instances are where it run. EC2 instance are all connected into an ECS cluster. Instead of it being fully independent like we did before when we managed it, it is now managed by ECS control plane.
- EC2 have docker runtime installed and ECS agents.
- ECS hosted on EC2 instances.
- Where you need to create, join and maintain EC2 instances. Also Docker runtimes and ECS Agent must be installed. **You need to take care of your server.** *You have full access to your server.* 

## **ECS+Fargate**
Alternative to EC2, managed by AWS. 
- Serverless way to launch containers.
- Provisions server on demand depends on the determined capacity needed.
- No need to provision and manage servers.
- easily scales without fixed resources.
- Pricing: How long containers run and resources it consuming.

For which you now have:
1. Infrastructure managed by AWS. = **Fargate**
2. Containers managed by AWS. = **ECS**

**Now you only worry to manage your application.**
If you want more flexibility, then use EC2. Especially if you need system services.

- Cloudwatch for monitoring
- ELB for loadbalancing
- IAM for Users and Permissions
- VPC for networking.

## EKS + AWS
**Amazon EKS**, managing  K8s cluster on AWS infrastructure. 
- More Helm charts.

**How does it work?**
1. You create a cluster. ( Will make a Master Nodes )
2. HA - replicate master nodes on all AZ. Including etcd.
3. Worker Nodes ( need to create own ec2 instances , aka **compute fleet** then connect it to EKS)
4. Need to have K8s Processes installed to communicate. In ECS, we need to have ECS Agent to communicate.

Types:
A. EKS with EC2 instances = self managed. You need to have processes installed here manually.
B. EKS with nodegroup = semi-managed.
- Creates and deletes EC2 instances for you, but you need to configure it. Best use this, easier and simpler. ( Autoscaling, needs to be done by you ).
- EKS with Fargate = full managed worker nodes + control plane.
- EKS with EC2 and Fargate can be used as well.


### Steps to create an EKS cluster.
1. Provision an EKS cluster. ( With master nodes )
2. Create Nodegroup of EC2 Instances ( Worker NOdes) e.g. 5000 virtual machines, a fleet of them. 
3. Connect Nodegroup to EKS cluster. ( Use Fargate as alternative)
4. Master and Worker connected!
5. Connect to the cluster via kubectl command.

### What is Amazon EC2
Elastic Container Registry, alternative to Nexus, or Docker Hub.
- Integrates well  with other AWS services.
- like when you push an image, then it will automatically download it.

Summary:
1. ECS
2. EKS
3. ECR = storing images 
![](https://i.imgur.com/Hb2KOos.png)


# Create EKS Cluster manually - User Interface of AWS
### A. Create EKS IAM role
Will give EKS permission on AWS.
```
1. Create role for EKS. Use EKS - CLuster.
2. Role name: EKS-cluster-role
3. Create Role.
```
### B. Create VPC for Worker Nodes
To know where worker nodes to run.
```
Q: Why we need to create a VPC?
A: Because EKS cluster need a special configuration for that VPC.
A: Default VPC not optimized for EKS cluster. Not on best practices.
A: Subnets are configure by NACLs. Firewall rules need to be configured, necessary for master nodes to communicate with worker nodes.
A: Configure public and private subnets
A: When you create LoadBalancer Service (Private Subnet) it will dynamically deploy a Elastic Load Balancer (Public Subnet)
A: Through IAM role you give K8s permissions to change VPC configurations.
A: E.g. giving Nodeport Service permissions to open port on worker node.

AWS has template when setting up the VPC.
A: AWS Cloudformation.
1. Create Stack
2. Prerequisite - Prepare template | Template is ready
3. Specify template | Add S3 url 
Here you can create an all public or all private subnet. Also can be a mixture of both.
4. get data here -> https://docs.aws.amazon.com/eks/latest/userguide/create-public-private-vpc.html
5.  If you need to edit / modify, then go, example is going to edit the range of your IP.
6. Stack name : eks-worker-node-vpc-stack
7. Create Stack and wait for like 10 minutes.
8. Go to output tab, and remember to get all those information. 
```
### C. Create EKS cluster ( master nodes )
Set of master nodes that are managed by AWS.
```
name: eks-cluster-test
k8s-v: 1.18
role: eks-cluster-role ( from role you have created )

Secret encryption = Is a KMS, use for encrypting Secrets. You can enable here.
1. Specify the right network.
2. Specify the right SG.
3. To access API Server can be: Public, Hybrid or Private. 
Public = can run kubectl from your desktop. worker and master nodes works publicly.
Private = accessible only within our VPC. worker and master nodes works privately.
Public and Private = You work remotely for kubectl, while worker and master nodes talk in Private.
4. Control Plane Logging = none
5. Create and wait for a few minutes like 30 minutes
```
### D. Connect kubectl with EKS cluster
Connect to your cluster via your smartphone or computer.
```
sudo apt  install awscli

aws configure list

# create config file locally
aws eks update-kubeconfig --name eks-cluster-test

cat .kube/config
clear

kubectl get nodes
kubectl get namespaces
kubectl cluster-info
```
### E. Create EC2 IAM role for Node group
Create worker nodes for EKS cluster. Create role to give permissions to call AWS API for EC2 service.
```
You can run them on NodeGroup or Fargate
Let's try to run NodeGroup aka EC2 instances

Kubelet on worker nodes ( ec2 instances ) need permission

1. Role for EC2 service
Add: AmazonEKSWorkerNodePolicy
Add: AmazonEC2ContainerRegistryReadOnly ( read only access to ECR ) , in order to pull images
Add: AmazonEKS_CNI_Policy (Container Network Interface ), so that pods can communicate with each other.
2. Name of Role: eks-node-group-role



```
### F. Create Node Group and attach to EKS cluster
Group of EC2 instances that will run as a worker node in the Kubernetes cluster. And attach it to EKS cluster. Now we have worker node attached to the master node.
```
Go to compute tab of EKS.
1. Add nodegroup to EKS.
2. Name: eks-node-group
3. Add the role.
4. Choose what EC2 instance. I select t3.micro
5. NodeGroup scaling config: Min: ( How many is the least running node ) Max: ( max running number of nodes ) Desired Size : ( wanted size ) 
6. Select Node Group : 2,2,2
7. Specify Network | Configure SSH Access to Nodes | Allow SSH remote access from ALL
8. kubectl get nodes
```
When creating EC2 instances, all needed packages, like containerd and kube proxy and kubectl are all installed automatically!

### G. Configure Auto Scaling
To match resource requirements
```
Save costs in your infrastructure. 
```
### H. Deploy our application to our EKS cluster.

























 
