## AWS CLI
### aws <command (service)> <subcommand(operation for the service)> [options and params]

Describe:
```
aws ec2 describe-security-groups
```
### Create: AWS EC2 with new Key and Sec Group
1. Security Group Creation:
```
# Create
aws ec2 create-security-group --group-name my-sg \
--description "My NEW SG" --vpc-id vpc-a4e051d9

#Describe
aws ec2 describe-security-groups --group-ids sg-097a6fbaf9b6aa160

# Add Port 22 on SG
aws ec2 authorize-security-group-ingress \
--group-id sg-097a6fbaf9b6aa160 \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0

# Add Key
aws ec2 create-key-pair \
--key-name Pineng \
--query 'KeyMaterial' \
--output text > ArwinAsher.pem

# Create an EC2 instance
aws ec2 run-instances \
--image-id ami-0c2b8ca1dad447f8a \
--count 1 \
--instance-type m5.large \
--key-name Pineng \
--security-group-ids sg-0cd0eb8d4da593b57 \
--subnet-id subnet-236f0a45

Then you can also:
	-filter
	-create policies and assign to a role group users
	- create users
	- delete
```
