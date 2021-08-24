# Container

  
![](https://hackernoon.com/hn-images/0*0pcYOPXE3UflU48N)

“black sperm whale” by  [Sho Hatakeyama](https://unsplash.com/@shohatakeyama?utm_source=medium&utm_medium=referral)  on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)
<br>***On a post from hackernoon.***

*Installing software is hard. And it has nothing to do with your expertise as a developer. We have all seen our fair share of version clashes, esoteric build failure messages and missing dependency errors each time we embarked upon the task of installing a new software to use. We have spent countless hours copy pasting snippets of code from Stack Overflow onto our terminal and running them with the hope that one of them will magically resolve install issues and make the software run. The result is mostly despair, frustration and loss of productivity.*
<br>
**Container** is  a packaged application where all the configuration and dependencies are all present into the application. <br>
**Containerization** is a way of packaging an application where all of the dependencies and configuration files are present in the package. <br>

Docker images always have config and dependencies package into a docker image. 
1. Where does the docker images reside?
	The containers, in case of docker, reside in a container repository. It can be a PRIVATE REPO or PUBLIC REPO. 
2. ***On Development:***
	Without containers, teams needs to install the binaries and application in a step-by-step fashion. It comes with
	assoc. risk:<br>
		a. different OS environment.<br>
	    b. different package version.<br>
	With containers, isolated environments now contains dependencies and configuration on the system (docker image), without need to install all components over and over again. This would give developers more time to design the logic of the application. Also, you can run multiple versions of the same package on to your host OS. Each docker containers run on each guest OS, which act as an independent environment. This doesn't affect  what application/packages are installed over the other.
3. ***On Deployment:***
	You don't need to set up an environment in which you need to ask developers what version of packages is needed in order for the application to run in the production server. 

# Installing Docker

On Amazon Linux AMI
```
sudo amazon-linux-extras install docker
# Starting the docker engine
sudo service docker start
# Add the `ec2-user` to the `docker` group so you can execute Docker commands without using `sudo`.
sudo usermod -a -G docker ec2-user
```
Run postgres:

```
docker run postgres:9.6
```
You will be given output below:
You can see different hashes and each of them is separated from each other. This tells you that there are layers of a container that have been downloaded into computer. <br>
1. It has Linux Base Image, usually in the form of Alpine Version. Lightweight ones.
2. PostgreSQL image.
3.  Among others, etc.

```

33f99cea3b7d: Pull complete
ecf25dffa35b: Pull complete
0ea81cf96ad9: Pull complete
f07f8493180f: Pull complete
7bb6688e7959: Pull complete
e90849d38b1b: Pull complete
b10814191b4e: Pull complete
3caad22f2089: Pull complete
99b1b88bbb44: Pull complete
188c16910e92: Pull complete
ee01106c5f86: Pull complete
60ae0b39032b: Pull complete
f3c9654d21f1: Pull complete
235ecb81ddba: Pull complete
```

When you try to update postgres via docker, then only the layers need to be updated are downloaded
<br>
***Also note, that when a docker have been downloaded via the run command, then it is executed after all components are finished to downloaded***
Run postgres via docker:
```
docker run --rm --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data postgres
```
Perform tests:
```
# Shows the running containers
docker ps
```
Run another set of postgres (dif. version) simultaneously
```
docker run postgres:10.10
```
Perform kill process:
```
docker kill <container>

```
# Docker Container vs Docker Image
A clear distinction is a docker image is a state in which it is not yet running, it is an image that is downloaded from docker, but not yet on running state. It compose of the package itself. (E.g. Postgres) where it has both the Postgres image, configuration files and dependencies.
<br>
A docker container is a state in which it is on a running state. When an image begin to run, then it begins a process of containerization, of which we know call a running process. Or a docker container. 

# The difference between a virtual machine
![](https://upload.wikimedia.org/wikipedia/commons/9/9f/Linux_kernel_and_Computer_layers.png)



The Kernel communicates with the Hardware which composes of CPU, Memory and Peripheral Devices. And Applications run on the Kernel. It facilitates the operation of application by the use of an operating system.

## What is the level of virtualization of docker vs virtual machines?
![](https://images.contentstack.io/v3/assets/blt300387d93dabf50e/bltb6200bc085503718/5e1f209a63d1b6503160c6d5/containers-vs-virtual-machines.jpg)
Virtual Machines completely virtualized the Operating System Layer and will set up many independent environment, while docker only virtualizes the application layer. This points out to: <br>
1. Docker images are smaller.
2. Docker images are faster to run.
3. Compatibility. In VMs, you can run different OS under a single machine (provided that the architecture you are using are the same e.g. x86 vs ARM processors in case of M1 Macbook Chips ), however docker can't do this. Because docker images run top of the build ( since packages are composed of Linux packages, it can't run on windows). A workaround is using a **Docker Toolbox**.

# How is docker engine made up. ~ The architecture.
![](https://nickjanetakis.com/assets/blog/dockers-architecture-6c296cdac053f794eabed5ddda5c04ba7110c746687a0e8b88ba6df919415175.jpg)

The docker engine aka daemon is made up of three (3) main parts: <br>
1. Docker Server = It allows you to communicate with the Kernel level and perform tasks, like running, stopping an image.
2. Docker API =  It employs a REST API that will allow you to interact with the docker server. Some tools can be access using the API.
3. Docker CLI = It uses the command line that will allow you to send commands via CLI.

# Docker Commands (start, stop, run, ps, pull, exec -it, logs)

```
# Starting docker:
sudo systemctl start docker
sudo service docker start
# download the redis image
docker pull redis
docker images
# Run redis
docker run redis
# minimize screen or perform screen command so it can run on bg
# You can also run container in a detached mode
docker run -d redis
# Restarting the containers
docker stop <container ID>
docker start <container ID>
# Show the status of the containers that are running or not running
docker ps -a
```

Running multiple versions of containers: Port Binding
##### You will see that there are conflicts running on same port. So it is necessary to make a port binder to associate the port of the host to a running docker container. 
```
docker ps
docker kill <container ID> in case you have container running
docker images
docker ps -a

# Perform PORT Binding 
docker run -p5000:6379 -d redis
docker run -p5001:6379 -d redis:4.0
```

# Debugging docker 
see logs
```
docker logs <containerID or container-name>
# to set up a name of a docker container
docker run -d -p5002:6379 --name redis-depricated redis:4.0
```
Navigate dir, log file, config file, print env. variable etc or any other operation you need to debug your application
then you use:
```
# -it stand for interactive terminal
docker exec -it <containerID or container-name> /bin/bash
# after running you can perform operationsn, it will give you your own  virtualized environment here
pwd
cd /
env
# You are sharing the resources that is present on your host OS, for example the files
# This is useful when you setting up or debugging a system.
```
The `exec` command is used to interact with already running containers on the Docker host. It allows you to start a session within the default directory of the container. Sessions created with the `exec` command are not restarted when the container is restarted.

<br>
When you run docker exec -it, and try to execute commands such as `ping` and `curl` it won't work, since alpine OS is a lightweight OS with not much of a tools in it.

# Docker Integration with Git and Jenkins Whiteboard
#### Presented below is a sample workflow of Docker in software development
![](https://i.imgur.com/bW3tbO3.png)

1. Download the MongoDB image from the Docker Hub Repo.
2. Commit the changes of the JS application to git.
3. Integrate and push the commit to Jenkins which will then build the JS APP (this would undergo into different build tests, etc and after it all passed you then,
4. Build the docker image.
5. You now have docker image in your computer, and you can publish it either a public repo or private in whatever container registry you choose, it depends on your choosing.
6. Developer's Environment. Other team members can now work and experiment with your application. They perform two things. Download the mongoDB image on docker and download the JS application you uploaded on a container registry.

# Docker Integration with Database and Software Development

## Docker Example1 (without docker compose)
![](https://i.imgur.com/VgD6P3j.png)
A. Prepare the resources: JavaScript Application, compose of UI (frontend) index.html and Node (backend) server.js
```
# install npm
nvm install 7.5
# to install the dependencies on to your system
npm install
# to start running the application
node server.js
```
<br>
The documentation for MongoDB Express can be found in docker hub: https://hub.docker.com/_/mongo-express
<br>
### What you want to achieve is this:

1. Prepare the resources needed:
```
# download the images from docker hub

sudo systemctl start docker
### -- sudo systemctl stop docker.socket
docker pull mongo
docker pull mongo-express
```
2. Run both the application and connect it within the same isolated docker network (MONGO DB)
```
docker network ls
docker network create mongo-network
docker network ls
```
3. Run both the application and connect it within the same isolated docker network  (MONGO DB)
```
docker images

docker run -d -p 27017:27017 \
-e MONGO_INITDB_ROOT_USERNAME=admin \
-e MONGO_INITDB_ROOT_PASSWORD=password \
--name mongodb \
--net mongo-network \
mongo


```
4. Perform checks
```
docker ps
docker logs <container ID>
```
5. Run both the application and connect it within the same isolated docker network (MONGO EXPRESDS)
```
docker run -d -p 8081:8081 \
-e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
-e ME_CONFIG_MONGODB_ADMINPASSWORD=password \
--net mongo-network \
--name mongo-express \
-e ME_CONFIG_MONGODB_SERVER=mongodb \
mongo-express
```
6. Perform checks
```
docker ps
docker logs <container ID>
# make sure node js app is running
```
7. If you are running in the cloud , you need to set up for your firewall so port 8081 can be opened. You need to put collection aka table in sql. Add `user-account` as a collection. Access it via `ipaddress:8081`
8. Verify the everything is running
```
docker ps
```
Then, change some data in the front end
```
docker logs <container ID> | tail
# this would allow a contionous flow of data if connections or requests are been made
docker logs <container ID> -f 
```

Always remember to allow port so you can access all of it:
```
port 27017
port 8081
port 3000
```

Extra trivia from stackoverflow
##### # [Does Ubuntu UFW overrides Amazon Ec2's security groups and rules?](https://stackoverflow.com/questions/57436758/does-ubuntu-ufw-overrides-amazon-ec2s-security-groups-and-rules)
> A firewall like UFW is running at the OS level, while Amazon Security Groups are running at the instance level. Traffic coming into the EC2 would first pass through the SG, and then be evaluated by UFW. Take a scenario where traffic is explicitly allowed to pass through the SG but UFW denies it -- in this case UFW would _sort of_ 'override' the settings in the SG.
https://javascript.info/fetch <<---- info about fetch
# Must haves docker command
List all the docker containers created:
```
docker ps -a -q
```
To clear containers:
`docker rm -f $(docker ps -a -q)`
To clear images:
`docker rmi -f $(docker images -a -q)`

To clear volumes:

`docker volume rm $(docker volume ls -q)`

To clear networks:
`docker network rm $(docker network ls | tail -n+2 | awk '{if($2 !~ /bridge|none|host/){ print $1 }}')`

Killing process listening on a specific port
```
kill $(lsof -t -i:8080)
```
*Side Note (In regards with 5 hours spent debugging the code)
1. index.html has embedded localhost that's why it can't connect to MongoDB app.
2. Fix display on CSS = style.display = 'none' to 'block'.




<br><br>

## Docker Example2 (with docker compose) = running multiple docker images

Structure of yaml file:
```
version: '3' # version of docker compose
services:
	mongodb: #name of the container
		image: mongo #image of the docker container
		ports:
		-27017:27017 # ports to be opened # port to be opened HOST:CONTAINER
		environment:
		-- MONGO_INITDB_ROOT_USERNAME=admin # environmental variables
```
**Docker Compose** helps to put into a single yaml file all the docker commands. When you ain't not specify a network image then a network will be create to you with the prefix on the front of where your yaml file release. 

Run docker compose:
```
docker-compose -f docker-compose.yaml up -d
```

docker-compose.yaml should contain the following:::

```
version: 3
services:
  mongodb:
    image: mongo
    ports:
      - 27017:27017
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password
  mongo-express:
    image: mongo-express
    ports:
      - 8081:8081
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
      - ME_CONFIG_MONGODB_ADMINPASSWORD=password
      - ME_CONFIG_MONGODB_SERVER=mongodb
    restart: unless-stopped
```

Othe useful parameters:


```
tty: true
stdin_open: true
```

 # On dockerizing the nodejs app
https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
You can dockerize the UI + Backend (app/index.html) and (app/server.js) by following the tutorials above.

`Dockerfile`
```
FROM node:13-alpine

ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PWD=password

RUN mkdir -p /home/app

COPY ./app /home/app

# set default dir so that next commands executes in /home/app dir
WORKDIR /home/app

# will execute npm install in /home/app because of WORKDIR
RUN npm install

# no need for /home/app/server.js because of WORKDIR
CMD ["node", "server.js"]

```

Perform the building process:
<br>
When running this , you should be on the right directory , also your Dockerfile
```
docker build -t my-app-crud:1.0 .
docker run -d \
--net containers_default \
my-app-crud:1.0

or

```
docker run -d \
--network="host" \
my-app-crud:1.0
```

netstat -lpnt
```

<br> <br>
# On using Amazon ECR (not yet ECS) to push and pull files
## Pushing Image to the registry
**On docker versus on Amazon ECR: <br>**
You can pull request just by using `docker pull mysql:5.6` this is equivalent to: `docker pull docker.io/library/mysql:5.6`<br>
You can pull request on Amazon ECR by using `RegistryName/ImageName:tag` <br>
1. Create a repository via Amazon ECR. There is one repo per image (it is possible to have multiple version for a single image). You can create both public and private repositories. Let's stick with a private repo. for now.
<br>

Best convention is to practice using the name on your image name:
```
111694765298.dkr.ecr.us-east-1.amazonaws.com/my-app-crud
```

2. Pushing an image to ecr. Remember that AWS CLI and creds needs to be configured here. <br> On ECR console, there are commands that can help with this process.

```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 111694765298.dkr.ecr.us-east-1.amazonaws.com
```
3.  After the build completes, tag your image so you can push the image to this repository:
```
$ docker image
docker tag my-app-crud:1.0 111694765298.dkr.ecr.us-east-1.amazonaws.com/my-app-crud:1.0
$ docker image # to verify the process
```
4.  Run the following command to push this image to your newly created AWS repository:
```
docker push 111694765298.dkr.ecr.us-east-1.amazonaws.com/my-app-crud:1.0
```
5. Making some changes in the repository and pushing the changes under different versions. 
```
# Make some changes
docker build -t my-app-crud:1.1 .
$ docker images
docker tag my-app-crud:1.1 111694765298.dkr.ecr.us-east-1.amazonaws.com/my-app-crud:1.1
docker push 111694765298.dkr.ecr.us-east-1.amazonaws.com/my-app-crud:1.1

```
![](https://i.imgur.com/bW3tbO3.png)
We simulate the Jenkinds process. Which includes building the image and push it into a registry which is (Amazon ECR). The commands that we used are the same when we are going to use Jenkins. 

## Pulling Image to the registry
Run docker compose:
```
docker-compose -f docker-compose.yaml up -d
```
docker-compose.yaml should contain the following:

```
version: '3'
services:
  my-crud-app:
    image: 111694765298.dkr.ecr.us-east-1.amazonaws.com/hello:latest
    network_mode: "host"
  mongodb:
    image: mongo
    ports:
      - 27017:27017
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password
  mongo-express:
    image: mongo-express
    ports:
      - 8081:8081
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
      - ME_CONFIG_MONGODB_ADMINPASSWORD=password
      - ME_CONFIG_MONGODB_SERVER=mongodb
    restart: unless-stopped
```

Othe useful parameters:
```
tty: true
stdin_open: true
```

**Issues faced when deploying app on another computer: <br>**
1. Docker contents not updating when modified the code. Updating docker image with a new code. Then running it via docker compose:
```
# Be sure yaml file is in docker-compose.yaml
docker-compose up -d --build --force-recreate

# build the image via Dockerfile
docker build --no-cache -t my-app-crud:1.1 .

# a work around too is be sure to run it on same network when you are trying to run the container independently (not together with mongodb, and mongoexpress)
network mode as "host"

verdict: I diagnosed it via network mode , because it is not connecting to db of a container since different network. 
```
2. A docker image when run is not responding. Main reason is some of its dependencies are not also running. For example if a node need to connect within a database that is not running, probably it will not work.

# Data Persistency in Docker

The default directory where the data persist is located in data/db is stored: <br>
```
docker ps
docker exec -it <container ID> sh or bin/bash
ls /data/db
$ exit
ls cd var/lib/docker
```
Different application / databases have different paths: Example <br>
```
mysql: /var/lib/mysql
postgres: /var/lib/postgresql/data
```
The contens of yaml file is below: 
`docker-compose.yaml`


```

version:  # change to '3'
services:
  my-crud-app:
    image: 111694765298.dkr.ecr.us-east-1.amazonaws.com/hello:latest
    network_mode: "host"
  mongodb:
    image: mongo
    ports:
      - 27017:27017
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password
    volumes:
      - mongo-data:/data/db
  mongo-express:
    image: mongo-express
    ports:
      - 8081:8081
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
      - ME_CONFIG_MONGODB_ADMINPASSWORD=password
      - ME_CONFIG_MONGODB_SERVER=mongodb
    restart: unless-stopped
volumes:
  mongo-data:
      driver: local

```

# Pushing and Pulling Data in Nexus && Running Nexus as a Docker Container
1. Create Repo (hosted) : docker-hosted.
2. Create and Assign Role.
3. Docker login:
```
set unique port for docker
realm - for tokenization
configure http connection to docker
nano etc/docker/daemon.json
docker tag image:tag ip:port/image:tag
docker push ip:port/image:tag
```
Note: Layers and assets can be used by other people. <br>
<br>
## Fetching / pulling data
```
curl -u asher:123pass -X GET 'http://ip:port/service/rest/v1/components?repisitory=docker-hosted

# Run nexus as a docker container
docker pull nexus3
```
 
