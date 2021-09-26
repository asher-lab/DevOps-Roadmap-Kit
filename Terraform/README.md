# 🧜🏼‍♂️ Terraform
![](https://miro.medium.com/max/480/1*9FQVJwRJrzPDncseivWmKg.png)
## Introduction

**Make sure that the credentials have appropriate permissions to create resources.**


What is Terraform?
Allow you to automate your infrastructure.
- Declarative = define WHAT you want, no need to know the process. You define the end state.
- Adjust the old config file, rather than giving instructions

Things are:
1. Provisioning Infrasture
- create VPC
- install Docker correct version
2. Deploying Application
- create app

**Terraform vs Ansible**
They are both infrastructure as a code. Terraform is mainly infrastructure provisioning tool. More advanced in infrastructure. Ansible is mainly for configuration tool where you can install apps in there. 

**Managing existing infrastructure**
- Terraform automated the changes in your infrastructure.

**Replicating Infrastructure**
- set up the same code, (e.g. in your development environment to production )

## How does Terraform works?
2 main components:

**1. CORE**
- Plan: What needs to be done to be to reach on the desire state?
- 2 input sources: TF-Config ( Desired ) & State ( Current )
- Core creates execution plan. then...

**2. PROVIDERS**
- uses providers to carry out the execution states.
- AWS | AZURE
- Kubernetes
- Fastly
- Through provider you get access to a lot of resources. 

Example Configuration Files
```
# Configure the aws provider
provider "aws" {
	version = "~> 2.0"
	region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "example" {
	cidr_block = "10.0.0.0/16"
}
```
***Different stages | commands***
```
A. refresh = query infrastructure provider to get current state
B. plan = create an execution plan, just preview, no changes
C. apply = execute the plan
D. destroy = destroy the whole setup
```

**Key Takeaways**
- Tool for creating and configurating infrastructure
- Universal IaC tool ( can be used on many cloud providers )
- So, you don't need to learn all tools like Cloudformation.


# 🧜🏼‍♂️ Install Terraform 

Install Terraform
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

terraform -v 
```

# Providers

- Translate your TF configuration where the provider can understand. Take your instruction. 
- They wanted to be integrated with Terraform so users can be able to use it.

# Demo
1. Create a folder and main.tf file for best look.
```
mkdir terraform
cd terraform
```
2. main.tf
- Do remember not to hard code, since we will check in the terraform configuration into git.
- You told TF to use AWS with these credentials.
- Also, when we define a provider, we gonna install its dependencies. `terraform init`
```
provider "aws" {
	region = "us-east-1"
	access_key = "ASIARUAMG3TZEY3FCNUI"
	secret_key = "47DP+yf/iBtbYxA4PepacQCx59Q2eu8xfDEeEHFm"
	token="FwoGZXIvYXdzEOD//////////wEaDJIAB5/UTCBs3/IR/CLJAXFY+8Naw2d9NgFXt11tTj/9HKuU4X7rtNg6DE09i8N7+cFgRT3B6OED1Op5lzmKOZ0sWp90CkeozsncqXZ1FnNZBwiosYsh6w7eBVfbf+TpS0V73nuDTIL177PzZAgtxB+bNYHi7vjQJNxvv3QhbbaqgPr07SFrNePb/aKNU2QBjUTnviilAYi2WHABZT7Ce91Okmf4H6W+pZn5/A4F24gvvrDCcTL7I2+vY/qnTzIh4LRnoZaunx+rz6h2f/RavwVDvrjsQnxPryj0jrSKBjIt5sW8ALDnm62uwR3MuVlSaUB5d6nHIZfikEhyC489BEaK0poSTOlXo3nfuykx"
}
```
terraform init
```

Terraform has been successfully initialized! 

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```
This created two hidden files and a folder
- Provider gives us all API access.

# Resources and Data Sources
All of anything you wanted to get access to must be defined in .tf file as `resource`
```
provider "aws" {
	region = "us-east-1"
	access_key = "ASIARUAMG3TZEY3FCNUI"
	secret_key = "47DP+yf/iBtbYxA4PepacQCx59Q2eu8xfDEeEHFm"
	token="FwoGZXIvYXdzEOD//////////wEaDJIAB5/UTCBs3/IR/CLJAXFY+8Naw2d9NgFXt11tTj/9HKuU4X7rtNg6DE09i8N7+cFgRT3B6OED1Op5lzmKOZ0sWp90CkeozsncqXZ1FnNZBwiosYsh6w7eBVfbf+TpS0V73nuDTIL177PzZAgtxB+bNYHi7vjQJNxvv3QhbbaqgPr07SFrNePb/aKNU2QBjUTnviilAYi2WHABZT7Ce91Okmf4H6W+pZn5/A4F24gvvrDCcTL7I2+vY/qnTzIh4LRnoZaunx+rz6h2f/RavwVDvrjsQnxPryj0jrSKBjIt5sW8ALDnm62uwR3MuVlSaUB5d6nHIZfikEhyC489BEaK0poSTOlXo3nfuykx"
}


# resource <aws_what> <name>
resource "aws_vpc" "development-vpc" {
    cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id # referencing a resource that doesn't exists yet.
    cidr_block = "10.0.10.0/24"
    availability_zone = "us-east-1a"
}
```
`terraform apply`

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

**Data Sources**
```
provider "aws" {
	region = "us-east-1"
	access_key = "ASIARUAMG3TZEY3FCNUI"
	secret_key = "47DP+yf/iBtbYxA4PepacQCx59Q2eu8xfDEeEHFm"
	token="FwoGZXIvYXdzEOD//////////wEaDJIAB5/UTCBs3/IR/CLJAXFY+8Naw2d9NgFXt11tTj/9HKuU4X7rtNg6DE09i8N7+cFgRT3B6OED1Op5lzmKOZ0sWp90CkeozsncqXZ1FnNZBwiosYsh6w7eBVfbf+TpS0V73nuDTIL177PzZAgtxB+bNYHi7vjQJNxvv3QhbbaqgPr07SFrNePb/aKNU2QBjUTnviilAYi2WHABZT7Ce91Okmf4H6W+pZn5/A4F24gvvrDCcTL7I2+vY/qnTzIh4LRnoZaunx+rz6h2f/RavwVDvrjsQnxPryj0jrSKBjIt5sW8ALDnm62uwR3MuVlSaUB5d6nHIZfikEhyC489BEaK0poSTOlXo3nfuykx"
}


# resource <aws_what> <name>
resource "aws_vpc" "development-vpc" {
    cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id # referencing a resource that doesn't exists yet.
    cidr_block = "10.0.10.0/24"
    availability_zone = "us-east-1a"
}

# data lets you query existing resource in AWS in used it as an object

# here we wanted to query the default vpc.
#
data "aws_vpc" "existing_vpc" {
    default=true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id # referencing a resource that does exists yet.
    cidr_block = "172.31.80.0/20"
    availability_zone = "us-east-1a"
}
```
`terraform apply`

# Change and Destroying TF resources
`terraform apply`
`
'~' is for changing a resource
'+' is for creating a resource
'-' is for removing a resource

# Removing a resource.
1. You can just remove that in tf config then apply. 
2. `terraform destroy -target aws_subnet.dev-subnet-2` 
`terraform destroy -target resource.name`

Best practice is: Apply the configuration file, because using destroy, it will still leave you the default config.  Especially when  working in a team

# More terraform commands
1.  Preview without actually applying it.
```
terraform plan
```
2. `terraform apply -auto-approve` will apply it without confirmation
3. `terraform destroy` will remove resources one by one in correct order. Useful to revert back on your initial state. 

# Terraform State
Is where terraform get all of the data, and historical accounts for it. 
.tfstate
.tfstate.backup

Also one can do , `terraform state`
```
terraform state list
terraform state show < on list >
terraform pull
```
Like for example getting the ARN.

# Terraform Output
- handy if you need the values, no need to show for state list   command.
```
provider "aws" {
	region = "us-east-1"
	access_key = "ASIARUAMG3TZE2PYYRKL"
	secret_key = "5jTeRT4TAqMAWiuBnFcpXPbSL94n4gjV0asNL5r3"
	token="FwoGZXIvYXdzEOj//////////wEaDPuJQhpom3mTndDZzyLJATK2tXT3CyG2ALFoP5ittoxRtAhwbf7Vm6trsI4DYSnR4uNJyMADu33SlgD+YWdg9DabS1fE9+BzNRoYlhwJbG3vKEv0auEd5jJIE14lCGZK2/IX6p2gv1w1FDMtPNBfLPUxlQvhpzcjoT+7pQMhCcqrmwXIBu8Zof08QeBjz0ooUl29Hmexhb3/ci+eNneiRvuInHlhQR4yFcJBFOc55UzBjH4S3PqrV1KyavRbXrHlVZ+rv3u9hAXEaGO0sy5pb0dZ+klLfNygJCjn3rWKBjIt54XOXdY/rr7K8LlJXWlhoO+Vanur1iPKKSOeQA7LUPVsYeFHcBUN3FRRieGr"
}


# resource <aws_what> <name>
resource "aws_vpc" "development-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name: "development"
    }
}


resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id # referencing a resource that doesn't exists yet.
    cidr_block = "10.0.10.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name: "subnet-1-development",
        vpc-env: "dev"
    }
    
}

# data lets you query existing resource in AWS in used it as an object

# here we wanted to query the default vpc.
#
data "aws_vpc" "existing_vpc" {
    default=true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id # referencing a resource that does exists yet.
    cidr_block = "172.31.80.0/20"
    availability_zone = "us-east-1a"

    tags = {
        Name: "subnet-1-default"
    }
    
  
}
```

# Variables in Terraform
- variables here are like function arguments
- 3 ways of assigning variable:
- 1. It can be prompted. Especially it is not defined yet.
- 2. Pass the argument in CLI when doing `terraform apply`
```
terraform apply -var "subnet_cidr_block=172.31.80.0/20"
```
3. Third method is having a variables file known as `.tfvars` Here you can defined key value pairs
```
nano terraform.tfvars
```

```
subnet_cidr_block = "172.31.80.0/20"
```
- best use case is to have one variables file in different environments.
- pass none `terraform.tfvars` as `terraform apply -vars-file terraform-dev.tfvars`
- a default value can be in parameters, if it can't find any custom one.
- also you can declare `type = string` so it will know what type is needed on that block. (e.g. boolean , string, integer etc. )
- e.g. `list(string)`
```
in tfvars
cidr_block = ["10.0.20.0/24", "10.0.30.0/24"]

then reference either first or second via simple lists syntax
var.cidr_block[0] or var.cidr_block[1]


can also be:
type = list(object({
	cidr_block=string
	name=string
	}))

- use case, when team is working, you need to restrict what they are gonna put here.


tfvars contains:

cidr_block = [
	{cidr_block = "10.0.0.0.16", name = "dev-vpc"},
	{cidr_block = "10.0.18.0/24", name = "dev-subnet"
]

then reference via:

cidr_block = var.cidr_block[1].cidr_block
Name: var.cidr_block[1].name
```


# Environmental Variables
- We should not hard code the credentials:
- Two ways to set the credentials:
- First One, you can set it as env variables
```
export AWS_SECRET_ACCESS_KEY
export AWS_SECRET_KEY_ID
export AWS_SESSION_TOKEN
```

Second way:
- Problem when you are switch from another terminal, since they are only accessible on context. Else you need to configure it in ls ~/.aws/credentials to become available on all terminal. Terraform can pick this up. It can use the credentials in `.aws/credentials`

Third Way:
- Reference it via TF_VAR
```
export TF_VAR_avail_zone="eu-west-3a"

Here you saying that TF_VAR is what terraform will look up and avail_zone be the one to be used.


reference inside tf file

var avail_zone {}
then
availability_zone = var.avail_zone
```
##### How on earth does using environmental variables makes the credentials safe?
https://stackoverflow.com/questions/12461484/is-it-secure-to-store-passwords-as-environment-variables-rather-than-as-plain-t

# Creating a Git repo for a Terraform proj
```
git init
git remote add origin https://gitlab.com/asher-lab/terraform-learn.git

# doesnt have to be part of the code
nano .gitignore

inside:
----------
# local .terraform dir
.terraform/*

#tf state files
*.tfstate
*.tfstate.*

#tf vars may inclue senstive info
*.tfvars

---------
git add .
git commit -m "Initial commit"
git push -u origin master
git push -u origin main
```

# Automate Provisioning of EC2 instance with terraform
**Here we:**
1. Create custom VPC.
2. Create Custom Subnet in one availability Zone.
3. Connect this VPC via internet gateway to allow the traffic, by creating route table and internet gateway.
4. Inside the subnet, we gonna deploy our ec2 instance
5. Deploy nginx docker container
6. Create security group (firewall)
7. We open here port 22 and the nginx docker port. 8080

Best practice: Create entire infrastructure from scratch, leaving the default by AWS.

## Creating our own VPC
main.tf
```
# declare the provider
provider "aws" {
	region = "us-east-1"
}

# Assigning variables
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}


# Creating VPC
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

# Creating subnet
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}
```
terraform.tfvars
```
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.10.0/24"
avail_zone = "us-east-1a"
env_prefix = "dev"
instance_type = "m5.large"
```
Then perform this command:
```
terraform plan
terraform apply --auto-approve
```
- Inspect what has AWS generated for you via VPC.
- ROUTE TABLE is generated. It is a virtual router in your VPC.  Helps you route subnet. Helps you route multiple VPC. By default it has not igw ( internet gateway as its target )
- NETWORK ACL is a firewall configuration for our VPC. By default it is open by default.
- Internet Gateway is your default modem in your VPC that helps you connect to the internet.
Trivia: Terraform know what sequence is need in order to create the resources. So even you define it at the end, it will still create it.
```
# declare the provider
provider "aws" {
    region = "us-east-1"
}

# Assigning variables
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}


# Creating VPC
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

# Creating subnet
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

# Create route table with rule for igw
resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    
    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}

# Create Internet gateway
resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id

    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

```
Then perform this command:

```
terraform plan
terraform apply --auto-approve
```

##### Best practice: Custom Subnet Association with our route table
```
# Associating a subnet to our route table
resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id =  aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
}
```
#### Default Subnet Association with our route table (optional)
```
Get the data by typing the following cmd:

terraform state show aws_vpc.myapp-vpc
```
```
# Associating it to default rtb
resource "aws_default_route_table" "main-rtb" {
	default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
	 route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    
    tags = {
        Name: "${var.env_prefix}-main-rtb"
    }
}
```

#### Creating Security Group
```
# declare the provider
provider "aws" {
    region = "us-east-1"
}

# Assigning variables
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}


# Creating VPC
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

# Creating subnet
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

# Create route table with rule for igw
resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    
    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}

# Create Internet gateway
resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id

    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

# Associating a subnet to our route table
resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id =  aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
}


# Creating security group
resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc.id

    # incoming traffic rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        # who can access these ports:
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        # who can access these ports:
        cidr_blocks = ["0.0.0.0/0"]
    }


    # outgoing traffic rules , like fecthing data from internet.
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        # who can access these ports:
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.env_prefix}-sg"
    }
}
```
Then perform this command:

```
terraform plan
terraform apply --auto-approve
```
## Creating an AWS EC2 instance
```
# declare the provider
provider "aws" {
    region = "us-east-1"
}

# Assigning variables
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable instance_type {}

# Creating VPC
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

# Creating subnet
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

# Create route table with rule for igw
resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    
    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}

# Create Internet gateway
resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id

    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

# Associating a subnet to our route table
resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id =  aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
}


# Creating security group
resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc.id

    # incoming traffic rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        # who can access these ports:
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        # who can access these ports:
        cidr_blocks = ["0.0.0.0/0"]
    }


    # outgoing traffic rules , like fecthing data from internet.
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        # who can access these ports:
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.env_prefix}-sg"
    }
}

# fetch ami ID from aws_vpc
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }

    filter {
    name   = "virtualization-type"
    values = ["hvm"]
    }


}

output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec2_public_ip" {
    value = aws_instance.myapp-server.public_ip
}


# Creating AWS EC2 instance
resource "aws_instance" "myapp-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type

    # getting the ec2 associated with the vpc, subnetid, aws_security_group
    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone

    # associate public ip address
    associate_public_ip_address = true

    # create a key pair and associate
    key_name = "tutorialTF"

    tags = {
        Name = "${var.env_prefix}-server"
    }

}    
 
# creating key pair ? best practice 

/*
resource "aws_key_pair" "ssh-key" {
    key_name = "server-key"
    # public_key = "ssh-rsa Asassd asa@gmaias.vom"
    # public_key = var.my_public_ip
    # public_key = "${file(var.publick_key_location)}""
}*/
```
Then perform this command:

```
terraform plan
terraform apply --auto-approve
```
#### Automating SSH key pair assoc.
```
ssh-keygen
ls .ssh/id_rsa
then get the id_rsa.pub locally
cat .ssh/id_rsa.pub

then paste it terraform
```
the private key there is `id_rsa` located with .ssh/id_rsa
- meaning you can associate an existing private key on your instance

ssh -i ~/.ssh/id_rsa ec2-user@ip
```
/*
resource "aws_key_pair" "ssh-key" {
    key_name = "server-key"
    # public_key = "ssh-rsa Asassd asa@gmaias.vom"
    # public_key = var.my_public_ip
    # public_key = "${file(var.publick_key_location)}""
}*/
```
- If you change the key, it will create a new resource.
- Terraform is useful when you are destroying / clean up
- Terraform replication of environment. From staging to deployment
