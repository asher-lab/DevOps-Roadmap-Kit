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

# Project : Deploy Image from DockerHub to EC2 instance so it will run on that instance. Via Jenkins. Part 1 = DOCKER RUN

## Details: This will deploy the image on ANOTHER ec2 instance, separate from where you are sshing..  Your development env will test, build, and publish ... while the other machine is used for deploying the app. ( 2 machines) 

## Use case: good for small projects, but if it involves thousands of cointainers, then a tool is  need to orchestrate it.
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
					sh "ssh -o StrictHostKeyChecking=no ec2-user@35.174.172.62 ${dockerCmd}"
					
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

# Project : Deploy Image from DockerHub to EC2 instance so it will run on that instance. Via Jenkins. Part 2 . == DOCKERCOMPOSE . Part of adding docker login to deployment server.

When you want to deploy a full pack of software, like databases, web application, event listener, etc. then you need to make use of docker-compose :<br>
Architecture:<br>
Have docker-compose.yaml in your repo. Then perform command: on jenkins 
 ```

	stage("deploy") {
				steps {
					script {
					def dockerComposeCmd = '```
docker-compose -f docker-compose.yaml up -d
```'
					echo "Deploying the package.."
					sshagent(['EC2-Creds']) { 
					// some block 
					sh "scp docker-compose.yaml ec2-user@ip://home/ec2-user"
					sh "ssh -o StrictHostKeyChecking=no ec2-user@35.174.172.62 ${dockerComposeCmd}"
					
					}
										
					}
				}
	}

```
Jenkinsfile below:
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
				
				//login on remote server (ec2 - deployment server) so it can access the repo
				
				// or you can just login on the remote deployment server
				
				//define function				
				def dockerComposeCmd = 'docker-compose -f docker-compose.yaml up -d'
				echo "Deploying the package.."
				
   				sshagent(['EC2-Creds']) { 
   				// some block 
   				sh "scp -rp -i ../keys/asher.pem docker-compose.yaml ec2-user@3.89.26.116://home/ec2-user"
   				sh "ssh -o StrictHostKeyChecking=no ec2-user@3.89.26.116 ${dockerComposeCmd}"
   				
				
					
					}
										
					}
				}
			}
}
}


```

### Issue: The authenticity of the host can't be established: && SSH best pratices  on limiting who can access (via ssh) ur server. Jenkins: host key verification failed. 
Since this one is a clean and a new IP, this will prompt our terminal to verify the host, but it is not a security best practice to use and disable `StrictHostKeyChecking` since it will bypass some security measure.

Temporary way: After you perform this, this will be added to known hosts
```
ssh -i ../keys/asher.pem ec2-user@3.89.26.116
```

Anyway, it is also good to not set any write permissions, in adding to `known_hosts` in /root/.ssh. So no one can access ur system even though they know ur pem file.
```
chmod 400 .ssh
chmod a=r .ssh or also yourkey.pem <- read by all although will not work

issue:
	Cannot compile, docker build can't read .pem file. has no permission
SOLUTION:
Let Jenkins be the owner and not root:
chown jenkins:jenkins asher.pem
and set keys out the repo/working folder:
../keys/asher.pem <--- outside of the branch

it is currently in: /var/lib/docker/volumes/jenkins_home/_data/workspace/keys/asher.pem

our repo/working folder:
/var/lib/docker/volumes/jenkins_home/_data/workspace/_jenkins-branch-multi-AWSproject

ANother issue:
Warning: A secret was passed to "sh" using Groovy String interpolation, which is insecure.
		 Affected argument(s) used the following variable(s): [PASSWORD]
		 See [https://jenkins.io/redirect/groovy-string-interpolation](https://jenkins.io/redirect/groovy-string-interpolation) for details.

SOLUTION: best way is to docker login on the remote EC2 deployement server.
```
On the issue of Permission Denied, specify the key
```
scp -rp -i ../keys/asher.pem docker-compose.yaml ec2-user@3.89.26.116://home/ec2-user
Ensure that it is in /home/user not /home, since you don't have permission to write on the root folder
```

### You can also add a shell script in replace of a hard coded in Jenkinsfile
```
def ShellCmd = 'bash ./shell-script.sh'
sh "scp -rp -i ../keys/asher.pem shell-script.sh ec2-user@3.89.26.116://home/ec2-user"
```
### You can also implement versioning in your docker image
1. You can pass a value when passing to docker push to increment version.


## ISSUE: permission denied, you are trying to delete a directory remotely, as a jenkins user, try this]
https://stackoverflow.com/questions/37903334/jenkins-build-failure-shell-command-permission-denied
