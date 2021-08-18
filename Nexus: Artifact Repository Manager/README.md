# Installing Nexus

It is recommended that Nexus be installed into a server with a lot of ram. 
```
	cd /opt
	wget nexus.tar.gz
	# unzip / untar the file
	tar -xvzf nexus.tar.gz
	# examining the data
	ls nexus-3.33.1-01
	ls sonatype-work/nexus3 <----- this is where all of your configuration lies in case of migration
	^^^---- also contains IP address that access Nexus and log files.
```

As always create a new user for each service, and don't ever run the app via root:
```
	adduser nexus
	# on centos/redhat/suse linux
	usermod -aG wheel nexus
	# on debian distribution
	usermod -aG sudo nexus
	su - nexus
```

Changing the ownership of the file by given nexus user appropriate permissions
```
	# ChangeOwner recursively so when to set the owner to nexus, a group 'nexus' will also be created.
	# Execute this statements under root user
	chown -R nexus:nexus nexus-3.33.1-01
	ls -la
	chown -R nexus:nexus sonatype-work
	# set the user to nexus by editing nexus.rc
	nano nexus-3.33.1-01/bin/nexus.rc
	-- run user : "nexus"
	# run nexus , it is located in the opt bin folder
	./nexus start
```
Perform checks
```
	ps aux | grep aux
	netstat -lpnt ( if a program is opening a specific port
	# nexus might be open in port 8081
	# open on web , make sure firewall allowing 8081
	ipaddressofyours.com:8081

```
# Working with Nexus Repository
 Nexus is  an artificat repository manager where you can host your repositories internally on to your system. Use cases are:<br>
 <br> 1. Save bandwidth. When developers are downloading packages, saving the repo once on the system can save egress (outbound traffic) cost.
 <br> 2. Centralize team version control. When multiple teams are working on a single project, then it is useful to have a single endpoint where they can make a pull/wget/curl requests so that the application and packages and dependencies they are working with are all the same. This is very effective in saving time and promotes common language.
<br>
Below are the types under Nexus Repository Manager
 ### Repository Types:<br>
 - Proxy, as a remote proxy when conditions are met, this works by having a scheduled job when downloading the latest version or manually. <br>
 - Host, this hosted all repository internally. This works best for proprietary licenses and products. Hosting repositories not available for public.<br>
 - Group. You can combine multiple repository sources into a single repository with the same format. Provided that they are all both from maaven, pypi, etc. Best for having a single endpoint that your developers can talk to.<br>
 
 # Deploying/Publishing an artifact into Nexus Repo (Maven, Gradle, etc)
Best practice is to create a user which has sufficient privileges:<br>
### Always remember the least privilege principle.
1. Create a user with least privilege role.
2. Edit the build.gradle file to set up authentication and enpoint to Nexus
3. : ./gradlew publish
4. Edit the pom.xml file and set up authentication and enpoint to Nexus.
5. maven package then maven deploy

# Nexus API
Use case of the API are:
1. You wanted to deploy many artifact multiple times a day.
2. You wanted to get specific information from the repositories to be available to implement it into your CI/CD Pipeline

Commands:
```
# The return value is dependent on the roles you set up on Nexus.
curl -u admin:password -X GET 'http://34.234.35.40:8081/service/rest/v1/repositories'
or
curl -u deployer-jar:password -X GET 'http://34.234.35.40:8081/service/rest/v1/repositories'
```
Get all the components of a repo, will return JSON format:
```
# The return value will be in a json format
curl -u admin:password -X GET 'http://34.234.35.40:8081/service/rest/v1/components?repository=maven-snapshots'


# Right now the results are empty (since we haven't publish or deplot anything):


			{
			  "items" : [ ],
			  "continuationToken" : null
			}

# downloadUrl is where you can download the configuration (example. pom.xml)

# Getting only the assets of an specific artifact, change <id> to the id that you wanted to get info from:
curl -u admin:password -X GET 'http://34.234.35.40:8081/service/rest/v1/components/<id>'
```
This will return the details such as version, name, checksum, path , etc to be used in your
CI / CD Pipeline. You can set up a script, a cron job to automate any process based on your business rules.


# Nexus BlobStore

A binary large object (blob) store **provides object storage for components and assets**. One or many repositores or repository groups can use each blob store. By default, Nexus Repository automatically creates a file blob store named "default" in the directory during installation.<br>

The file to be stored here are:
1. File. File system level files. File that is hosted directly on the server.
2. Cloud. Object Storage such as S3.

**Terms**
Blob Count = Number of blobs that are currently on the system. One can see the lists of those files in sonatypes blobs folder. (e.g. /opt/nexus/sonatypeworks/blobs/content then perform an ls command)<br>
**Important Reminders**
Blob Store can't be modified and can't be deleted.

### Assigning a repo to a blobstore
You can assign a repo to a blobstore prior to creation.<br>
You can't change the blobstore of existing repository.

# Component versus Asset
A component is a high level abstraction of what are we working on. An asset are files (e.g. jar, md5, py, etc.).<br>
Trivia: <br>
Docker handle the component and asset of artifacts, in a sustainable way:<br>
It can have many docker images / also referred sometimes as components. Usually every components have their specific dependencies (which are assets) inside of every component. However, docker can work by having many components that can share the same asset.

# CleanUp Policies

1. Create a cleanup policy and set the criteria.
2. Associate it within a repo.
3. Cleanup are scheduled and can be views in Task Option on the left hand navigation bar.

There are many scripts to be executed and ready to be implemented. It have many different task already built-in on Nexus.<br>
Some scenario:<br>
When cleaning up a repo, or components or assets, the file are still in the disk. To fix, one need to run a compress task, or a clean task that will remove the entire content from the blob disk.
