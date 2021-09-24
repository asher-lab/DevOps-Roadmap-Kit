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
