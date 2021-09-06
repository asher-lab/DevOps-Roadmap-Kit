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

# YAML Configuration File

Compose of three parts:
- Metadata
- Specification
- Status = automatically generated by K8s
