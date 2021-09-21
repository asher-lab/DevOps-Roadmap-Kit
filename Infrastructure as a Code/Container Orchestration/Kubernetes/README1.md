# Kubernetes Volume
Persisting data in Kubernetes using Volumes.
1. Persistent Volume
2. Persistent Volume Claim
3. Storage Class

## Persistent Volume
**A must**
- All new nodes must point the data to the volume.
- Storage must never be dependent on the pod lifecycle.
- Storage needs to exists even a pod/cluster/node crashes.

A **persistent resource** is a cluster resource that is used to store data.
```
created via YAML file
kind: PersistentVolume
spec: e.g how much storage?
```
This needs a localdisk, nfs server or a EBS. How can I setup these?
- By Kubernetes, it doesn't help you in setting for storage, it just there to create an interface ( an abstraction).
- You are the one that is needed to create and manage storage and ensure that is maintained. 
- For which a **storage = external plugin** to your cluster.


`persistent-volume.yaml` - plain
```
apiVersion: v1
kind: PersistentVolume
metadata:
	name: pv-name
spec:
	capacity:
		storage: 5Gi
	volymeMode: Filesystem
	accessModes:
		- ReadWriteOnce
	persistentVolumeReclaimPolicy: Recycle
	storageClassName: slow
	mountOptions:
		- hard
		- nfsvers=4.0
	nfs:
		path: /dir/path/on/nfs/server
		server: nfs-server-ip-address
```
- Use that physical storages in the spec section!
- Here you define the size, parameters such as permission level and backend address.

`persistent-volume.yaml` - google cloud
```
apiVersion: 1
kind: PersistentVolume
metadata:
	name: test-volume
	labels:
		failure-domain.beta.kubernetes.io/zone: us-central1-a__us-central1-b
spec:
	capacity:
		storage: 400Gi
	accessModes:
	- ReadWriteOnce
gcePersistentDisk:
	pdName: my-data-disk
	fsType: ext4
```

- Depending on storage type, spec attributes differ.
- In kubernetes documentation,  you can see the storage backend the kubernetes support. https://kubernetes.io/docs/concepts/storage/persistent-volumes/
- Persistent Volumes are not namespaced! Meaning that it is available to all clusters.

### Local vs Remote Volume Types
- for data persistence always use remote storage!
### Persistent Volumes and When?
- Much like CPU, PV must be there already before setting up the cluster.
- Kubernetes Admin set up the cluster. ( This one configure the storage and creates the PV components from these backend.)
- Kubernetes User deploys the application in cluster.

## 2. Persistent Volume Claim
- AN APPLICATION HAS TO CLAIM THE PERSISTENT VOLUME.
- PVC , claims a volume with capacity (e.g. 10Gi)
![](https://i.imgur.com/YdKVith.png)
- where the application now connect with pvc via pod config.![](https://i.imgur.com/zSv9aei.png)

### How a PVC works (Persistent Volume Claim)?
- Pod request the volume through the PVC.
- Claim tried to find a volume in cluster.
- Then if there is a volume that matches the criteria then it select it.
- PVC must be same namespace with pod.


After the PVC is set up, we need to mount the volume/storage
!![](https://i.imgur.com/Cv2wpKC.png)
- Volume is mounted into the container.
- Volume is mounted into the pod.
- A pod can now write and read from the PV.

## ConfigMap and Secret
- Both are local volumes.
- not create via PV or PVC.
- managed by Kubernete

Example: You need configuration file for pod or file as its dependency. (SSL certificate)
- meaning that you need the file available right a way.
- then mount it on pod/container.
![](https://i.imgur.com/3SqGDME.png)

Summary: 
- Volume is directory with some data.
- Volumes are accessible in container in a pod. 
- How to make available in yaml config. 
- In docker, apps can access containers here: === var www html
![](https://i.imgur.com/OyTeQ3t.png)
- you can define what containers can get the access.
- you can use many types of volumes in a pod.
- Example is an elastic app. It can have secret , configMap and Elastic Blockstore mounted.
- ![](https://i.imgur.com/1kaq5yy.png)
- ![](https://i.imgur.com/3dhEivS.png)

## Storage Class
- When pods are deployed hundreds in numbers. So it is possible to create many PV too, but it can get messy when scale up. 
- Storage class, third kubernetes component that makes everything efficient.
- SC provisions Persistent Volumes Dynamically.
- When Persistent Volume Claim claims it.
![](https://i.imgur.com/Xyhbb5m.png)
- abstracts the underlying storage provider.
- parameters for that storage. 

### How to use SC, Storage Class?

- Requested by Persistent Volume Claim.
-![](https://i.imgur.com/6ZgaXIn.png) ![](https://i.imgur.com/mcuHOEh.png)


# ConfigMap and Secret Volume Types.
![](https://i.imgur.com/OkJumYQ.png)

### When to use this type of volume?
- when an application needs a config file when it starts. like prometheus, 
- when an application needs confidential data. password properties file.
- or a certificate file like a specific SSL to communication with a specific service. 

Example in mongodb:
- mongodb-configmap.yaml
- mongodb-secret.yaml
- mongo-express.yaml
![](https://i.imgur.com/S9gf2Nj.png)
With ConfigMap and Secret, you can:
- create individual key-value pairs
- or files to be mounted in the container.

## DEMO
`mongodb-config-components.yaml`
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: mongodb-configmap
data:
  db_host: mongodb-service
 
---
apiVersion: v1
kind: Secret
metadata:
  name: mongodb-secret
type: Opaque
data:
  username: dXNlcm5hbWU=
  password: cGFzc3dvcmQ=

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb
  labels:
    app: mongodb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo
        ports:
        - containerPort: 27017
        env:
        - name: MONGO_INITDB_ROOT_USERNAME
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: username
        - name: MONGO_INITDB_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: password
              
---
apiVersion: v1
kind: Service
metadata:
  name: mongodb-service
spec:
  selector:
    app: mongodb
  ports:
    - protocol: TCP
      port: 27017
      targetPort: 27017
  
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongo-express
  labels:
    app: mongo-express
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongo-express
  template:
    metadata:
      labels:
        app: mongo-express
    spec:
      containers:
      - name: mongo-express
        image: mongo-express
        ports:
        - containerPort: 8081
        env:
        - name: ME_CONFIG_MONGODB_ADMINUSERNAME
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: username
        - name: ME_CONFIG_MONGODB_ADMINPASSWORD
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: password
        - name: ME_CONFIG_MONGODB_SERVER 
          valueFrom: 
            configMapKeyRef:
              name: mongodb-configmap
              key: db_host
---
apiVersion: v1
kind: Service
metadata:
  name: mongo-express-service
spec:
  selector:
    app: mongo-express
  type: LoadBalancer  
  ports:
    - protocol: TCP
      port: 8081
      targetPort: 8081
      nodePort: 30000

```
`mpsquito-config-components.yaml`
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: mosquitto-config-file
data:
  mosquitto.conf: |
    log_dest stdout
    log_type all
    log_timestamp true
    listener 9001
    
---
apiVersion: v1
kind: Secret
metadata:
  name: mosquitto-secret-file
type: Opaque
data:
  secret.file: |
    c29tZXN1cGVyc2VjcmV0IGZpbGUgY29udGVudHMgbm9ib2R5IHNob3VsZCBzZWU=
    
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mosquitto
  labels:
    app: mosquitto
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mosquitto
  template:
    metadata:
      labels:
        app: mosquitto
    spec:
      containers:
        - name: mosquitto
          image: eclipse-mosquitto:1.6.2
          ports:
            - containerPort: 1883
          volumeMounts:
            - name: mosquitto-conf
              mountPath: /mosquitto/config
            - name: mosquitto-secret
              mountPath: /mosquitto/secret  
              readOnly: true
      volumes:
        - name: mosquitto-conf
          configMap:
            name: mosquitto-config-file
        - name: mosquitto-secret
          secret:
            secretName: mosquitto-secret-file    

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mosquitto
  labels:
    app: mosquitto
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mosquitto
  template:
    metadata:
      labels:
        app: mosquitto
    spec:
      containers:
        - name: mosquitto
          image: eclipse-mosquitto:1.6.2
          ports:
            - containerPort: 1883

```
- secret component must be base 64 encoded.
- you can also have a secret like CA. e.g. cacert.pem

### MQTT without volumes: `mosquitto-without-volumes.yaml`
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mosquitto
  labels:
    app: mosquitto
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mosquitto
  template:
    metadata:
      labels:
        app: mosquitto
    spec:
      containers:
        - name: mosquitto
          image: eclipse-mosquitto:1.6.2
          ports:
            - containerPort: 1883
```
Will show the default config for volumes in mosquitto looks like.

1. minikube start
2. kubectl apply -f mosquitto-without-volumes.yaml
3. kubectl exec -it <containerID> -- /bin/sh
4. cd mosquitto && ls
5. cd config and try to read some config.
6. kubectl delete -f mosquitto-without-volumes.yaml

### MQTT with volumes: `mosquitto-with-volumes.yaml` with conf
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mosquitto
  labels:
    app: mosquitto
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mosquitto
  template:
    metadata:
      labels:
        app: mosquitto
    spec:
      containers:
        - name: mosquitto
          image: eclipse-mosquitto:1.6.2
          ports:
            - containerPort: 1883
          volumeMounts:
            - name: mosquitto-conf
              mountPath: /mosquitto/config
            - name: mosquitto-secret
              mountPath: /mosquitto/secret  
              readOnly: true
      volumes:
        - name: mosquitto-conf
          configMap:
            name: mosquitto-config-file
        - name: mosquitto-secret
          secret:
            secretName: mosquitto-secret-file     
```
Will show the default config for volumes in mosquitto looks like.

1. minikube start
2. kubectl apply -f config-file.yaml
3. kubectl apply -f secret-file.yaml
4. Making configmap and secret ready!
5. `In config, mount the configmap and secret.`
6. `Also, mount the volume to the container.`
7. `mountpath = is a filesystem inside the container. `
8. `files or folders that are not meant to change can have readonly permissions.`
9. kubectl apply -f mosquitto-with-volumes.yaml
10. kubectl exec inside the pod. 
11. kubectl delete -f mosquitto-without-volumes.yaml

![](https://i.imgur.com/EJWg9wj.png)
- can be used as env variables
- can be used to create files
- ![](https://i.imgur.com/dWJHq03.png)




# StatefulSet
- Stateful , any application that store data and keeps track of its state.
- mongodb, postgres, mysql, mongodb
- Stateless, handle new session for every restart. AND doesn't keep the state.
- **Stateless** apps are deployed via Deployment. Will allow you to create Replica. Configure Storage.  Has random hash/name. Pod Identity.
- **Stateful** apps are deployed via StatefulSet. Will allow you to create Replica. Configure Storage. Has fixed ordered name. Pod Identity.

### Why the need for statefulset?
- If you create replicas of database, it might lead to data inconsistency since you are writing data randomly on both databases.
- So need to have **master** that allow you to write data and **worker/slaves** to read the data. act as a data replica.

. 

- When you created a new pod, then it will create it after the last one is up and running.
- When you delete a new pod, then it will delete it starting from the last one.
- Each pod in a statefulset get its own DNS endpoint from a service. 
- First ) There is a service name that will address every replica pod. `loadbalancer service`
- Second) There is individual dns name for each pod. `individual service name`
- ![](https://i.imgur.com/fy1VRD1.png)

So:
![](https://i.imgur.com/yHmKvqY.png)
- retain state and role even when a pod is restarted.
- Summary....
- Pod creation for statefulset is complex
- In containers, stateful applications are not perfect for containerized environments.
- It is best served with Stateless applications. 



# Kubernetes on Cloud - Managed
### Use case:
- You want to have something that:
- Web App with database
- Security for cluster
- data persistence for DB
- dev and production environment
- env: development and production


Two ways to create Cluster.
1. You can spin up your own server and manage your things there. From setting up everything including installing containerd, kube proxcy, etc.\
2. Or using a managed one (e.g. Linode Kubernetes Engine) **LKE**

In **managed service** Kubernetes:
- You only care about your Worker nodes.
- Everything is already pre installed.
- Master Nodes are created and managed by Cloud Provider.

In **LKE** you can:
- select where region it is
- size and capacity of the kubernetes cluster

**2.) It also has data persistence for your cluster**

e.g.  MongoDB and NodeJS app running in cluster

Linode has Linode Block Storage

You use Linode's Storage Class and the create persistent volumes, with physical storage automatically. So when you deploy your application, storage will attached to the database pod. 


**3.)Load Balancing your Kubernetes Cluster**
Now all three are running:
1. NodeJS app running in cluster.
2. MongoDB app
3. Storage configured.
4. ####------- Services and Ingress to enable access from browser. Ingress managing the routing of incoming requests. For example from browser, then managed by ingress, then to the internal service. ------# **Installing Ingress Controller is a must**


## So how does managed kubernetes service really works?
In cloud platforms, you have own LoadBalancer implementation,  ( that gets in front of the Nginx ingress controller) which becomes an** entrypoint of your cluster.  **
- **Loadbalancer** is loadbalancer for worker nodes.
- **Nodes** are the linode server instances.
- ![](https://i.imgur.com/dCl1gws.png)
- Loadbalancer has the public IP address.
- Webserver is hidden, and **can only be** accessible from the private IP of the Loadbalancer itself. 
- Of which, you can add many *webserver* so that the loadbalancer will then forward that traffic to. 
- So you can scale your resources up and down without your users not noticing anything. 
- But you need to set up the entry for your application only once.
- ![](https://i.imgur.com/3wARFLk.png)
- In scenario, where session is present from a web server, a session stickiness principle can be used to configure the loadbalancer to redirect the requests to the known webserver, not random. Meaning a client can run on the same backend.
- You can secure your connection with SSL certification. From browser to Load Balancer. Or to secure the connection to your cluster. SSL to cluster. 
- ![](https://i.imgur.com/SPJl4nC.png)
**4.) Data Center for your Kubernetes Cluster**
Select the nearest. 
**5.) Move app from one cloud provider to another cloud provider**
**6.) Automating task**
- using automation tools to automate your infrastructure and deployment of services in infrastructure. (e.g. Terraform has provider, Ansible has modules that can connect e.g. in Linode platform to get access to its resources (of linode platform) and let you automate your devops work in order to save time and work more efficiently. 

# Helm - package manager for Kubernetes
- Helm changes a lot between versions, so a basic understanding about its fundamentals is a must. and also use cases when and why we use them.

### What is Helm?
- It is a package manager for kubernetes ( e.g. apt, yum, etc.)
- Pack a collection of kubernetes YAML files and distributing them in public and private repo.

Let's say you have deployed your app in a cluster. And you wanted to add Elastic Stack for logging.  In order to deploy it, you need statefulset since it is a DB, also you need ConfigMap for configuration, you also need Secret for it has secret data. K8s User with permissions and Services. 

These steos might take some time and is stressful. So good people , samaritan once had created a YAML file and they **packaged** them via HELM. 

- A bundle of YAML files is called HELM Charts. 
- Create your own HEML charts using HELM
- Push them to a Repository of HELMS
- Download and use existing ones. 
- All databases and monitoring set ups like elastic stack DBs and prometheus, etc. have all available Helm charts that are stored in some repo.  

`helm search <keyword>` or in Helm Hub or in Helm Hub Pages and other repo. 

If you are for example trying to deploy many almost similar instances of deployment , like similar thing of those , then you can make use of HELM.
1. Define a common blueprint. 
2. Dynamic Values are replaced by placeholders. This makes use of template file: 
![](https://i.imgur.com/F7Flqv1.png)
This is where the values will come from:

![](https://i.imgur.com/a0NOEEW.png)

**Use case:** Deploy the same application accross different environment clusters.  So instead of deploying it via its own YAML on different environments ( Dev, staging or production ) . You use Helm Chart.

![](https://i.imgur.com/EVv3gZo.png)
![](https://i.imgur.com/nL2q9Dg.png)
![](https://i.imgur.com/oyOEPy2.png)
![](https://i.imgur.com/HtWhmUD.png)
![](https://i.imgur.com/J5PGeXG.png)


# DEMO: Install Stateful App using Helm
What to do: Deploy an managed K8s cluster on AWS.
Here we will:
- Deploy a replicated database and configure its persistence
- Make the UI accessible through the browser via Ingress
- This will be made possible via HELM
- ![](https://i.imgur.com/JeaUjNZ.png)


**Overview**
- deploy mongodb using HELM
- 3 replicas using StatefulSet
- Configure data persistence with cloud providers cloud storage.
- deploy UI client mongo-express to access it from browser.
- Configure nginx-ingress and controller and configure nginx rules. 
- ![](https://i.imgur.com/3yO7Qek.png)

## Steps
1. Create Kubernetes Cluster on Linode Engine : v 1.17
Master nodes are already made one for you.
2. Linode: Kubeconfig is needed. So download it since it has credentials `test-kubeconfig.yaml`
3. `export KUBECONFIG=test-kubeconfig.yaml`
4. `kubectl get node`
5. Then we deploy the mongodb statefulset. 1.) It can be done via creating all the configuration files yourself. 2.) Use bundle of those config files - HELM CHART
6. Be sure that helm is installed. Helm will execute the command against the cluster it is connected to. 
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
helm search repo bitnami/mongo
```
Doing that command, you will see all the chart that the repository contains. 
![](https://i.imgur.com/suWua9P.png)
- Need to edit some config. Make use of `values.yaml`
`test-mongodb-values.yaml`
```
architecture: replicaset
replicaCount: 3
persistence:
	storageClass: "linode-block-storage"
auth:
	rootPassword: secret-root-pwd
```
What does that line do is , it connect to your Linode, and create physical storage and attached it to your Pods. 
`helm install mongodb --values test-mongodb.yaml bitnami/mongodb`
`kubectl get pod`
`kubectl get all`
`kubectl get secret`

Try going to Linode UI, then go to volumes, you will now see that there are three persistent volumes that are now dynamically created. 
![](https://i.imgur.com/QN8RFxw.png)
7. Deploy Mongo-Express. UI for mongodb
`test-mongo-express.yaml`
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongo-express
  labels:
    app: mongo-express
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongo-express
  template:
    metadata:
      labels:
        app: mongo-express
    spec:
      containers:
      - name: mongo-express
        image: mongo-express
        ports: 
        - containerPort: 8081
        env:
        - name: ME_CONFIG_MONGODB_ADMINUSERNAME
          value: root
        - name: ME_CONFIG_MONGODB_SERVER
          value: mongodb-0.mongodb-headless
        - name: ME_CONFIG_MONGODB_ADMINPASSWORD
          valueFrom: 
            secretKeyRef:
              name: mongodb
              key: mongodb-root-password
---
apiVersion: v1
kind: Service
metadata:
  name: mongo-express-service
spec:
  selector:
    app: mongo-express
  ports:
    - protocol: TCP
      port: 8081
      targetPort: 8081

```
`kubectl get secret mongodb -o yaml`
**In order to connect to mongodb, need endpoint, user and password.**

8. `kubectl get logs <mongoexpress ID>
```
Database Connected
Admin Database Connected
```
![](https://i.imgur.com/FFAELjR.png)
9. And we know that express is still a internal service, we need express to be accessed on the public. So we need ingress. So we need to install ingress controller in our Kubernetes cluster.
10. Use HELM CHART to install nginx ingress  
```
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install nginx-ingress stable/nginx-ingress --set controller.publishService.enabled=true
kubectl get pod
```
Now you can create ingress rules. Nginx Ingress controller make use of Load Balancer technology. When you did provision Nginx controller. **NodeBalancers** in Linode is automatically/dynamically provisioned. This becomes the entry point of the cluster. 
![](https://i.imgur.com/ExL8Iea.png)
### Creating Ingress rules for service so you can access express from browser.
`kubectl get service`
Remember Type that: type/externalP
Loadbalancer = accessible externally / withIP
ClusterIP =  internal service / <none>
`test-ingress.yaml`
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: mongo-express
spec:
  rules:
    - host: nb-139-162-140-213.frankfurt.nodebalancer.linode.com
      http:
        paths:
          - path: /
            backend:
              serviceName: mongo-express-service
              servicePort: 8081

```
- Here host must be a domain
- Any anything that comes from the host willl be forward to the backend service.
- `kubectl apply -f test-ingress.yaml`
- `kubectl get ingress`
- try accessing the domain. You must have mongo-express UI!
- Good thing about this set up is, if you delete the pods, volumes will remain. It has data persistence.
- `kubectl scale --replicas=0 statefulset/mongodb`
- You can see in Linode that the volumes are not removed, but is unattached.
- `kubectl get pod`
- `kubectl scale --replicas=3 statefulset/mongodb`
- `helm ls`
- `helm uninstall mongodb`
- Volumes are still there if got deleted. You can delete via Linode : Volumes and Cluster as well.
- With helm, no need for cleanup.
