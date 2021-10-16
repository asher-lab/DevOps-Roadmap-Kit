# Ansible = configuration management
![](https://i.imgur.com/CFUAzPL.png)

**Core Concepts**
- Ansible Inventory
- Ad-Hoc Commands
- Tasks, plats and Playbook
- Ansible config file
- 
**Working with common modules**
- server configuration
- configuring applications
- working with files

**Map shell commands to ansible playbooks**

**Ansible Collections and Galaxy

** - Using Variables **

During the video we'll see:**
- troubleshooting
- conditionals
- privileges
- and more.

# Introduction to Ansible
**USE CASE:**
- A lot of computers, then you have applications then you want to update it. It can take long time and is repetitive task.
- Manual approach is not cost eficcient.

**WHY?**
- Execute tasks in ONE machine.
- Can be written in a single yaml files, rather than combination of shell.
- Reusability and Immutability
- Reduce HUMAN Error

**Ansible is agentless**, meaning there is no agent or dependency. 

## How Ansible Works
- **Module** = one small specific tasks.
- Like installing nginx server, starting docker container, copy file, create an ec2 instance.
https://docs.ansible.com/ansible/2.8/modules/list_of_all_modules.html

- **Ansible uses YAML**
- **Ansible Playbook** it can contain 1 or more plays. Playboo how, when, where, what to be executed.
- Best practice is in hosts in yaml: use settings like databases, webservers, containers. 

**Ansible and Docker is always a good pair.** throught it, it allows you to reproduce in many environments just like docker, like creating image just like in docker. Ansible can also manage the host and the container level.

**- Ansible tower**, a UI dashboard from red hat that enables you to perform automation tasks and share accross teams. Manage inventory and health checks too.

![](https://i.imgur.com/K7HmzYG.png)

Alternative is Puppet and Chef, but it uses ruby. Also agent is needed to them. ( In Ansible all is need is an ssh access ) 
