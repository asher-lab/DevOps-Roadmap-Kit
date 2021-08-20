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

A. Prepare the resources: JavaScript Application, compose of UI (frontend) index.html and Node (backend) server.js
```
# install npm
nvm install 7.5
# to install the dependencies on to your system
npm install
# to start running the application
npm server.js
```
<br>
The documentation for MongoDB Express can be found in docker hub: https://hub.docker.com/_/mongo-express
<br>
### What you want to achieve is this:

1. Prepare the resources needed:
```
# download the images from docker hub
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


# On dockerizing the nodejs app
https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
You can dockerize the UI + Backend (app/index.html) and (app/server.js) by following the tutorials above.
