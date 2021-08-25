
![](https://www.jenkins.io/images/logo-title-opengraph.png)
**Jenkins** is a server that helps you in creating your CI/CD Pipeline. <br>
Example use case:
`Building a scripted pipeline which triggered automatically on code changes`

General Steps to understand how CI/CD in Jenkins works:
```
1. Introduction to Build Automation.
2. Installing Jenkins and required dependencies in performing build and test process (e.g. Plugins , docker, npm, nginx, maven, gradle, etc.)
3. Create a freestyle job. 
4. Integrating Docke in Jenkins.
5. Bulding Scripted Pipeline in Jenkins.
6. Jenkinsfile
7. Manage multiple git branches, by building a Multi Branch Pipleine
8. Configure automated version control on every builds ( or codes ).
9. Create a jenkins share library so other can reuse your code.
```

# Sample Build Automation Pipeline
![](https://i.imgur.com/00cP3I8.png)

1 **Test Environment** <br>
Prepare the test environment. `npm test, mvn test, gradlew test, nginx -t`
In case of test data, prepare for test data in database. `Perform basic operations in data,` be sure inputs are diverse sets (e.g. include char, int, float, different data types in the test process.) Also include character encoding checking, a try-catch is an important aspect when creating the app. <br>
2. **Building the Artifact/ Image** 
Ensure that all necessary tools are present `docker build, npm package, gradlew build`
<br>
3. **Publish an Artifact/ Image**
Be sure the credentials are set up.

## A. Installing Jenkins
Installation is a straight forward process; Either install it manually, where you will set up for the jenkins-user and grant appropriate permissions. Or install via docker

<br>
Clean state run: <br>

**Ensure that no containers and images are installed.**

```
sudo systemctl start docker
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -a -q)
```

```
yum install docker
yum check-update
systemctl start docker
```

`docker run -p 8080:8080\` # open port 8080 and listen to port 8080<br>
`-p 50000:50000 \` # this is necessary when you are attaching slave servers in the master server, this is where master and worker communicate<br>
`-d \ `# run in detached mode<br>
`-v jenkins_home:/var/jenkins_home \ `#assign the PWD of jenkins in its own docker ecosystem.<br>
`jenkins/jenkins:lts`<br>
<br>
1. Below is the docker run command for installing jenkins:
```
docker run -p 8080:8080 \
-p 50000:50000 \
-d \
-v jenkins_home:/var/jenkins_home \
jenkins/jenkins:lts
```
```
docker ps
netstat -lpnt
```
2. Getting the password and understanding more about docker volumes:
```
docker exec -it <containerID> bin/bash or bash or sh
ls /var/jenkins_home/secrets/initialAdminPassword
cat /var/jenkins_home/secrets/initialAdminPassword
exit
```
Perform check via main terminal (not on docker terminal)
```
docker volume inspect jenkins_home
# Will return
"Mountpoint": "/var/lib/docker/volumes/jenkins_home/_data",
ls /var/lib/docker/volumes/jenkins_home/_data
ls /var/lib/docker/volumes/jenkins_home/_data/secrets/initialAdminPassword
cat /var/lib/docker/volumes/jenkins_home/_data/secrets/initialAdminPassword
```
3. Install plugins.
4. Create first admin user.
`Warning: Building on the controller node can be a security issue. You should set up distributed builds.`

## B. Installing Build Tools

There are 2 ways to install  tools: <br>
1. Via Jenkins itself.
2. Inside the server where Jenkins is running. In case of docker, terminal of jenkins in docker via root:
```
docker exec -it -u 0 <containerID> bash
```
Alert: How to persists installation made inside the Jenkins container. Because everytime I started a fresh container of Jenkins NPM is removed.
```
+ After you go into the root terminal of the container:
 cat /etc/issue
 apt update
 apt install curl
 apt install npm
 apt install nodejs
```
### Building a simple freestyle job
1. You can create a freestyle job easily, then perform:
`npm --version`
It is better to create a script via cmd and not the preinstalled tools because it is way more flexible.
2. Build Now | Configure if you will add , modify or delete executables.

## Configuring Git together with Jenkins
###  Basic Steps in connecting GIT to Jenkins Pipeline

```
1. Add repo url.
2. Add authentication.
3. Decide for the branch.
4. The repo will connect to the job.
5. Build.
```

Jobs are **stored** in: 
```
sudo via jenkins docker container as a root user:
cd /var/jenkins_home
cd /var/jenkins_home/jobs/job-name/builds/

```
Cloned remote repo are **stored** in : <br>
```
cd /var/jenkins_home/workspace/job-name
# tmp data stored files that are for temporary storage
```

Test 1. Running from a branch on a git repository:
```
1. Decide for the branch
2. Assume file has simple command: freestyle.sh

npm --version

3. Provide the execute shell scripts:
chmod +x freestyle.sh
./freestyle.sh
```

Test 2. Create a simple build pipeline:<br>
Git -> Maven test -> Maven package -> Jar file
<br>

```
+ freestyle job : java-maven-build
+ add maven test: test
+ add maven build: package
+ set the correct branch: jenkins-branch (example)
+ check the results on the directory:

cd var/jenkins_home/workspace/java-maven-build
cd target
ls

```

<br><br>

#magic desktop
```docker run -p 6070:80 dorowu/ubuntu-desktop-lxde-vnc -d```
