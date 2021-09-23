# 🚵🏻‍♀️ Managed Kubernetes Service - AWS
FUN FACT: Did you know that half of all Kubernetes that are running are all managed by AWS.

To learn:
- Container Services on AWS
- Create K8s cluster with UI.
- Configure Autoscaling to reduce the costs.
- Create EKS cluster with eksctl ( CLI ).
- Build Pipeline to deploy EKS cluster (Continuous Deployment)

# 🚵🏻‍♀️ Container Services on AWS
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

## 🚵🏻‍♀️ **ECS+Fargate**
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

## 🚵🏻‍♀️ EKS + AWS
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


# 🚵🏻‍♀️Create EKS Cluster manually - User Interface of AWS - Nodegroup
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

EKS doesn't automatically scale resources for us. It needs to be configured first!
There is a tool in Kuberentes called: Autoscaler

Autoscaler: 
S: If underutilized, the pods that are on a instance, will be moved onto another instance so it won't incur some costs.
S: If over utilized, it will get the config from Autoscaling group to see what's maximum size, then create if its possible.

1. Need Autoscaling group which we already have.
2. Create custom policy and attach to node group IAM role.
custom-policy.json contents:::::
//start//

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}


//end//
Name that as: node-group-autoscale-policy
Then attached this policy to nodegroup IAM role. (eks-node-group-role )
3. Deploy K8s Autoscaler.
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml

TO debug: kubectl delete -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml

Change the: <YOUR CLUSTER NAME> to your cluster name // or is it?

kubectl get deployment -n kube-system cluster-autoscaler

kubectl edit deployment -n kube-system cluster-autoscaler
then edit on annotations:
> cluster-autoscaler.kubernetes.io/safe-to-evict: "false"
> <YOUR CLUSTER NAME> to your cluster name
> - --balance-similar-node-groups
> - --skip-nodes-with-system-pods=false
> change to autoscaler version to kubernetes version: 1.18.3


kubectl get pods -n kube-system
Output:
aws-node-ls7hn                        1/1     Running   0          3m41s
aws-node-vsq8c                        1/1     Running   1          3m52s
cluster-autoscaler-5b94df99b9-jhk64   1/1     Running   0          21s
coredns-c79dcb98c-vhv62               1/1     Running   0          6m55s
coredns-c79dcb98c-x2ccm               1/1     Running   0          6m55s
kube-proxy-fwtsm                      1/1     Running   0          3m52s
kube-proxy-s7pkn                      1/1     Running   0          3m41s

kubectl get pod cluster-autoscaler-5b94df99b9-jhk64 -n kube-system -o wide
kubectl logs cluster-autoscaler-5b94df99b9-jhk64 -n kube-system
kubectl get nodes

# provisioning new instance can be slow.
```
### H. Deploy our application to our EKS cluster.
```
Deploy nginx application and LoadBalancer

nginx-config.yaml contents:
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx
  type: LoadBalancer
```
We are creating a service which of type Loadbalancer. We are creating an external service, where there is an AWS loadbalancer attached to it. Kubernetes will create cloud native load balancer. So we can access the cluster on loadbalancer endpoint.

```
kubectl apply -f nginx-config.yaml
kubectl get pods
kubectl get service
You will also see on your EC2 console that a LB was automatically created.
```
DNS Name, is the endpoint where it is accessible:
(e.g. a35c4a2620f3e443c9a716dac211f162-901558892.us-east-1.elb.amazonaws.com (A Record)
![](https://i.imgur.com/42ZDlL6.png)

```
Interesting:

nginx        LoadBalancer   10.100.106.19   a35c4a2620f3e443c9a716dac211f162-901558892.us-east-1.elb.amazonaws.com   80:31821/TCP   46m

Here you can see 80:31821
80 - port of the service
31821 - nodeport of the service, port that opens on the ec2 node itself.
```
![](https://i.imgur.com/6WQ504Z.png)
![](https://i.imgur.com/aopyBLF.png)
**Load Balances**, will be scheduled on the public subnet
Instances run on at least 2 availability zones.

**Increasing the replicas**
```
kubectl edit deployment nginx
Then scale up to replicas from 1 to 20.

kubectl get pod

I tried scaling it to 80 replicas.
kubectl logs cluster-autoscaler-5b94df99b9-sp27t -n kube-system -f
```


# 🚵🏻‍♀️Create EKS Cluster manually - User Interface of AWS - Fargate

**serverless,** no ec2 instances in our AWS account.
**1 pod per virtual machine**
- Fargate has no support for stateful applications yet.
- Fargate has no support for DaemonSets.

### A. Create IAM role for fargate
```
Create role
EKS
EKS- Fargate Pod
Role name: eks-fargate-role
```
### B. Create Fargate profile
- pod selection rule
- specificies which Pods should use Fargate when they launched
- lets us define criteria how pod is scheduled.
```
name: dev-profile
add role : eks-fargate-role

Q: Why we need a VPC if there is nothing to be running there?
A: Pods will have an IP address from our subnet IP range.

- Important! Remove the public subnet and leave only private.

 Add nginx-config.yaml inside of it, namespace which is dev
Also add some Match labels

nginx-config.yaml contents:

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: dev
spec:
  selector:
    matchLabels:
      app: nginx
      profile: fargate
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
        profile: fargate
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx
  type: LoadBalancer


Then on AWS:
Key: profile
Value: fargate

Namespaces and configuring labels, will match our pods, if it will gonna provision 
via Fargate or nah.
```
Use cases of Fargate and Nodegroup

![](https://i.imgur.com/Xw5f1Wi.png)
![](https://i.imgur.com/Xw5f1Wi.png)
### C. Deploy Pod through Fargate
```
kubectl create ns dev
kubectl apply -f nginx-config.yaml
kubectl get pod -n dev
kubectl get nodes
kubectl get pod -n dev -o wide
```
You can create many fargate profile.

### Clean Up
```
remove nodegroup
remove fargate profile
delete the cluster
delete cloudformation stack too: Delete eks-worker-node-vpc-stack?
optional ( delete the roles )
```

# 🚵🏻‍♀️Create EKS Cluster with eksctl
What we've done before, is hard to replicate.
- **eksctl, eks control for automating creation of cluster.**
- Remember that clusters will be created with **default** parameters
### Install eksctl on your machine
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```
### Add credentials to eksctl
```
aws configure
aws configure list
```
### Create eks cluster
eksctl.io
 ```
 eksctl create cluster \
 --name demo-cluster \
 --version 1.17 \
 --region us-east-1 \
--zones us-east-1a,us-east-1b \
 --nodegroup-name demo-nodes \
 --node-type m5.large \
 --nodes 2 \
 --nodes-min 2 \
 --nodes-max 2 
 ```
 Here, you can also pass your ssh keys. Also you can create your own config file:
 then apply: https://eksctl.io/usage/creating-and-managing-clusters/
 
`eksctl create cluster -f cluster.yaml`

 ```
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: demo-cluster
  region: us-east-1

nodeGroups:
  - name: ng-1
    instanceType: m5.large
    desiredCapacity: 2
    volumeSize: 20
    ssh:
      allow: false # will use ~/.ssh/id_rsa.pub as the default ssh key
 ```

After running the command `kubectl` will be configured right away since .kube/config is already configured.

```
kubectl get pod
kubectl get nodes
```

### Explore AWS Account
```
1. You will see that roles are created.
2. You will see a VPC is also created.
```

TO DELETE:
eksctl delete cluster --region=us-east-1 --name=demo-cluster
# 🚵🏻‍♀️ Deploy to EKS Cluster from Jenkins Pipeline
Here we are going to deploy from Jenkins Pipeline

Perform this inside the jenkins container.
1. Install jenkins as a container 
```
docker run -p 8080:8080 -p 5000:5000 -d \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $(which docker):/usr/bin/docker \
jenkins/jenkins:lts
```
2. Install kubectl CMD inside Jenkins container.
```
docker exec -it u 0 <id> bash

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

chmod +x kubectl
mkdir -p ~/.local/bin/kubectl
mv ./kubectl ~/.local/bin/kubectl

kubectl version --client



```
3. Install aws-iam-authenticator tool inside Jenkins container.
-- Already installed eksctl
```
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/`amd64`/aws-iam-authenticator
chmod +x ./aws-iam-authenticator

Correct version:
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator


mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
aws-iam-authenticator help

mv ./aws-iam-authenticator /usr/local/bin
```
4. Create kubeconfig file to connect to EKS cluster.
```
aws eks update-kubeconfig --name demo-cluster

We need to update:

-
1. k8s cluster name
2. Server endpoiny 
3. CA data certificate authority data

Then insider on our jenkins container

cd ~
pwd
mkdir .kube
exit the container

Copy the config in .kube/config
docker cp config <containerid>:var/jenkins_home/.kube/

Then insider on our jenkins container with jenkins user


======
aws eks update-kubeconfig --name eks-cluster-test
```
8. Add AWS credentials on Jenkins for AWS account authentication.
```
---

1.Best practice is to create an AWS IAM user for Jenkins
9. Create credentials inside Jenkins (multibranch pipeline)
- jenkins-aws_access_key_id
- jenkins-aws_secret_access_key
 
```
10. Adjust Jenkinsfile to configure EKS cluster deployment.
- Configure Jenkinsfile to deploy on EKS
```
A. kubectl command
B. kubeconfig file
C. aws-iam-authenticator is configured in config file
D. aws credentials is used. 
```

`Jenkinsfile`
```
#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage('build app') {
            steps {
               script {
                   echo "building the application..."
               }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                }
            }
        }
        stage('deploy') {
            environment {
               AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
               AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
            }
            steps {
                script {
                   echo 'deploying docker image...'
                   sh 'kubectl create deployment nginx-deployment --image=nginx'
                }
            }
        }
    }
}

```
11. Execute Jenkins Pipeline

```
kubectl get pod
```

So what happened here, instead of your deploying it into EC2 instances, you deploy it via Kubernetes Cluster.

# Credentials in Jenkins
- You can have EC2 credentials here, so in case you need it for deployment
- You can have K8s credentials here, so in case you need it for deployment.

# Complete CI/CD Pipeline with EKS and DockerHub 
# Complete CI/CD Pipeline with EKS and ECR 
