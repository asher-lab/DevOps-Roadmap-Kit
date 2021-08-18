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

