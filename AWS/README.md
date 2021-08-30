# AWS
Scope of a service:
1. Global (Route 53, IAM, Billing)
2. Region (S3, VPC, DynamoDB) 
3. Availability Zone ( EC2, EBS, RDS)


IAM ( Identity Access Management)

1. User = Human/System User
2. Group = Collection of users with common themes (e.g. intern group, devops group, admin group)
3. Roles = Collection of Policies/Permissions  (e.g DynamoBasicWrite, Dynamobasicread) permissions that can be associated to an AWS (user or service) ==  (identity or resources)  . A policy is an object in AWS that, when associated with an identity or resource, defines their permissions. For which the role you create can be associated to a service. Not user. 
4. Policies / Permissions 

 ![](https://i.imgur.com/KMWaYEW.png)
 **The above is just an example, in reality we cannot assign policies directly into services or identities. That's why we need to create roles for it.**

 1.  Assign role to AWS Service
 2.  Attach Policies to that Role.
<br>

### Best practice is to create an admin user, not use root account after account creation and implement least privilege.  Assign to admins group and give it a role.

# VPC Structure
![](https://miro.medium.com/max/1400/1*bGOy-meClkVOmcQGX8V-kw.png)

## VPC
-  spans all region.
- act as own isolated network in the cloud.
- virtual representation of network infrastructure
## SUBNET
- Network inside of a VPC.
- Can be private or public subnet.
- If you want to make a subnet private, you will block all the incoming connection.
- To access, a private subnet you need to know the internal IP, because internal IP spans across the subnet. And your applications (AWS services/resources) can access it. Internal IP is what allow services to talk with each other inside your VPC.
- Creating an allocated subnet? You can divide it: https://www.davidc.net/sites/default/subnets/subnets.html
## EC2
- When you create a compute machine, it will be given both a public ip AND an internal IP that comes from the CIDR block (internal ip) (Size can range to a billion to : also can be 65000 ) example. 172.1.0.0/16 has 65k+ ip.
## Internet Gateway
- Connects the VPC to the outside of the internet.
## NACL
- is implemented at the subnet level
## Security Group
- is implemented at the instance level

## CIDR Block (Classless interdomain routing)
- Range of IP address
- The lower the '/32, /16, .. /1' the higher the number of available IP.
- Example: /16 = 65536

## NAT 
- Many Devices in one IP, to solve the issue of IP exhaustion

## Dockerfile Syntax
```
EXPOSE can be used when hiding ports from docker ps.
IF NOT enabled, then docker ps -a will show no port.
IF TRUE, enabled, then docker ps -a will show port
```

# Project : Deploy Image from DockerHub to EC2 instance so it will run on that instance. Via Jenkins. Part 1
Architecture: <br>
Build App -> Build Image -> Push to Private Repo -> Deploy it to EC2

Steps:

1. Run all necessary tools
```

sudo systemctl start docker
docker rm -f $(docker ps -a -q)
chmod 666 /var/run/docker.sock

docker rmi -f $(docker images -a -q)


#-------DOCKER RUN JENKINS---------- #

docker run -p 8080:8080 -p 5000:5000 -d \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $(which docker):/usr/bin/docker \
jenkins/jenkins:lts
```
2. Set up the Jenkinsfile on your repo. Let's test via Multibranch pipeline.

`Jenkinsfile`
```
pipeline {
    agent any
	tools { 
		maven 'maven-3.8.2'
	}
	
    stages {
	

		stage("test") {
			steps {
				script {
					echo "Testing the code.."
					sh 'mvn test'
				}
			}
		}

		
		stage("build jar") {
			steps {
				script {
					echo "Bulding the application.."
					sh 'mvn package'
				}
			}
		}

		stage("build image") {
			steps {
				script {
					echo "Building docker image.."	
					withCredentials([usernamePassword(credentialsId: 'dockerhub-asherlab', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]){
					
						sh 'docker build -t java-maven-app:jma-2.2 .'
						sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
						sh 'docker tag java-maven-app:jma-2.2 asherlab/java-maven-app:jma-2.2'
						sh 'docker push asherlab/java-maven-app:jma-2.2'
				   }
			   }	
			}
		}

	stage("deploy") {
				steps {
					script {
						echo "Deploying the package.."					
					}
				}
			}
}
}
```
3. Install SSH Agent plugin via Jenkins.
4. Add credentials of the EC2 instance in the scope of the multibranch pipeline only.
5. Add generated syntax on the block inside the script block. ( Pipeline Syntax )  && Add docker run command.
```
sshagent(['EC2-Creds']) {
    // some block
}
```
So Jenkins file will be changed to:

`Jenkinsfile`
```
pipeline {
    agent any
	tools { 
		maven 'maven-3.8.2'
	}
	
    stages {
	

		stage("test") {
			steps {
				script {
					echo "Testing the code.."
					sh 'mvn test'
				}
			}
		}

		
		stage("build jar") {
			steps {
				script {
					echo "Bulding the application.."
					sh 'mvn package'
				}
			}
		}

		stage("build image") {
			steps {
				script {
					echo "Building docker image.."	
					withCredentials([usernamePassword(credentialsId: 'dockerhub-asherlab', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]){
					
						sh 'docker build -t java-maven-app:jma-2.2 .'
						sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
						sh 'docker tag java-maven-app:jma-2.2 asherlab/java-maven-app:jma-2.2'
						sh 'docker push asherlab/java-maven-app:jma-2.2'
				   }
			   }	
			}
		}

	stage("deploy") {
				steps {
					script {
					def dockerCmd = 'docker run -p 3000:3080 asherlab/java-maven-app:jma-2.2 -d'
					echo "Deploying the package.."
					sshagent(['EC2-Creds']) { 
					// some block 
					sh "ssh -o StrictHostKeyChecking=no ec2-user@34.234.35.40 ${dockerCmd}"
					
					}
										
					}
				}
			}
}
}
```
6. Be sure to login already on your local machine so it will not be a security risk. 
7. Done || As an info, Java Maven runs on port 8080 default when building an app. 


Use case:<br>
Demonstrate that you can deploy docker containers on an EC2. And is good for smaller projects. 

# Project : Deploy Image from DockerHub to EC2 instance so it will run on that instance. Via Jenkins. Part 2

When you want to deploy a full pack of software, like databases, web application, event listener, etc. then you need to make use of docker-compose :<br>
Architecture:<br>
Have docker-compose.yaml in your repo. Then perform command: on jenkins 
 ```

	stage("deploy") {
				steps {
					script {
					def dockerCmd = '```
docker-compose -f docker-compose.yaml up -d
```'
					echo "Deploying the package.."
					sshagent(['EC2-Creds']) { 
					// some block 
					sh "ssh -o StrictHostKeyChecking=no ec2-user@34.234.35.40 ${dockerCmd}"
					
					}
										
					}
				}
	}

```
