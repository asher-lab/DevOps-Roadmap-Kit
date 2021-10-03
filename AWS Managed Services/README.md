It is a rule to be cost effective in choosing what services you need provisions, given your pool of customers.

(e.g. Using EKS not a viable option on small companies )

# What does Lightsail offers?
- VPS
- SSD-based Storage
- Networking and Data transfer
- DNS Management
- Static IP
- Access to AWS Services
- Free SSL Certificate 
- Full Managed Database
- Automated Health Checks
- **Come bundle with a low, good price.**
## How to I grow applications on Lightsail
- Upgrade Lightsail instance
	 - Using bigger instances to scale performances
- Add Lightsail load balancers
	- Add horizantal scalability and enable redundancy.
- Connect multiple Instances
	- Build Applications with distributed workloads.
- Create redundancy
	- Run instances across multiple availability zones.
- Add features and capabilities
	- Access AWS services using VPC peering and public endpoints.

# Deploying a wordpress instance on Lightsail
1. Navigate to Lightsail landing page.
2. Create Instance
3. Select Platform and Instance Location where it will run. 
- Linux
- Select AZ
- Wordpress ( Select blue print ) OS only or OS + App.
- Choose Instance Plan ( PREDICTABLE PRICING!! )
- Choose $10 with 3 months free .
4. To access the instance you can make use of your own SSH keys
5. Click Create. Then wait.
```
Defining the VPC
EBS
Defining ports and SG
```

Now we perform some best practice:
1 . Assign Static IP via networking.
2 . Manage WP, get password
```
= ssh into instance 
ls
cat bitnami_application_password 
```
3 . Then Navigate to `ipaddress/admin`. Enter user and password.
```
user:password
```

 #  WordPress and GitHub Integration – Live and Local Environment
  #  AWS Codepipeline | CI CD for wordpress
 # Integrating Lightsail instance (WP)  to LoadBalancers
 # Integrating Lightsail instance (WP) to Aurora Database
 # Integrating Lightsail to Git
