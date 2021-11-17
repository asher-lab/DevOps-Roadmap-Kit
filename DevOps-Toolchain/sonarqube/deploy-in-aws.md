

## Provision SonarQube using HELM on EKS with AWS Managed Postgres and AWS SSO

 
**Possible Error that one may encounter in K8S in AWS:**
```
error: Waiting for HTTP-01 challenge propagation: failed to perform self check GET request
'http://sonarqube.wecare4u.tk/.well-known/acme-challenge/fYR_fPxsyIQPwSpThR9Ak1fJ1DDUoP-g1RrUAVv8nPU': 
Get "http://sonarqube.wecare4u.tk/.well-known/acme-challenge/fYR_fPxsyIQPwSpThR9Ak1fJ1DDUoP-g1RrUAVv8nPU": 
dial tcp: lookup sonarqube.wecare4u.tk on 10.100.0.10:53: no such host
Answer is this: https://stackoverflow.com/questions/33893150/dial-tcp-lookup-xxx-xxx-xxx-xxx-no-such-host
I try changing the nameservers. 8.8.8.8
But after 41 requested, then 14 minutes lates like. 27 minutes before issued.
kubectl exec -it --namespace sonarqube sonarqube-sonarqube-0 bash 
kubectl exec -it -u root --namespace sonarqube sonarqube-sonarqube-0 bash 
 ```


 ```
 Prepare Access keys /  Add some credentials:
    aws configure
    create a new user and group if there seems to be a problem
 ```
 ```
 Create a cluster:
    using eksctl prefarbly, config is shown below
```

```
eksctl create cluster \
--name asher-helm-cluster \
--version 1.21 \
--region us-east-2 \
--zones us-east-2a,us-east-2b \
--nodegroup-name asher-nodes \
--node-type m5.large \
--nodes 2 \
--nodes-min 2 \
--nodes-max 2 
```


```
 Add Nodes to the cluster:
    - Instance
    - Group
 ```
 ```
 Connect using kube config:
    created my own eks policy
    aws eks --region us-east-2 update-kubeconfig --name asher-helm-cluster
 ```   

```    
    Prepare:
    external db ( postgres db) 
    dns: wecare4u.tk
  
    
    Install Application using helm:
    cert-manager -> issuer -> sonarqube -> k get ingress -> delete validating web hook
 ```

```
kubectl get ValidatingWebhookConfiguration
kubectl delete ValidatingWebhookConfiguration sonarqube-ingress-nginx-admission
```
```
    k get ingress:
        Change the DNS settings
        k get certificates  -n sonarqube 
```
```
 I need configure postgres  managed:
    Managed PostGres
 I need configure the ADD version:
    AWS SSO
 I need to route:
    DNS change
    ```
    
 Clean Up:
    Delete other policy / users / roles
    Check other region if there are eks cluster just to be sure
    Main cleaning:
        delete eks
        delete nodes
        delete postgres
        remove sso
        remove loadbalance
        remove ec2 or fargate instances
        clean dns setting
    
