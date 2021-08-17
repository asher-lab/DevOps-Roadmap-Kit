# Deploying an Artificat on a VPS 

To setup the project run

```bash
    # Gradlew sometimes need to have lower java version support to run on the system.
    apt install openjdk-8-jre-headless
    sudo apt-get install openjdk-8-jdk
    git clone https://github.com/pmendelski/java-react-example
    cd java-react-example.git
    ./gradlew build
```

If you are working via local computer, then upload the jar code

```
    scp build/libs/java-react-example.jar root@ipaddress:/path
```

Run the java jar app

```
    # Running the jar file not as bg (background) process
    java -jar java-react-example.jar

    # Running the jar file as bg (background) process
    java -jar java-react-example.jar &
```

You will be able to see that TomCat which is a webserver is listening on port 
7071. 
<br> 1. Your security groups must allow the incoming traffic from port 7071.
<br> 2. 1 user per 1 running application

How?
```
    Change an instance's security group
    Select your instance, and then choose Actions, Security, Change security groups.
    AWS based
```

Perform test
```
    ps aux | grep java
    netstat -lpnt

To deploy this project run

```bash
  npm run deploy
```

  
