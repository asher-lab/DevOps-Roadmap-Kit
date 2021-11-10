# Azure Active Directory

**Back then:** Validation are verified by cross checking to the database which can cause security issues.
- This architecture pose a risk to organization.

**Now** Identity Provider.
Steps:
```
1. Client send the username and password.
2. Azure AD will provide Token
3. Which will then fulfill the request of the client.
```
**Benefits**
4. Centralized user management
5.  top notch security
6. additional features like MFA, conditional access, etc

## Where it can be implemented?
1. Web Resources such as SQL and Virtual Machines
2. Single Sign Ons
3. Applications such as MS Office, OneDrive
4. Custom Web Service

**Example: We can make use of ADD in our web service such as in SonarQube** 


# DEMO PROJECT: Installing SonarQube Using Helm on Azure Kubernetes Service, with SSL on Domain, External PostGres, and Azure AAD 

## 0. Indian Youtube
```
https://www.sumologic.com/blog/kubernetes-deploy-postgres/
Youtube Link here: https://www.youtube.com/watch?v=31igoWxauEQ
https://www.youtube.com/watch?v=Fkui_URpWmQ
https://github.com/VamsiTechTuts/kubernetes/tree/master/sonarqube
```
## 1. We neeed database for SonarQube (PostGres)
```
git clone https://github.com/VamsiTechTuts/kubernetes.git
cd sonarqube
cat postgres-secrets.yaml
```
## Encode USERNAME and PASSWORD of Postgres using following commands:

```
echo -n "postgresadmin" | base64
echo -n "admin123" | base64
```

## Create the Secret using kubectl apply:

```
kubectl apply -f postgres-secrets.yml
```
## Create PV and PVC for Postgres using yaml file:

```
kubectl apply -f postgres-storage.yaml
```

## Deploying Postgres with kubectl apply:

```
kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml
```

## Create PV and PVC for Sonarqube:

```
kubectl apply -f sonar-pv-data.yml
kubectl apply -f sonar-pv-extensions.yml
kubectl apply -f sonar-pvc-data.yml
kubectl apply -f sonar-pvc-extentions.yml
```
## Create configmaps for URL which we use in Sonarqube:

```
kubectl apply -f sonar-configmap.yaml
```

## Deploy Sonarqube:

```
kubectl apply -f sonar-deployment.yml
kubectl apply -f sonar-service.yml
```
## Check secrets:

```
kubectl get secrets
kubectl get configmaps
kubectl get pv
kubectl get pvc
kubectl get deploy
kubectl get pods
kubectl get svc
```
## Default Credentials for Sonarqube:

```
UserName: admin
PassWord: admin

```

[Here](https://github.com/VamsiTechTuts/kubernetes/tree/master/sonarqube#now-we-can-cleanup-by-using-below-commands)

Now we can cleanup by using below commands:

```
kubectl delete deploy postgres sonarqube
kubectl delete svc postgres sonarqube
kubectl delete pvc postgres-pv-claim sonar-data sonar-extensions
kubectl delete pv postgres-pv-volume sonar-pv-data sonar-pv-extensions
kubectl delete configmaps sonar-config
kubectl delete secrets postgres-secrets
```

<br>
<br>

## 2. Configuring External PostGres DB
```
1. https://www.base64encode.org/
2. Ensure the external database is non restrictive for test, like allowing http
```
`postgres-secrets.yaml`
```
---

---
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secrets
type: Opaque
data:
  username: YXNoZXJAYXNoZXIwMTIyMzEyMzRjdnhjdng=
  password: UGFya291ckAxMg==
```
`sonar-configmap.yaml`
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: sonar-config
  labels:
    app: postgres
data:
  url: jdbc:postgresql://asher012231234cvxcvx.postgres.database.azure.com:5432/postgres
```

## 3. Then we run:
```
- Make sure database is set to http for now
```
```
mvn sonar:sonar \
  -Dsonar.projectKey=samples \
  -Dsonar.host.url=http://52.226.235.232/ \
  -Dsonar.login=4ef38e817e87516b5e5c24cb5191f4ba456a0923
  
```
