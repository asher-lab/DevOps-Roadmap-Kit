# Kubernetes
https://prakashkumar0301.medium.com/kubernetes-key-component-and-concept-68c18e21cb95

![](https://i.imgur.com/QtKZtm6.png)
Sample Kubernetes Architecture 1
<br><br>

![](https://kubernetes.io/images/kubernetes-horizontal-color.png)
![](https://www.researchgate.net/publication/330255698/figure/fig1/AS:713165860007940@1547043399726/Example-of-the-Kubernetes-federation-architecture-The-federation-application-program.png)
Sample Architecture 2

**Kubernetes** 
is  an opensource container orchestration tool.
1.  It helps us manage thousands of containerized applications.
2. It helps us to manage thousands of containers in different environments. (local, hybrid, cloud, vms, etc.) 

**Use Cases**
- The rise of microservices raise the usage of containers.(container technology).
- K8s is a way of managing thousands of containers.
- Instead of running VMs, K8s helps to reduce costs on EC2 instances, to better make use of the provisioned services. 
- K8s supports high availability, no downtime, because of certain features that can let you design a robust infrastructure.
- Scalability , you can scale up and down your resources, since you can replicate your nodes easily.

# 💎Main K8s components
## POD
- smallest unit of K8s
- abstraction over container ( Pod is an abstraction over container runtime like containerd):

![](https://i.imgur.com/Bpu7ENr.png)

- An app is running over a containerized environment.
- An app is running over ~~a containerized environment~~ a pod.
- Usually there is 1 application per pod. Check for best practice here; https://www.bmc.com/blogs/kubernetes-best-practices/
- **A pod is a collection of applications and volumes which share one ip address where each of the containerized application can share the same port space of that single IP: This also enable pod to connect with other pods because of the provided IP.**
![](https://kubernetesbootcamp.github.io/kubernetes-bootcamp/public/images/module_03_pods.svg)

## 🚧 Warning / Pitfalls
- When a pod dies, it will have a new IP uon recreation (ephemeral) 
- So a service is needed ( a permanent IP/address).
## Services and Ingress
- permanent address
- pods will communicate with each other via a service.
- An ingress works like a reverse proxy and much more way to route traffic to the nodes. ? Can it route traffic directly to pods too? Technically yes since when you access an app via node, you access them via the app port of the node's IP.
## ConfigMap and Secret
Back then:
1. If you wanna change a url, you need to rebuild it. (e.g. docker build)

- Configmap - is an external configuration of an application 
- If your URL changed, just edit the config map, no need to rebuild the application.
From:
```
DB_URL = mongo_db ---> DB_URL = mongodb_url_service
```
- Tokens and Secrets CAN be passed to the ConfigMap too, but that pose a risk, in that case, one needs to make use of a SECRET.
- SECRET is where all the credentials are stored, it can be integrated with third party tool. ( Example, integrating Kubernetes Secret to hashicorp vault, or any other credentials manager).
- It is used for storing secret data and base 64 encoded.
- You can pass variables there as properties file or as an environmental variable. 

## Volumes
![](https://www.learncloudnative.com/assets/posts/img/volumes-1.png)
Back then, if a pod restarts then all your data will be gone.
- To address this concern you need to attach a volume to your pod.
- The volume can be coming from your local zone or remote.
!!! Kubernetes doesn't help you manage data persistence, it is just there to help you set it up, your data persistence. That's why it offers configuration that'll get you started.

## Deployment and Stateful Set
= Creating a Blueprint

USE CASE:
```
When there is an expected or unexpected downtime -- it will jeopardize the business.
```
You can replicate a node, so that the services that isn't working will be redirect to the working node. 
- Of which a service can act as a **load balancer**, 
-  and a **permanent IP as well**. 
- In deployment you can scale up and down. <br>
<br>

To create a replica of a node, you need to define a blueprint of it. It is a concept in K8s called **Deployment**.


**Deployment** is an abstraction on top of replica  set -> pods.

![](https://i.imgur.com/Bpu7ENr.png)

- Deployment is best used for stateless applications. If a component failed (e.g. my-app) which is stateless, the users will be redirected to the working node. 
- **Stateful Set** - refers to applications which data are critical and should be access, stored and retrieve everytime it is need. If one of the db fails, then a statefuk set will handle the allocation of db from the stateless apps, ensuring that no data inconsistencies and can be scale up and down and be replicated and synchronized with each backup db. 

!!! However, working with DB via Stateful set is not easy. That's why:
### DBs are hosted outside of the Kubernetes Cluster and let stateless application run on the K8s server.   e.g. like: external databases

## Kubernetes Architecture
There are two (2) roles in K8s architecture = Master and Workers
 - Workers node do the actual work.
 - Master Nodes to the managing of the worker nodes.
 
 In **worker nodes**, there must be three processes needs to be installed.
 
 1. Container runtime. The containerization technology like containerd or cri o.
 2. Kubelet - interact with BOTH container runtime (containerd) and the pod. Responsible for starting the pod with the container under it.
 - It also assign necessary resources what the pod needs.
 3.  Kube Proxy - responsible for forwarding requests. In and Out of the cluser. Responsible for networking related content.

**Master Nodes** -  all performs management of the pods, scheduling pods, monitoring the health, also rescheduling and restarting the pods, also merging a new node on the existing nodes.
<br>
In **master nodes** , there must be four processes needs to be installed:

1.  API Server - act as a cluster gateway.
	- for gatekeeping, safekeeping and authentication of the cluster.
	
	- Requests -> API Server -> Validate requests -> other processes -> POD
A request can be pod recreation, reporting, etc.
2. Scheduler 
	-   it is a mechanism the JUST DECIDES where a new POD will be allocated.
	- As per Kubernetes.io The Kubernetes scheduler is **a control plane process which assigns Pods to Nodes**. The scheduler determines which Nodes are valid placements for each Pod in the scheduling queue according to constraints and available resources. The scheduler then ranks each valid Node and binds the Pod to a suitable Node.
	- Not to be confused with **KUBELET** who have the power to schedule a pod in every node.

3. Controller Manager - It detects cluster state changes so it can act  on it. *(e.g. spawning a new pod)
![](https://miro.medium.com/max/1200/0*r3DyRvMZJ_LUC9w4.png)
4. etcd= _as per learnk8s.io etcd_ is where _Kubernetes_ stores all of the information about a cluster's state; in fact, it's the only stateful part of the entire _Kubernetes_ control plane. It doesn't store db apps. Only K8s processes.
# Installing Minikube
https://phoenixnap.com/kb/install-minikube-on-ubuntu
**Minikube** is an open source tool that allows you to set up a single-node Kubernetes cluster on your local machine. The cluster is run inside a virtual machine and includes Docker, allowing you to run containers inside the node.
**Minikube** is just basically a one node kubernetes cluster to be able to test Kubernetes on your device. It can run master and w

**Kubectl** a way to create pods in the node, it is a Command Line tool for K8S cluster. 

- API Server is the entry points you can use to manipulate the nodes/cluster. It can be controlled via the User Interface, or an API or also using KUBECTL which is a command line tool. 
- KubeCTL is the best.
- KubeCT is not for minikube only but also on all clusters orchestration stuff.
```
chmod 666 /var/run/docker.sock
$ minikube start --driver=docker
$ kubectl config view
# get running nodes, in this case it is minikube
$ kubectl get nodes 
$ minikube status

# If you see output are client and server, it means that it is correctly installed.
$ kubectl version
$ kubectl get pod
$ kubectl get services

```
### Creating Deployment
```
kubectl create deployment nginx-depl --image=nginx
kubectl get deployment
kubectl get pod
```
### Replica Set = is the one manages the replicas of the pod. You will be working with the Deployment directly, because here you can configure the number of replicas of the pod, and other rest of the configuration.
``` 
kubectl get replicaset
```
Remember:
Anything below deployment is something that should be managed by Kubernetes.  (Deployment (you managed) -> ReplicaSet -> Pods ->Containers (are all handled by Kubernetes) )

Editing the deployment:
```
# Editing deployment
KUBE_EDITOR="nano" kubectl edit deployment  nginx-depl

# then make some changes in the file
# you will notice that this one automatically update and observe what are the changes that are made in the configuration. You don't need to restart the service.
kubectl get pod
kubectl get replicaset
```

### Debugging and  logging
```
kubectl get pod
kubectl logs [pod name]
kubectl describe [pod name]

You can also use:
kubectl exec -it [pod name] --bin/bash
```
### Deleting the deployment and Adding configuration file
```
kubectl get deployment
kubectl get pods
kubectl get replicaset

# deleting deployment
kubectl get deployment
kubectl delete deployment [deployment name]
kubectl get pod
kubectl get replicaset
```
Best is just to use a configuration file:
```
kubectl apply -f  config-file.yaml
kubectl apply -f  nginx-depl.yaml
nano nginx-depl.yaml
```
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec: # specs for deployment
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template: # specs for a pod
    metadata:
      labels:
        app: nginx
    spec: # specs for a pod
      containers:
      - name: nginx
        image: nginx:1.16
        ports:
        - containerPort: 8080

```
Although it will auto update itself, since controller manager already recognize that. It is till better to use:
```
kubectl apply -f  nginx-depl.yaml
```
again. 

## 

# YAML Configuration File

Compose of three parts:
```
apiVersion: v1
kind: Deployment / Service <--- tells what component you want to create
```
- Metadata
- Specification

Attributes are specific to the kind of component. 

In case of deployment, we can have for example:
```
spec:
	replicas:2
	selector: ~
	templates: ~
```
In case of service, we can have for example:
```
spec:
	selector: ~
	ports: ~
```
- Status = automatically generated by K8s

## How does connections are established between components
1. Connecting deployment to pods:
- labelling through a key value pair.
- ` Pods get label through template blueprint then get matched on the selector`
2. Connecting Services to Deployments
- `Service will make a connection to the deployment and pods`
![](https://i.imgur.com/IZs5dRx.png)

### Creating both deployment and service
```nginx-deployment.yaml
# deleting all namespaces
kubectl delete all --all -n {namespace}

# allow scheduling using uncordon 
kubectl uncordon [node name]


kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
kubectl get service 
kubectl describe service [service name]
kubectl get service 

# show the IP address of the pods
 kubectl get pod -o wide
# get the edited version of configuration file
kubectl get deployment nginx-deployment -o yaml

# delete the deployment using the configuration file
kubectl delete -f nginx-deployment.yaml
```
```
apiVersion: apps/v1
kind: Deployment
metadata:
 name: nginx-deployment
 labels:
 app: nginx
spec:
 replicas: 2
 selector:
 matchLabels:
 app: nginx
 template:
 metadata:
 labels:
 app: nginx
 spec:
 containers:
 - name: nginx
 image: nginx:1.16
 ports:
 - containerPort: 8080
```
nginx-service.yaml
```
apiVersion: v1
kind: Service
metadata:
 name: nginx-service
spec:
 selector:
 app: nginx
 ports:
 - protocol: TCP
 port: 80
 targetPort: 8080
```
## Namespaces
- A way of organizing resources. It uses namespaces to easily distinguish resources.
- It is called a group inside a cluster.
```
kubectl get namespace
```
In default there are available namespace:
1. kube-system = compose of kubernetes system processes.
2. kube-public = all accessible information can be found here without authentication.
`kubectl cluster-info`
`kubectl cluster-info dump`
3. kube-node-lease = monitors the availability of node.
4. default = if you are starting with K8s, all resources that you create are all located here.

To create namespaces. there are two ways:
1. Command Line:
` kubectl create namespace my-namespace`
2. Configuration Map:

### The question now: Why use namespaces? Mainly because of the following benefits:
1. Resources are easily distinguishable since there would be namespaces.
e.g. ( Database_NS, which contains db like postgres, mysql) , also (Monitoring_NS, which contains prometheus and grafana) and (Elastic Stack or Nginx Ingress servers)


2. Team Synchronization: For example the team have their own isolated environments to work on but they employ a single Pipeline job to build an image. An overwriting issue will appear if teams are working on the same application since they deploy it on the same pipeline. Namespaces helps by labelling what teams are currently making the push and provide appropriate versioning based on the teams Namespace. More of like an identification. (E.g. TEAMB_NS, the data that pushes the changes will be logged as TEAMB_NS)

3. Resource Sharing. If two teams or more are working on an application ( Staging and Development Team) then they need tools (e.g. test data, which prompts the usage of databases) it would be wasteful if per team would have created their own instance of db. Rather than using that approach, two teams can share a same resource where they can test their own data, provided they will use different db name for that)

4. Blue/Green Deployment= In case of their would be changes or upgrades needs to be made in the production environment, avoiding downtime is necessary. So in order to keep the users from accessing the service, it needs to be available even to the update process. This works by floating/deploying a new instance that redirect the same requests and processes on the existing framework until such time that the upgrade is complete on the other machine.) **Blue-Green Deployment in K8s**

5. Limit the resources and access. A specific can have its own isolated environment. But never it can interfere with other teams env. Also, you can limit the amount of CPU and RAM or storage. 


**Side Notes**
- volume and nodes can't be put into a namespace, they need to be available globally.
`kubectl api-resources --namespaced=false`
`kubectl api-resources --namespaced=true`
- if you didn't specify a namespace then it would be going into default
- In config with no NS yet, try `apply -f *.yaml --namespace=my-namespace`
- But it is recommended to have namespace in the configmap. Namespaces needs to be in `metadata`

To change active namespace: You can try kubens
