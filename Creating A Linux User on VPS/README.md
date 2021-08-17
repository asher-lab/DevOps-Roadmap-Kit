# Creating A Linux User on VPS

Use cases:
<br> 1. One should not run applications via root. Because it can be used
as an attack vector. (e.g exploit, remote control)
<br> 2. One application per user.
<br> 3. Give only the necessary permission per user.
<br> 4. Don't ever use root user in production setting. Ever!



Setting the privileges

```bash
    adduser asher
    # adding the user to sudo grouo
    usermod -aG sudo asher
    $ switch from other user
    su - asher
```


Accessing via IP Address
```
    # Below command will output : permission denied public key
    ssh asher@ipaddress

     # You need to copy ssh from your root / If you did create authorization
     via ssh and not password.


     ls -la
     cd .ssh
     sudo nano authorized_keys
     # Create key ( ssh-keygen)
     ssh-ed25519 key email


```

https://aws.amazon.com/premiumsupport/knowledge-center/new-user-accounts-linux-instance/
