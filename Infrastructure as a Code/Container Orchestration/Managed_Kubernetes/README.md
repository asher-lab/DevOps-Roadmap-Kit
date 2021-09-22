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
