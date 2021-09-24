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
