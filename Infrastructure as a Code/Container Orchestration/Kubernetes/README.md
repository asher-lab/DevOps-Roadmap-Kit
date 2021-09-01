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
- **A pod is a collection of applications and volumes which share one ip address where each of the containerized application can share the same port space of that single IP:**
![](https://kubernetesbootcamp.github.io/kubernetes-bootcamp/public/images/module_03_pods.svg)
