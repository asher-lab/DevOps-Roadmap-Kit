# How does cert-manager works?
* It encrypts the  ingress controller  of your cluster.

![](https://www.nginx.com/wp-content/uploads/2020/04/NGINX-Plus-Ingress-Controller-1-7-0_ecosystem.png)


 # What is K8S Ingress Controller?
 - An Ingress controller abstracts away the complexity of Kubernetes application traffic routing and provides a bridge between Kubernetes services and external ones.

# How to use this on your cluster?
1. Step 1: Install cert-manager on your cluster:
`bash run.sh`
2. Step 2: Create ClusterIssuer on your K8s cluster.  , are **Kubernetes resources that represent certificate authorities (CAs) that are able to generate signed certificates by honoring certificate signing requests**.
`kubectl create -f cluster_issuer.yaml`
3. Step 3. Provision your Deployment (e.g Gitlab or SonarQube).
4. Step 4. Get the Ingress Address
`kubectl get ingress -n <namespace>`
5. Step 5. Adjust the DNS Records on your Platform ( Azure, Cloudflare, or FreeNom)