# Automation with Python
- Really cool automated tasks
- And will up your skill to the market

This course will:
- Automating the Cloud
- Automating tasks using AWS
- Install Boto then connect it to AWS
- Creating a VPC and Subnets using Python
- Difference of Terraform and Python

** Use case is to easily get the details of resources to be used in further manipulation aside from provisioning resources. **
Performing:
1. **Automating tasks around EC2 instances**
- Status Checks of EC2 Instances
- Configure Server: Add Tags to EC2 Instances
- Created automated backup for EC2 volumes
- Restore EC2 volume from backup.
- Write Scheduled tasks for some of this use cases.

**2. Geting information on EKS Cluster**
- This will give us an overview of cluster status, cluster endoint, running kubernetes version, etc.

** This will all be implemented using BOTO**


**3. Website Monitoring and Working with Website in General**
- remote server on linode and run nginx containers in it.
- application program that MONITORS whether the application is up and running. ( Success and Bad Response ).
- Email notification once there is an outage or not accessible. 
- Restart the website the docker container in case something bad happens.
- Restart the server itself if the docker is not responding.
- This is an application of chaos engineering too.


** *"Although writing scripts might be hard, if same use case arrive, you don't need to think and type again, also help other colleagues when facing with same problem."* **

# Installing Boto3
```
aws configure
pip3 install boto3
nano main.py
```
Perform basic process:
Check here for the syntax on describing vpcs:
https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#EC2.Client.describe_vpcs

```
import boto3
ec2_client =  boto3.client('ec2')

#---- print all available vpcs----- #
all_available_vpcs = ec2_client.describe_vpcs()
print(all_available_vpcs)
print("\n")

#----- List the desired output ---- #
vpcs = (all_available_vpcs["Vpcs"])
print(vpcs)
print("\n")

# ----- Perform loop as best practice --- #
# ----- Getting the vpc id ---- #
for vpc in vpcs:
	print(vpc["VpcId"])
	cidr_block_assoc_sets = vpc["CidrBlockAssociationSet"]
	for assoc_set in cidr_block_assoc_sets:
		print(assoc_set)
		print(assoc_set["CidrBlockState"])
```
```
# ------ Connecting to a different region ----- #
# --- Useful for overriding the commands ---- #
ec2_client = boto3.client('ec2', region_name="us-west-1")
```
#### Named Paramters: 
Use case, is not to jumble the passing of the arguments/parameters required by the function. Meaning order of the parameters doesn't matter.
```ex. define divide ( 10, 2), you can define divide ( dividend = 10, divisor = 2)```

#### Client vs Resource
* Client is what makes it easier for you to work with resources.

### Create a VPC and Subnets using Boto Library, versus Terraform 

Check here for the documentation: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#EC2.Client.create_vpc

```
import boto3 
ec2_client = boto3.client('ec2', region_name="us-east-1")
ec2_resource = boto3.resource('ec2', region_name="us-east-1")

# ---- Creating a VPC --- #
# --- Resource creates a resource. Client can get the data of that resource ---#
new_vpc = ec2_resource.create_vpc(CidrBlock='10.0.0.0/16')
new_vpc.create_subnet(CidrBlock='10.0.0.0/24')
new_vpc.create_subnet(CidrBlock='10.0.1.0/24')
new_vpc.create_tags(
    Tags=[
        {
            'Key': 'Name',
            'Value': 'my-vpc'
        },
    ]
)    
```
