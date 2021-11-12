## Implementations of HELM Projects without using HELM
## (Manual Way of Provisioning)

```

kubectl -n ingress-nginx apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.3/deploy/static/provider/cloud/deploy.yaml
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.5.3 --set installCRDs=true
kubectl create -f issuer.yaml




kubectl describe clusterissuer letsencrypt-prod

kubectl apply -f postgres-secrets.yml
kubectl apply -f postgres-storage.yaml

kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml

kubectl apply -f sonar-pv-data.yml
kubectl apply -f sonar-pv-extensions.yml
kubectl apply -f sonar-pvc-data.yml
kubectl apply -f sonar-pvc-extentions.yml

kubectl apply -f sonar-configmap.yaml

kubectl apply -f sonar-deployment.yml
kubectl apply -f sonar-service.yml

k get ingress
k get svc

kubectl apply -f ingress.yaml

(get ingress here the DNS do it fast)

k get certificate
kubectl apply -f certificate.yaml

```