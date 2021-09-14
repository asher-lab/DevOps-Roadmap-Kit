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
  replicas: 3
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
        image: nginx:1.14.2
        ports:
        - containerPort: 80

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

# Kubernetes Service
One of my favorite topics in K8s.
## Why?
- Permanent and Stable, pod IP address are ephemearal.
- Load Balancing, Services uses a built in process to distribute traffic between pods/nodes.
- Loosely coupled architecture, because you can reference a external service easily.

Example:
![](https://i.imgur.com/hCRdQLn.png)
- communication within cluster. (Internal Configuration)
- communication outside cluster. (External Configuration)

 ## Types
 ### 1. Cluster IP Service Type
 - default configuration
 - Example Scenario:
 - You have two apps with 2 ports opened ( since they have are performing specific tasks, 1.) ms-one 2.) log-collector, which are opened in ports 3000 and 9000 respectively).
 - This means that these two ports are accessible and open inside the pod.
![](https://i.imgur.com/LMJr5m6.png)
- It also has its own IP address from the allocated IP address per worker node. 
- ![](https://i.imgur.com/651XlPF.png)
-  To get the IP address of the pods in the cluster you can: `kubectl get pod -o wide`
- If there would be two replicas or more, then it will just start within another IP address from the same Node2 range ( 10.2.2.x) or another IP address from a different Node1 range (10.2.1.x)
#### Now. How does an external traffic forwarded to a service?

![](https://i.imgur.com/OUUUSZR.png)
- This is handled by the service (e.g. Cluster IP aka Internal Service) . The Ingress ( Incoming traffic is handled by the service). Remember that a **Service** is one of the most important component in Kubernetes, (just like a pod) but it is not a process, but **an abstraction layer that represent IP address**
- WHICH MEANS? Service gets an IP address and also a PORT of which you can access. Meaning that **Ingress** will handle the request on IP 10.128.8.64 and PORT 3200.
- **This is what makes service accessible inside the cluster**
- ![](https://i.imgur.com/PsyclXf.png)
- As you can see here: 
- **Ingress** knows the service because it reference it using the **name: microservice-one-service and port 3200** on its config which is **serviceName: microservice-one-service and servicePort 3200**
- ![](https://i.imgur.com/wF8yezc.png)

#### Now. How does a service know what Pod does it forward the requests to? In case of multiple ports opened into a pod on what port it forward the requests to?
![](https://i.imgur.com/xMoqX8M.png)

1. **How does a service know what Pod does it forward the requests to?**
- Service identifies a pod via selectors.
- Pods should have this as a label and matched with selectors. 
![](https://i.imgur.com/djSYnE9.png)
- Service config (which comprise of selector) and Deployment config (which comprise of labels) must be present with each other so that they can communicate.
- ![](https://i.imgur.com/wvlkv79.png)
- ![](https://i.imgur.com/eEmcMfR.png)
- **THIS IS HOW SERVICE WILL KNOW WHAT POD WILL IT FORWARD THE REQUESTS TO**

2. **How does a service know what Port of the Pod does it forward the requests to?**
It works by setting the config on Service ( which comprise of targetPort ) in case 3000 and it will 1.) get what Pods are its endpoints because of selector and labels. 2.) and ports which is 3000. **It will randomly select a Pod, since service also acts as a load balancer)
- ![](https://i.imgur.com/kOV2wz8.png)
- **NOTE** when you create a service it keeps track which endpoints/pods are a member of that service.
- `kubectl get endpoints`
- target port needs to be right in Service config. It needs to know what port the container is listening. 
- port can be anything in Service config.

**Implementing multi service set up**
- A pod communicates with a Service ( MongoDB Service) which has 2 endpoints.
![](https://i.imgur.com/MonABV6.png)
- targetPort is  the Pods Port, port can be anything not necessarily 27017
![](https://i.imgur.com/H1FR5iK.png)
- Also, selector must point to the label
- ![](https://i.imgur.com/8NGDgHu.png)


**Multiport Services**
- There are 2 things happening here:
- 1. A pod is communicating with mongodb application. (port 27017) -- which communicates with the database via the Service.
- 2. Prometheus is communication with mongo-db exporter to read the data (port 9216) -- which communicates with the data that is logged to the mongodb-exporter.
![](https://i.imgur.com/xAZ8yuT.png)- In case of **multiple ports**, you need to specify the name in the config.
- ![](https://i.imgur.com/qZNRSZD.png)

 ### 2. Headless Service Type
In **stateful service** such as databases (postgres, mysqldb or elasticsearch) there are instances that Pods are not identical and they offer different data. In this case you need to communicate with the Pod directly. 
Example: Master perform reading and writing, but the worker node can only perform reading which users can only look up into ( you can define the level of accessibility using **headless**), but this can be done via **cluster IP services to anyway ( the accessibility abstraction)**.
![](https://i.imgur.com/eZ1prpH.png)

## There are 3 service types
of which you need to define the type when creating
![](https://i.imgur.com/QBfuxMb.png)

### 3. Nodeport Service Type
- Creates a service that is accessible through a static port on each worker node in a cluster.
- As an example in **ClusterIP**, there is no external traffic that can pass through our Service barrier.
- But, in **NodePort**, there are external traffic that can pass through our cluster directly. External traffic has an access to to fix port on each worker node. 
- **Incase of ingress, it will come directly to NodePort service.** 
- Nodeport has range of 30k to 37767, anything outside this range won't be accepted.
- ![](https://i.imgur.com/wqKdlFb.png)
![](https://i.imgur.com/p0UOquW.png)
### 4. LoadBalancer Service Type
- Loadbalancers can be defined via cloud providers.
- ![](https://i.imgur.com/QS2tIgi.png)
- Loadbalancer as type in the config.
- Also has nodeport in it defined. **Alert! Don't use nodeport since it is insecure**
- ![](https://i.imgur.com/3GfAPwQ.png)
- Connection of Nodeport and ClusterIP
- ![](https://i.imgur.com/CV6QwnE.png)
- Always configure ingress and loadbalancer in production grade setting
- ![](https://i.imgur.com/Q3b6W96.png)



<br>

## Ingress

1. What is Ingress?
2. YAML config 
3. When to use Ingress>
4. Ingress controller

### External Service vs. Ingress
- In **External Service** you access the app you want by putting the port.
- In **Ingress** instead of an external service, where you open your IP and PORT, in Ingress your address and port is not opened.
 - In **Ingress**, once the request is made from the Browser, it will redirect it to an Internal Service (Cluster IP) which is itself, can't be accessed externally.
 - ![](https://www.nginx.com/wp-content/uploads/2020/04/NGINX-Plus-Ingress-Controller-1-7-0_ecosystem.png)
### Configuration Comparison:
External Service. Here nodeport is where the client can access it. In this case it is 35010. Kind defined as `service`
```
apiVersion: v1
kind: Service
metadata:
	name: myapp-external-service
spec:
	selector:
		app: myapp
	type: LoadBalancer
	ports:
	   - protocol: TCP
	     port: 8080
	     targetPort: 8080
	     nodePort: 35010
```
**Internal Service.** Here you have the kind defined as `Ingress`. Of which the host `myapp.com` when typed it into the browser,  it will redirect the traffic to a service named `myapp-internal-service`
- In `paths` , you can specify where it is 
- `http` is the kind of protocol you are routing to. it can  be `ftp`?
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
	name: myapp-ingress
spec:
	rules:
	- host: myapp.com
	  http:
		  paths:
		  - backend:
			  serviceName: myapp-internal-service
			  servicePort: 8080
```
### Relation of Internal Service and Ingress
![](https://i.imgur.com/zX4knHe.png)

### How to configure Ingress in your Cluster?
= Routing it alone directly Ingress->Service will not work. You need an**implementation for Ingress**. Called:
- Ingress Controller, needs to be installed.
- It is another pod that run in your kubernetes cluster, it evaluates and processes ingress rules.
- It manages redirection.
- It is an entrypoint to cluster.
- **There are many third party implementation of Ingress Controller.**
- In K8s there is **Kubernetes Nginx Ingress Controller**

**Different Implementations**
- **You need an ENTRYPOINT**
- It can be a loadbalancer from third party solutions like AWS. It act as an entry point to your cluster.
![](https://i.imgur.com/bgBcDOc.png)
- It can be a proxy server. This act as an entry point to your cluster.
- ![](https://i.imgur.com/yoX4XyP.png)
- This works by having a proxy as an entry point then redirect the request to the Ingress Controller, which then the controller will checks for the Ingress rules.
- All application here can't be requested externally, they must pass through the Controller, Ingress, and Proxy.
- ![](https://i.imgur.com/Ke3A0KQ.png)

### Configure Ingress Controller in Minikube
```
chmod 666 /var/run/docker.sock
minikube start
minikube ip
minikube addons enable ingress # starts that K8s Nginx implementation of Ingress controller
kubectl get pod -n kube-system
kubectl get pod -n ingress-nginx
```
### Create Ingress Rule
```
kubectl get ns
minikube addons enable dashboard
kubectl get ns
```
Configure ingress rule to dashboard so you can access it via domain name.
```
kubectl get all -n kubernetes-dashboard
```
`dashboard-ingress.yaml`
This will forward all request the is coming from dashboard.com to the service `kubernetes-dashboard`.
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dashboard-ingress
  namespace: kubernetes-dashboard
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: dashboard.com
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kubernetes-dashboard
            port:
              number: 80
```
Then apply,
`kubectl apply -f dashboard-ingress.yaml`
`kubectl get ingress` # works in default namespace
or:
`kubectl get ingress --all-namespaces`
`kubectl get ingress --namespace=kubernetes-dashboard`
to delete: 
`kubectl delete -f dashboard-ingress.yaml`
To check which IP your cluster is working:
`kubectl cluster-info`
Make some changes:
```
nano /etc/hosts
```
or you can just follow the tutorial here:
https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/

## Ingress - Flow
1. Requesting for dashboard.com 
2. To Ingress Controller 
3. Then Ingress controller evaluate the rules defined in `dashboard-ingress.yaml`
4. And forward the request to service. `kubectl get svc` which is `kubernetes dashboard`.

## Ingress - Default Backend Tutorial
`kubectl describe ingress dashboard-ingress -n kubernetes-dashboard`
Output:
>`Default backend:  default-http-backend:80 (<error: endpoints "default-http-backend" not found>)`
^ means that if there is no return, then `default-http-backend:port 80` is used to satisfy this request.

**Whenever there is a request coming to the cluster that it is not mapped on any `backend` ( meaning no rule for mapping the request to a service ), default backend is used.**
>404 page not found

**You can create a custom error page / or redirection to your home page. (Tutorial)**
CONFIGURING DEFAULT BACKEND IN INGRESS
1. You need to create a service called `service/default-http-backend created` 
`default-backend-service.yaml`. 
Then apply this one.
`kubectl apply -f default-backend-service.yaml`
```
apiVersion: v1
kind: Service
metadata:
   name: default-http-backend
   namespace: kubernetes-dashboard
spec:
   selector:
      app: default-response-app
   ports:
      - protocol: TCP
        port: 80
        targetPort: 8080
```
2. You need to create a pod aka deployment. Which has the label of `default-response-app` since the selector the service is `default-response-app`. It has targetport of `8080`

> Use this link to create a ready made template https://medium.com/alterway/how-to-custom-your-default-backend-on-kubernetes-nginx-controller-9b38048e10c0

Then apply this one.
`kubectl apply -f default-backend-deployment.yaml`
```
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: kubernetes-dashboard
  name: default-response-app
  labels:
    app.kubernetes.io/name: default-response-app
    app.kubernetes.io/part-of: ingress-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: default-http-backend
      app.kubernetes.io/part-of: ingress-nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/name: default-http-backend
        app.kubernetes.io/part-of: ingress-nginx
    spec:
      containers:
      - name: default-http-backend
        image: asherlab/custom-default-backend:1.0
        ports:
        - containerPort: 8080
        # Setting the environment variable DEBUG we can see the headers sent 
        # by the ingress controller to the backend in the client response.
        env:
        - name: DEBUG
          value: "false"
```
Useful cmd for debugging
```
kubectl describe ingress dashboard-ingress -n kubernetes-dashboard
kubectl get deployments --namespace=kubernetes-dashboard
kubectl get pods --namespace=kubernetes-dashboard
kubectl get service --namespace=kubernetes-dashboard
```

Tasks: 
https://v1-18.docs.kubernetes.io/docs/tasks/
