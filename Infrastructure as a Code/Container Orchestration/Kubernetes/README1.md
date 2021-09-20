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
