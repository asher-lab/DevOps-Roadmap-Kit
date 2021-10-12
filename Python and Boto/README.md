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

all_available_vpcs = ec2_client.describe_vpcs()
vpcs = (all_available_vpcs["Vpcs"])
# ----- Perform loop as best practice --- #
# ----- Getting the vpc id ---- #
for vpc in vpcs:
	print(vpc["VpcId"])
	cidr_block_assoc_sets = vpc["CidrBlockAssociationSet"]
	for assoc_set in cidr_block_assoc_sets:
		print(assoc_set)
		print(assoc_set["CidrBlockState"])   
```

# Terraform vs Python
- TF knows the current state
- Tf know the current state vs your desired state
- TF is idempotent, meaning when you execute things hundred of times you will always get the same results.
- In python when there is an error on the last part of the code, other code above will be executed first before you will see the error.
- In python we have to delete it one by one. We explicitly define it. Also when deleting a VPC there should have no dependencies left for association under it, else it would not let you delete. And that's the use case of terraform since it is idempotent and can understand your instruction. 

**  The Terraform language is declarative, describing an intended goal rather than the steps to reach that goal. **
- Terraform is easier when deploying infrastructure.

# Now the  use cases of Boto3 Python
- More complex logic ( e.g. conditional, like if-else statements)
- Boto is AWS library.
- Doing tasks, monitoring, backup and scheduled tasks.
- ALSO ADD WEB INTERFACE WHERE YOU HAVE THIS BUTTONS TO PERFORM TASK THAT YOU INTENDED TO DO. LIKE BACKUPS MONITORING ETC. DO cleanup, etc.

# Project EC2 server status checks.
- Let's say we have many server like 100, them there is also autoscaling happening, then there is an deletion and addition that is happening. So when it created it is initializing, so see which is running or which is not. So we need to perform status checks on python boto library.

1. Provision ec2 instance using TF.
`main.tf`
```
provider "aws" {
  region = "us-east-1"
}

variable vpc_cidr_block {}
variable subnet_1_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable instance_type {}
variable ssh_key {}
variable my_ip {}

data "aws_ami" "amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ami_id" {
  value = data.aws_ami.amazon-linux-image.id
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
      Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_1_cidr_block
  availability_zone = var.avail_zone
  tags = {
      Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_security_group" "myapp-sg" {
  name   = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
	vpc_id = aws_vpc.myapp-vpc.id
    
    tags = {
     Name = "${var.env_prefix}-internet-gateway"
   }
}

resource "aws_route_table" "myapp-route-table" {
   vpc_id = aws_vpc.myapp-vpc.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.myapp-igw.id
   }

   # default route, mapping VPC CIDR block to "local", created implicitly and cannot be specified.

   tags = {
     Name = "${var.env_prefix}-route-table"
   }
 }

# Associate subnet with Route Table
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "myapp-key"
  public_key = file(var.ssh_key)
}

output "server-ip" {
    value = aws_instance.myapp-server.public_ip
}

resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = "AVmanananganiskolar"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.myapp-sg.id]
  availability_zone			      = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-server"
  }

  user_data = <<EOF
                 #!/bin/bash
                 apt-get update && apt-get install -y docker-ce
                 systemctl start docker
                 usermod -aG docker ec2-user
                 docker run -p 8080:8080 nginx
              EOF
}

resource "aws_instance" "myapp-server-two" {
  ami                         = data.aws_ami.amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = "AVmanananganiskolar"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.myapp-sg.id]
  availability_zone			      = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-server-two"
  }

  user_data = <<EOF
                 #!/bin/bash
                 apt-get update && apt-get install -y docker-ce
                 systemctl start docker
                 usermod -aG docker ec2-user
                 docker run -p 8080:8080 nginx
              EOF
}


resource "aws_instance" "myapp-server-three" {
  ami                         = data.aws_ami.amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = "AVmanananganiskolar"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.myapp-sg.id]
  availability_zone			      = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-server-three"
  }

  user_data = <<EOF
                 #!/bin/bash
                 apt-get update && apt-get install -y docker-ce
                 systemctl start docker
                 usermod -aG docker ec2-user
                 docker run -p 8080:8080 nginx
              EOF
}

```
Generate RSA key pair:  ```$ ssh-keygen```

`terraform.tfvars`
```
vpc_cidr_block = "10.0.0.0/16" 
my_ip = "0.0.0.0/0" 
subnet_1_cidr_block = "10.0.10.0/24" 
image_name = "amzn2-ami-hvm-*-x86_64-gp2" 
public_key_location = "~/.ssh/id_rsa.pub" 
ssh_key = "~/.ssh/id_rsa.pub" 
avail_zone = "us-east-1a" 
env_prefix = "dev" 
instance_type = "t2.micro"
```
- take note to match the region name from your boto config to the tf config.
Then perform:
```
terraform init
terraform plan
terraform apply --auto-approve
```

## Print EC2 Status
```
import boto3 
ec2_client = boto3.client('ec2', region_name="us-east-1")
ec2_resource = boto3.resource('ec2', region_name="us-east-1")

reservations = ec2_client.describe_instances()
#print(reservations)
print("\n")
for reservation in reservations['Reservations']:
	instances = reservation['Instances']
	for instance in instances:
		print(f"Status of instance: {instance['InstanceId']} is {instance['State']}")

# ----- Print EC2 Status Checks ---- #
statuses  =  ec2_client.describe_instance_status()
for status in statuses['InstanceStatuses']:
	ins_status = status["InstanceStatus"]["Status"]
	sys_status = status["SystemStatus"]["Status"]
	print(f"Instance {status['InstanceId']} {ins_status} and system status is {sys_status}")
```


# Write a Scheduled Task in Python 
Goal: Perform EC2 checks every five minutes. 

```
pip3 install schedule
```

```
import boto3 
import schedule 

ec2_client = boto3.client('ec2', region_name="us-east-1")
ec2_resource = boto3.resource('ec2', region_name="us-east-1")

reservations = ec2_client.describe_instances()
#print(reservations)
print("\n")
for reservation in reservations['Reservations']:
	instances = reservation['Instances']
	for instance in instances:
		print(f"Status of instance: {instance['InstanceId']} is {instance['State']}")

def check_instance_status():
	# ----- Print EC2 Status Checks ---- #
	statuses  =  ec2_client.describe_instance_status()
	for status in statuses['InstanceStatuses']:
		ins_status = status["InstanceStatus"]["Status"]
		sys_status = status["SystemStatus"]["Status"]
		print(f"Instance {status['InstanceId']} {ins_status} and system status is {sys_status}")
		
schedule.every(1).seconds.do(check_instance_status)

while True:
	schedule.run_pending()
```

**These are the things that can be done easily:**
```
7 - Configure Server: Add Environment Tags to EC2 Instances 
8 - EKS cluster information 
9 - Backup EC2 Volumes: Automate creating Snapshots 
10 - Automate cleanup of old Snapshots 
11 - Automate restoring EC2 Volume from the Backup 
12 - Handling Errors
13 - Website Monitoring 1: Scheduled Task to Monitor Application Health
14 - Website Monitoring 2: Automated Email Notification 
15 - Website Monitoring 3: Restart Application and Reboot Server
```

So I decided not to pursue with the remaining errors since I understand how will they do.
