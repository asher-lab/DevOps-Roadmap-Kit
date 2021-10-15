# Method 1: CERT-MANAGER in EKS ( Using EKSCTL ) : Deployments Apps: Grafana, (soon: Prometheus and Node Exporter )

## Overview
### 1. Overview of the Infrastructure
- cloudcraft.co . In order to map what eksctl had created I needed to use this. So I can use it when creating terraform config.
### 2. Overview of the Process
- Created diagrams.net
![](https://i.imgur.com/cRhg2oj.png)
## A. Provision an EKS Cluser using AWS eksctl
1. Run the following eksctl command to create an Amazon EKS cluster in the us-east-2 Region with Kubernetes version 1.19 and two nodes. You can change the Region to the one that best fits your use case. 
```
eksctl create cluster \
--name acm-pca-lab \
--version 1.19 \
--nodegroup-name acm-pca-nlb-lab-workers \
--node-type t2.medium \
--nodes 2 \
--region us-east-2
```
2. Once your cluster has been created, verify that your cluster is running correctly by running the following command:
```
kubectl get pods --all-namespaces
kubectl get nodes
```
## B. Install Nginx Ingress

### Method 1: Using HELM
1. This will create a nginx ingress on ingress-nginx
```
helm install my-release nginx-stable/nginx-ingress --namespace ingress-nginx
``` 
2. Run the following command to determine the address that AWS has assigned to your LB
```
kubectl get service -n ingress-nginx
```
3. It can take up to **5 minutes** for the load balancer to be ready. Once the external IP is created, run the following command to verify that traffic is being correctly routed to ingress-nginx:
```
curl http://a3ebe22e7ca0522d1123456fbc92605c-8ac7f1d49be2fc42.elb.us-east-2.amazonaws.com
```
### Method 2: Using YAML configurations
## C. Configure DNS Record
1. On your route 53, create an hosted zone with your domain.
2. Edit the record. Route A record ( Load Balancer ) to your hosted zone.
3. You should see nginx welcome page when going to your domain if successful.

## B. Set up the cert-manager, cert issuer and check for status
**1. Install cert-manager**
```
kubectl create namespace cert-manager 
helm repo add jetstack https://charts.jetstack.io 
helm repo update
```

Method 1:
```
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.5.3 --set installCRDs=true
```
Method 2:
```
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.crds.yaml
```
Method 3:
```
helm template cert-manager jetstack/cert-manager --namespace cert-manager | kubectl apply -f -
```
**2. Add kubectl plugin for cert-manager to perform test.**

- Cert-Manager has a Kubectl plugin which simplifies some common management tasks. It also lets you check whether Cert-Manager is up and ready to serve requests.
```
curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/latest/download/kubectl-cert_manager-linux-amd64.tar.gz
tar xzf kubectl-cert-manager.tar.gz
sudo mv kubectl-cert_manager /usr/local/bin
```
Now use the plugin to check your Cert-Manager installation is working:
```
kubectl cert-manager check api
```
You should see the following output:
```
The cert-manager API is ready
```
**3. Create / Install certificate issuer**
- Issuers and cluster issuers are resources which supply certificates to your cluster. The basic Cert-Manager installation created so far is incapable of issuing certificates. Adding an issuer that’s configured to use Let’s Encrypt lets you dynamically acquire new certificates for services in your cluster.

Create a YAML file in your working directory and name it `issuer.yaml`. Add the following content:
```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: example@example.com
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
      - http01:
          ingress:
            class: nginx
```

You must replace the email address with your own contact email. This will be included in your certificates. Let’s Encrypt may also email you at the address if it needs to send you alerts about your certificates.

`kubectl create -f issuer.yaml`
`kubectl describe clusterissuer  letsencrypt-staging`

4. Install Nginx Controller ( Not to be confused with Nginx, they are both different )
```
kubectl create ns ingress-nginx 
kubectl -n ingress-nginx apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.3/deploy/static/provider/cloud/deploy.yaml
```
## C. Deploy Apps: Grafana, Prometheus and Node Exporter

All in case with " == " are just for a simple hello world app. Navigate to Prometheus Operator.
1. Create: `deployment.yaml`
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-deploy
  labels:
    app: example-app
    test: test
  annotations:
    fluxcd.io/tag.example-app: semver:~1.0
    fluxcd.io/automated: 'true'
spec:
  selector:
    matchLabels:
      app: example-app
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: example-app
    spec:
      containers:
      - name: example-app
        image: aimvector/python:1.0.4
        imagePullPolicy: Always
        ports:
        - containerPort: 5000
        # livenessProbe:
        #   httpGet:
        #     path: /status
        #     port: 5000
        #   initialDelaySeconds: 3
        #   periodSeconds: 3
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "256Mi"
            cpu: "500m"
#NOTE: comment out `volumeMounts` section for configmap and\or secret guide
        # volumeMounts:
        # - name: secret-volume
        #   mountPath: /secrets/
        # - name: config-volume
        #   mountPath: /configs/
#NOTE: comment out `volumes` section for configmap and\or secret guide
      # volumes:
      # - name: secret-volume
      #   secret:
      #     secretName: mysecret
      # - name: config-volume
      #   configMap:
      #     name: example-config #name of our configmap object
```
Perform: `kubectl apply -f deployment.yaml`  
Perform: `kubectl get pods`

2.  To expose this app, you need to create a service.
Create: `services.yaml`
```
apiVersion: v1
kind: Service
metadata:
  name: example-service
  labels:
    app: example-app
spec:
  type: LoadBalancer
  selector:
    app: example-app
  ports:
    - protocol: TCP
      name: http
      port: 80
      targetPort: 5000
```
Perform: `kubectl apply -f services.yaml`  
Perform: `kubectl get pods`
**Here is how to install grafana:**

1. Create: `deployment.yaml`
```

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: grafana-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi

---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: grafana
  name: grafana
spec:
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      securityContext:
        fsGroup: 472
        supplementalGroups:
          - 0
      containers:
        - name: grafana
          image: grafana/grafana:7.5.2
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 3000
              name: http-grafana
              protocol: TCP
          readinessProbe:
            failureThreshold: 3
            httpGet:
              path: /robots.txt
              port: 3000
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 30
            successThreshold: 1
            timeoutSeconds: 2
          livenessProbe:
            failureThreshold: 3
            initialDelaySeconds: 30
            periodSeconds: 10
            successThreshold: 1
            tcpSocket:
              port: 3000
            timeoutSeconds: 1
              memory: 750Mi
          resources:
            requests:
              cpu: 250m
          volumeMounts:
            - mountPath: /var/lib/grafana
              name: grafana-pv
      volumes:
        - name: grafana-pv
          persistentVolumeClaim:
            claimName: grafana-pvc

```
Perform: `kubectl apply -f deployment.yaml`  
Perform: `kubectl get pods`
2.  To expose this app, you need to create a service.
Create: `services.yaml`
```
apiVersion: v1
kind: Service
metadata:
  name: grafana
  labels:
	  app: grafana
spec:
  type: LoadBalancer
  selector:
    app: grafana
  ports:
    - port: 3000
      protocol: TCP
      targetPort: http-grafana
      name: http
```
Perform: `kubectl apply -f services.yaml`  
Perform: `kubectl get pods`




## D. Final touch.

**TO expose app on ingress** Here we need to **expose the service into ingress object** and also setting up https now on our URL.
1a. Create: `ingress.yaml` via hello world app
```
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: "nginx"
  name: example-app
spec:
  tls:
  - hosts:
    - asherops.ml
    secretName: example-app-tls
  rules:
  - host: asherops.ml
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service: 
            name: example-service
            port: 
              number: 80
```

1b. Create: `ingress.yaml` via grafana app
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: "nginx"
  name: grafana
spec:
  tls:
  - hosts:
    - asherops.ml
    secretName: grafana-app-tls
  rules:
  - host: asherops.ml
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service: 
            name: grafana
            port: 
              number: 80
```


3. Create: `certificate.yaml`
```
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: grafana
  namespace: default
spec:
  dnsNames:
    - asherops.ml
  secretName: grafana-app-tls
  issuerRef:
    name: letsencrypt-cluster-issuer
    kind: ClusterIssuer
```
Perform: `kubectl apply -f certificate.yaml`  
Perform: `kubectl apply -f ingress.yaml`
Perform: `kubectl describe certificate grafana`  
Perform: `kubectl get secrets`
Perform: `kubectl get ns`
Perform: `kubectl get ingress`
Perform: `kubectl get all`
Also: `kubectl describe clusterissuer letsencrypt-staging`
**Try visiting your domain. Also take note you can use other devices to check since sometimes it saves cache.**

- **Take Note that when you "kubectl get ns" it should have no running containers.**
- **remember to delete all what is provisioned by eksctl it migh incur cost**
- `eksctl delete cluster --name=eksworkshop-eksctl`
<br>
Useful links I used when debugging:
https://github.com/jetstack/cert-manager/issues/2319
https://github.com/jetstack/cert-manager/issues/2540
https://github.com/kubernetes/kubernetes/issues/60807
https://stackoverflow.com/questions/61036538/letsencrypt-not-verifying-via-kubernetes-ingress-and-loadbalancer-in-aws-eks
https://learn.hashicorp.com/tutorials/terraform/eks
https://learnk8s.io/terraform-eks
https://www.cloudsavvyit.com/14069/how-to-install-kubernetes-cert-manager-and-configure-lets-encrypt/
https://grafana.com/docs/grafana/latest/installation/kubernetes/

- elastic.co
- artifacthub.io


# Method 1: Results : ( I didn't use HELM when installing grafana )
![](https://i.imgur.com/9oxegmu.png)
![](https://i.imgur.com/FupIYtH.png)
![](https://i.imgur.com/dE8onDH.png)

![](https://i.imgur.com/8r26Zqe.png)





































































# Method 2: CERT-MANAGER in EKS ( Using Terraform ) : Deployments Apps: Grafana, ( soon : Prometheus and Node Exporter )
## A. Provision an EKS Cluser using AWS eksctl
## B. Set up the cert-manager, cert issuer and check for status
## C. Deploy Apps: Grafana, Prometheus and Node Exporter
