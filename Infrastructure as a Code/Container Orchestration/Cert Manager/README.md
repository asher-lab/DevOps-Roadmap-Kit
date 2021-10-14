# CertManager
- CertManager helps you to provision your keys in your Kubernetes cluster. It is configured in YAML File. Where it requires a domain and **secret** ( where the certificate  should be stored ).
- The CertManager will talk to the CA and will place the received certificate in our specified **secret**
- CertManager replaces the old one when it is about to expire.
- Meaning : Free SSL Generation. Certificate Life Cycle Management.


# 🔒 CertManager with EKS

# 👽 👽👽👽👽👽Deploy ElasticSearch, Kibana and FluentD on Kubernetes Cluster👽👽👽👽👽

- ensure that alerting are working
- lens ide: https://k8slens.dev/ this is a kubernetes ide
- Elastic.co
- Deploy it using helm charts
- https://artifacthub.io/
- Nodegroup via aws eks (optional)


## Step 1.  Provision an EKS Cluster using Terraform
```
Make sure that AWS Credentials are configured on your website.
Make sure kubectl is installed.

You can clone the repo: https://gitlab.com/asher-lab/terraform-learn
Be sure to use aws account. Not AWS Educate ones.
```
### Step 1.1 Create a VPC. 
Create: `terraform.tfvars`
```
vpc_cidr_block = "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet_cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
```
Create: `vpc.tf`
```
provider "aws" {
  region = "us-east-1"
}

# variable definitions
variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}


#data definition
# querying data

data "aws_availability_zones" "azs" {}


module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"
  # insert the 21 required variables here
  
  name = "myapp-vpc"
  # specify the cidr block
  cidr = var.vpc_cidr_block
  
  # specify the cidr block of the subnet

  /*  best practice
  1 private and 1 public subnet in each AZ
  */
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks

  #deploy subnets in all availability zones
  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway = true

  # all private subnets will route their internet traffic
  # through ths single NAT gateway
  single_nat_gateway = true

  # will assign public and private ip
  # will assing public and private dns names
  enable_dns_hostnames = true


  # use case for tags is to have more information for human consumption
  # use case for tags is also referencing 
  # kubernetes cloud controller manager needs to know what tags to look for
  # in kubernetes resources, so it makes use of tags
  # this helps control identifier to know what vpc should it connect to


  # tagging vpc
  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

  # tagging public subnets
 public_subnet_tags = {
 "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
 "kubernetes.io/role/elb" = 1 
 }

  # tagging private subnets
  private_subnet_tags = {
 "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
 "kubernetes.io/role/internal-elb" = 1 
 }
}
```
Perform this steps:
```
terraform init
terraform plan
# don't apply yet terraform apply --auto-approve // terraform destroy
```
Here we have created:
```
On plan you can see: ( we already created the vpc )

Elastic IP address
Internet Gateway
NAT Gateway
RTB
Private and Public Subnet
```
### Step 1.2 Provision an EKS-Cluster on that VPC.
Create: `eks-cluster.tf`
```
# defining kubernetes provider
# this is important so that Terraform can access the cluster on the creds that are defined.
provider "kubernetes" {
  # load_config_file = "false"
  # enpoint of K8s cluster
  host = data.aws_eks_cluster.myapp-cluster.endpoint
  token = data.aws_eks_cluster_auth.myapp-cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}



# ---------- Defining Data -------------#
data "aws_eks_cluster" "myapp-cluster" {
  name =  module.eks.cluster_id
}

data "aws_eks_cluster_auth" "myapp-cluster" {
  name = module.eks.cluster_id
}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.20.0"
  # insert the 7 required variables here

  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.21"

  # provide a vpc id
  vpc_id = module.myapp-vpc.vpc_id

  # list of subnets we want worker node to start in
  # Private: workload to be scheduled
  # Public: Loadbalancer, etc.
  # reference an attribute created by module
  # this is where worker nodes where run:
  subnets = module.myapp-vpc.private_subnets

  tags = {
    environment = "development"
    application = "myapp"
  }

  # worker nodes: we can have:
  # we can have self managed (ec2), semi managed (node group) and managed (fargate)

  # defining worker groups
  # these are self managed
  worker_groups = [
      {
        instance_type =  "m5.large"
        name = "worker-group-1"
        asg_desired_capacity = 3
      }

  ]
}
```
Perform this steps:
```
terraform init
tree .terraform
terraform plan
terraform apply --auto-approve
```

### Step 1.3. Connect to the EKS Cluster using Kubectl
Perform this:
```
aws eks update-kubeconfig --name myapp-eks-cluster --region us-east-1
kubectl get node
kubectl get pod
kubectl cluster-info
kubectl cluster-info dump
```
### What resource are created?
```
-   Elastic IP address
-   Internet Gateway
-   NAT Gateway
-   RTB
-   Private and Public Subnet
-   LoadBalancers in AWS console under EC2
-   You can see that the LBs are available on all three AZ which is HA.
-   Also remember again that you have Private subnet in Workloads.
-   And Public subnets in Load Balancer.
```
## Step 2. Installing Nginx Ingress, Cert Manager, Grafana, Prometheus

```
##### ------- Removing all components ---------#
kubectl get nodes
kubectl delete --all pods --all-namespaces
kubectl delete --all deployments --all-namespaces
kubectl delete --all services --all-namespaces
kubectl delete --all secrets --all-namespaces
kubectl delete --all certificates --all-namespaces
kubectl delete --all namespaces --all-namespaces

kubectl get ns
kubectl delete all --all -n {namespace}
```
### Step 2.1 Install Nginx
First method: Using HELM
```
kubectl create namespace nginx-ingress
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install my-release nginx-stable/nginx-ingress --namespace nginx-ingress
kubectl -n nginx-ingress get services
```
OR Second Method: Using YAML config
```
kubectl apply -f nginx-config.yaml
```
```
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

Possible errors

```
ping a0f31b2919a48443cb2c755d0a553bfe-831965207.us-east-1.elb.amazonaws.com
DONT COPY THE OUTPUT IN CLI, GO TO AWS -> EC2 -> LOADBALANCERS
THIS GIVE ME HOURS OF HEADACHE

DNS_PROBE_FINISHED_NXDOMAIN
DNS_PROBE_FINISHED_NXDOMAIN
DNS_PROBE_FINISHED_NXDOMAIN

Possible Cache error, so I just use another computer from another country

```

### Step 2.2 Install CertManager
```
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io 
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.15.2 --set installCRDs=true
kubectl -n cert-manager get po
```
### Step 2.3 Create the **ClusterIssuer**
Create: `nano cluster-issuer-prod.yaml`
```
---
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: mananganasher1@gmail.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource used to store the account's private key.
      name: letsencrypt-prod
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
      - http01:
          ingress:
            class: nginx
```
`kubectl apply -f cluster-issuer-prod.yaml`

## Step 3. Install Grafana and Prom
```
kubectl create namespace prom
```
Create: `nano values.yaml`
```
## Using default values from https://github.com/helm/charts/blob/master/stable/grafana/values.yaml
##
grafana:
  enabled: true

  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: "letsencrypt-prod"
    hosts:
      - asherops.ml
    tls:
      - hosts:
          - asherops.ml
        secretName: grafana-tls
```
Peform:
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prom prometheus-community/prometheus -f values.yaml --namespace prom
```
==ugawertwv ertwsrfgwscr

sdas sdf 
dsdf
sdf
f
s
df
dsfs
df
sdf
## Step 2. Installing Cert Manager in your cluster :)
Perform basic checks:
```
aws eks update-kubeconfig --name myapp-eks-cluster --region us-east-1
kubectl config get-contexts
kubectl config use-context CONTEXT_NAME
kubectl cluster-info
kubectl get nodes
kubectl get pods 
```
Perform installation:
```
mkdir -p kubernetes/cert-manager && cd kubernetes/cert-manager
curl -LO https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml

----
curl -LO https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.yaml
 kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
-----


mv cert-manager.yaml cert-manager-1.5.3.yaml

kubectl create ns cert-manager
kubectl apply --validate=false -f cert-manager-1.5.3.yaml
kubectl -n cert-manager get all
```
Perform trobleshooting:
```
kubectl describe pod my-nginx-86459cfc9f-2j5bq
```
## Step 3. Hook CertManager to a CA Authority
We need to make use of **issuers.**
```
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```
### Step 3.1 Check if cert manager works:
```
kubectl create ns cert-manager-test
```
Create: `issuer.yaml`
```
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: test-selfsigned
  namespace: cert-manager-test
spec:
  selfSigned: {}
```
Perform: `kubectl apply -f issuer.yaml`
<br>
Repeat steps with `certificate.yaml`
Create: `certificate.yaml`
```
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: selfsigned-cert
  namespace: cert-manager-test
spec:
  dnsNames:
    - asherops.ml
  secretName: selfsigned-cert-tls
  issuerRef:
    name: test-selfsigned
```
Perform: `kubectl apply -f certificate.yaml --namespace cert-manager-test`
Perform: `kubectl get secrets -n cert-manager-test`
Perform: `kubectl describe certificate -n cert-manager-test`
```
kubectl describe certificate -n cert-manager-test
```
### Step 3: Create Ingress controller to validate ACME traffic ( from external connection
```
kubectl create ns ingress-nginx
kubectl -n ingress-nginx apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.3/deploy/static/provider/cloud/deploy.yaml

kubectl -n ingress-nginx get pods
kubectl -n ingress-nginx get svc

 kubectl -n ingress-nginx --address 0.0.0.0 port-forward svc/ingress-nginx-controller 80
 kubectl -n ingress-nginx --address 0.0.0.0 port-forward svc/ingress-nginx-controller 443
```
**Later: Set your domain pointing to an A or NS record for the Address of the EKS  API server endpoint**
Create: `cert-issuer-nginx-ingress.yaml`
```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-cluster-issuer
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: asher@asher.com
    privateKeySecretRef:
      name: letsencrypt-cluster-issuer-key
    solvers:
    - http01:
       ingress:
         class: nginx
```
Perform: `kubectl apply -f cert-issuer-nginx-ingress.yaml`
Perform: `kubectl describe clusterissuer letsencrypt-cluster-issuer`
To delete: `kubectl delete  clusterissuer letsencrypt-cluster-issuer`

```
cert-manager  Error initializing issuer: context deadline exceeded

```
## Step 4. Deploy an Example App that uses SSL to see if it is working
Create: `deployment.yaml`
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

### Step 4.1: To expose this app, you need to create a service
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

### Optional: Set Up port forwarding
```
kubectl port-forward svc/example-service 5000:80
ctrl A + D => using screen

curl localhost:5000
```
### Step 4.2: To expose this app on ingress, you need to deploy an ingress object
Create: `ingress.yaml`
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


<br>

Create: `certificate.yaml`
```
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-app
  namespace: default
spec:
  dnsNames:
    - asherops.ml
  secretName: example-app-tls
  issuerRef:
    name: letsencrypt-cluster-issuer
    kind: ClusterIssuer
```
Perform: `kubectl apply -f certificate.yaml`
Perform: `kubectl describe certificate example-app`
Perform: `kubectl get secrets`
Perform: `kubectl apply -f ingress.yaml`

# Check for Progress
```
kubectl describe certificate example-app
kubectl get secrets
```


# Using HELM Chart Package Manager

```
kubectl create namespace nginx-ingress
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install my-release nginx-stable/nginx-ingress

```
