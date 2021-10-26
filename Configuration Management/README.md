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

# Install Ansible
1. `apt install ansible`
2. `ansible --version`
3. We need to create another servers to manage.
4. We then connect ansible on our created address:
```
3.92.231.162 ansible_ssh_private_key_file=.ssh/priv_key ansible_user=root
54.163.96.177 ansible_ssh_private_key_file=.ssh/priv_key ansible_user=root
```
6. Then we perform
```
ansible all -i hosts -m ping
```
You will get this result after:
```

root@ip-172-31-26-89:~/ansible# ansible all -i hosts -m ping
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host 54.163.96.177 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A
future Ansible release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for
more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
54.163.96.177 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host 3.92.231.162 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A
future Ansible release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for
more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
3.92.231.162 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}

```
7. Grouping servers are important. Like what vps providers are them, are they database servers, are they on stage or development.
```
[aws]
3.92.231.162 ansible_ssh_private_key_file=.ssh/priv_key ansible_user=root
54.163.96.177 ansible_ssh_private_key_file=.ssh/priv_key ansible_user=root

[digitalocean]

[database]
```
8. Specificity, you can direct the commands using:
```
ansible aws -i hosts -m ping
ansible 54.163.96.177 -i hosts -m ping
```

9. Making it cleaner
```
[aws]
3.92.231.162 
54.163.96.177 

[aws:vars]
ansible_ssh_private_key_file=.ssh/priv_key 
ansible_user=ubuntu

``` 
