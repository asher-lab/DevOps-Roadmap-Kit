# Assignment   1. A: Docker Compose
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
create a directory named: mysqldump <br>
Then cd to it:
Create a file named: db.sql
Paste this:

CREATE table product
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
```
Create docker-compose.yaml the same level as mysqldump , not inside! $ cd ..
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
netstat -lpnt
docker-compose -f docker-compose.yaml up -d
netstat -lpnt
+ wait for 10 seconds after creation
+ go to:
ip:8000 | 44.194.205.9:8000
```
![](https://i.imgur.com/ivcnApO.png)
<br> <br>

# Assignment   1. B: Nginx Reverse Proxy
```
we don't want this:
ip:8000

rather we want this:
ip or ip:80 or crud-main.tk
```

## Goal one : Visit IP without port 8000
```
1. Install nginx
2. Go to ip:80 |  44.194.205.9:80
3. sudo unlink /etc/nginx/sites-enabled/default
4. cd /etc/nginx/sites-available/
5. sudo nano custom_server.conf
+ Add this:

server {
	listen 80;
	location / {
	proxy_pass http://localhost:8000;
	}
}

6.put also the config here:
 /etc/nginx/sites-enabled/custom_server.conf

7. sudo service nginx configtest
8. sudo service nginx restart
9. sudo service nginx status
10. Visit IP  without port | 44.194.205.9 | Ensure that 
docker containers are still running.
```


# You will made this>>
## Goal two : Visit app via domain : wecare4u.tk
1. cd /etc/nginx/sites-available/
2. sudo nano custom_server.conf
```
  server {
    listen      80;
    charset     utf-8;
    server_name wecare4u.tk;
    location / {
        proxy_pass http://localhost:8000;
  }
}
```
![](https://i.imgur.com/mCalkIC.png)
3. sudo service nginx restart
<br>
<br>
## Goal three : Visit app via domain with https : wecare4u.tk
1. Follow the instruction here: https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/
2. sudo service nginx restart

![](https://i.imgur.com/vUFRMOp.png)


## Goal four : Create Monitoring setup using Prometheus and Grafana

1. Follow the instruction here: https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/
2. sudo service nginx restart
```
  server {
    listen      80;
    charset     utf-8;
    server_name wecare4u.ml www.wecare4u.ml;
    location / {
        proxy_pass http://localhost:3000;
  }
}
 ```
 3. Install Grafana
 ```
docker run -d --name=grafana -p 3000:3000 grafana/grafana
docker
```
# 
## Goal five: Visit monitoring domain via https: 

Visit now!<br>

wecare4u.ml <br>
![](https://i.imgur.com/QdkKzYp.png)
wecare4u.tk
![](https://i.imgur.com/vUFRMOp.png)
