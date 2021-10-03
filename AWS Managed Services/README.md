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
  
 # Lightsail instance (WP)  to LoadBalancers
 LB - cost 18 usd a month.
 **Hmmm.. How can we automate this, auto add or stop , remove instances**
 Goal: Adding LoadBalancers to instances.
  On this example, we perform:
- There is the same instance and content on each instance ( wordpress ).
- Domain name pointing to Load Balancer.
- Updating DNS and Doing HTTPS certificate on LB, since it is required.
- Instance be deployed in different AZ.
- Importance: You can upgrade and take down one instance, LB will still take care of it. **Detached.**

###  A.  Important that your instanceS be connected on the Database.
  1. Connect to instance.
  2. In WP settings, check wp-config.php
```
Enter the db password that was assigned to LS.
/** MYSQL database password **/
/** MYSQL database user **/
/** MYSQL database name**/
/** MYSQL database hostname / aka endpoint **/
```
**- This is important, so when you spin up a new instance then they are pointing out to the same instances. ( same wp-config.php )**

### B. Setting up DNS 
1. Create a DNS zone.
```
Enter the domain name
```
2. Copy the NS from AWS, then copy it on godaddy, namecheap or route 53.
3. Check for DNS propagation
### C. Setting up the Certificate
1. Go to networking tab in AWS.
2. Under dns zone. Add A record. 
```
A record
@
Resolves to LoadBalancer

A record
www
Resolves to LoadBalancer
```
3. Set certificate to route traffic from LB to Instances

```
= Go to Networking Tab 
= Manage Load Balancer
= Route Inbound Traffic both HTTP and HTTPS
Understand that:
- Traffic from viewer to LB is HTTPS. Encrypted.
- Traffic from LB to instances is HTTP. Since it is internal and there is no public traffic
= Create a certificate. Create
= Networking Tab. Then Manage DNS zone for domain, then create C record. ( C record is given when you create a certificate ) , can took 5 minutes to do it. 
```
### D. Attaching and Detaching from LB
### E. Snapshots
1. Go to One instance.
2. Manage snapshots on an instance.
3. Create a new instance of that snapshot.
4. Now it is completely up and running!!!


**LB will know if it full, because we have metrics**
5. Load Balancer, then attached on the LB.

Useful Links: In enabling HTTPS
 - https://lightsail.aws.amazon.com/ls/docs/en_us/articles/understanding-tls-ssl-certificates-in-lightsail-https
 - https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-create-a-distribution-certificate

 # Integrating Lightsail instance (WP) to Aurora Database
 # Integrating Lightsail to Git
