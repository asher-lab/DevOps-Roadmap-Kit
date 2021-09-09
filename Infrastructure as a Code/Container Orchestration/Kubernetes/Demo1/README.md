A simple Demo project involving MongoDB ( Backend ) and MongoExpress ( Front End)

1. Start Minikube. ( Start a node. )
``` 
In root: chmod 666 /var/run/docker.sock
minikube start
kubectl get node
kubectl get all <--- get all the components inside the cluster
```
2. Create a MongoDB deployment w/ secret
`mongodb-deployment.yaml`
- Set up the secret:
` echo -n 'username' | base64 `
` echo -n 'password' | base64 `
` mongodb-secret.yaml' | base64 `
3. Create secret variables before applying the MongoDB deployment.
`kubectl apply -f mongodb-secret.yaml`
`kubectl get secret`

4. Apply MongoDB Deployment
`kubectl apply -f mongodb-deployment.yaml`
`kubectl get pod`
`kubectl describe pod [podname]`
`kubectl get all` < ---- ReplicaSet, Pod and Deployment with Services must be shown.

5. Creating an Internal Service so all pods within the cluster can access it.
You can create multiple configuration into a single file. Represented by:
`---` Placing both service and deployment.
`kubectl get service`
To verify if the service is attached to the pod:
`kubectl describe service [service name]`
`kubectl get pod -o wide`
`kubectl get all | grep mongodb`

6. Create a file for mongo express deployment service.
`mongodb-configmap.yaml`
- It should already be applied before you can reference it / deploy mongo express since server is mapped on to configmap.
- External service should have type: LoadBalancer and nodePort, so you can make the service externally available.
- `Cluster IP means default` and `LoadBalancer` can be external.
Perform `kubectl get service` to see the difference. 
In minikube, perform this: `minikube service [service name]`

<br>
<br>

### You can use Nginx if you want to make use of a remote IP.
### Demonstrate how to create a cluster of K8s - now I'm getting the glimpse of Microservices. :)
