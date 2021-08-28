# Simple CRUD JS APP
Best practice.<br> **Ensure that no containers and images are installed.**
```
sudo systemctl start docker
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -a -q)
```

## Step 1: Setting up the working environment. 
1. Navigate to the project directory
2. Clone the repository JS node app https://github.com/hendisantika/crud-bootstrap-mysql-nodejs
You can also work with this: https://github.com/mdobydullah/nodejs-crud-with-expressjs-mysql just need some changes in credentials and config.

Change some credentials in index.js <br>
![](https://i.imgur.com/1Vz2VDk.png)
<br><br>
Refer to this forum to know the IP or host : https://stackoverflow.com/questions/24319662/from-inside-of-a-docker-container-how-do-i-connect-to-the-localhost-of-the-mach

4. Install the dependencies | ```npm install```
5. Create a Docker Network.
```
docker network create crud-network
```
6.  Install MySQL 5.6 as a Docker Container. || version 5.6 is best for deprecated authentication method
```
docker pull mysql/mysql-server:5.6
docker images
```
7. Run mysql as a docker container. <br>*<br>Running in a detached mode. <br>Running with the use of binding port technique hostmachinePORT:DockerContainerPORT ⇒ 3307:3306<br>Running on crud-network Network.*
```
docker run -p3307:3306 -d \
--name mysql \
--net crud-network \
-e  MYSQL_ROOT_PASSWORD=newpass \
mysql:5.6
```
8. Enter mysql terminal as a docker container
```
docker ps
docker exec -it mysql /bin/bash
#e.g. root@7dba1170d1b1:/#
```
9. Enter required credentials (Manual option: unless specify directly to Docker-Compose.yaml
```
mysql -uroot -p
Enter password: newpass
mysql > show databases;
mysql> CREATE DATABASE kaushik;
mysql> USE kaushik;
mysql> CREATE table product
(
	product_id int auto_increment primary key,
	product_name varchar(200) null,
	product_price int null
)charset=latin1;

INSERT INTO kaushik.product (product_id, product_name, product_price) VALUES (1, 'Product 1', 2000);
INSERT INTO kaushik.product (product_id, product_name, product_price) VALUES (2, 'Product 2', 2000);
INSERT INTO kaushik.product (product_id, product_name, product_price) VALUES (3, 'Product 3', 3000);
INSERT INTO kaushik.product (product_id, product_name, product_price) VALUES (4, 'Product 4', 2000);
INSERT INTO kaushik.product (product_id, product_name, product_price) VALUES (5, 'Product 5', 1500);
```
10. Make some ammendments to the bind address and root
```
mysql> use mysql;
mysql> select host,user from user;
mysql> CREATE USER 'root'@'%' IDENTIFIED BY 'newpass';
mysql> select host,user from user;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

exit my sql

mysqld --verbose --help --bind-address=0.0.0.0| grep bind-address
``` 
Command to check which ports are opened:  
`netstat -lpnt`
`ps aux | grep mysql `
3307 must be open

10. Run the app (later run via Dockerfile)


## Step 2: Setting up the reverse proxy via Nginx

1. Install nginx and commands
```
# this is used on an Amazon Linux 2 not Ubuntu, although same process
$ sudo yum -y install nginx
$ nginx -v

# ---- Commands --- #
systemctl start nginx
systemctl status nginx
systemctl stop nginx
#kill all the running node js 
killall -9 node
systemctl restart nginx
sudo yum remove nginx
# ---- Commands --- #
```
2. For HTTP and bare IP this is what should you do:
```
cd /etc/nginx/conf.d
ls
nano nodeapp.conf
server {
	listen 80;
	listen [::]:80;
	
	server_name 172.31.79.224;
	
	location / {
		proxy_pass http://localhost:8000/;
	}
}
# save the configuration
nginx -t
nginx -s reload
```
3. Edit the nginx.conf and replace the server block with:
```
server {
	listen 80;
	listen [::]:80;
	
	server_name 172.31.79.224;
	
	location / {
		proxy_pass http://localhost:8000/;
	}
}
# save the configuration
nginx -t
nginx -s reload

```
4. Run the node application. 
```
node index
```
## Step 3: Creating the Dockerfile and DockerImage out of the nodejs app
Use case: By creating a docker image, teams across the organization can work on the same nodejs application without having a hard time setting up the work environment. This would also allow a team to create a CI/CD pipeline.
<br>
`Dockerfile`
```
FROM node:14.17.5
ENV NODE_ENV=production
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install --production
COPY . .
EXPOSE 8000
CMD [ "node", "index" ]
```
Perform the building process:
```
docker build -t my-app-crud:1.0 .


# check for the image
docker images

# run the image
docker run -d \
--network="host" \
my-app-crud:1.0
```
![](https://i.imgur.com/ivcnApO.png)
# Step 4: Creating docker-compose.yaml

Use case: You can run multiple images at the same time within one configuration using docker-compose. It composes all your images, commands of each images, network, environmental variablers, volumes, etc.
<br>
Best practice.<br> **Ensure that no containers running.<br> Also, ensure nginx is still running.**
```
docker rm -f $(docker ps -a -q)
```
<br>

**Note: ** : Make sure docker-compose is installed on your system.
`docker-compose.yaml` = this can be any name of your choice.
```
version: '3' # the version of docker-compose
services: # images ur gonna install

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
    
  my-app-crud:
    image: my-app-crud:1.0
    
    network_mode: "host"
    
    restart: unless-stopped
```
Run the container:
```
docker-compose -f docker-compose.yaml up
```
![](https://i.imgur.com/ivcnApO.png)
Done.

 # # ** ...What I haven't yet done, yet optional: **
 ```
 data persistency
 https
 ci/cd pipeline - via jenkins or gitlabci
 upload on a container repo like ECS - via jenkins or gitlabci
 run nginx on docker as well (optional)
 firewalld, ufw and ip tables
```
