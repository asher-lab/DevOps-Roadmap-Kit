```
1.Login to: I give you mine
https://www.awseducate.com/student/s/awssite
Put pass and email

2. Click yellow button.

3. Click Account details: It will give you :


[default]
aws_access_key_id=*
aws_secret_access_key=*
aws_session_token=*

copy it, then click go to console.

4. SSH on your instance 'kaushik', start the instance.
 Remember AWS educate account automatically stops every 2 hours 
 and 60 minutes ( 3 hours). You can see the remaining time here:
 it is on vocareum
```
![](https://i.imgur.com/Y4vg4p6.png)
```
sudo -i
nano ~/.aws/credentials


+ paste inside: erase all existing contents. don't delete file. in case deleted try : $ aws configure

[default]
aws_access_key_id=*
aws_secret_access_key=*
aws_session_token=*

+ then this command:  
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 111694765298.dkr.ecr.us-east-1.amazonaws.com

+ start docker:
sudo systemctl start docker
docker rm -f $(docker ps -a -q)
```

```
docker-compose.yaml
```
```
version: '3'
services:
  my-crud-app:
    image: 111694765298.dkr.ecr.us-east-1.amazonaws.com/my-crud-app:1.0
    network_mode: "host"
    restart: unless-stopped
  mysql: # --name of the container
    image: mysql:5.6
    ports:
      - 3307:3306 # bind hostmachinePORT:DockerContainerPORT ⇒ 3307:3306

    environment:
      - MYSQL_ROOT_PASSWORD=newpass
      - 'MYSQL_DATABASE=kaushik'
      
    volumes:
      - ./mysqldump:/docker-entrypoint-initdb.d # mysqldump folder should contain db.sql
      
    restart: unless-stopped
```

```
+ Run the docker-compose config:
docker-compose -f docker-compose.yaml up -d
```
