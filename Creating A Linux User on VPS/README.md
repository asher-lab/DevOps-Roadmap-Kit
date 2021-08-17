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

    You need to:
    PasswordAuthentication yes

    Or have a ssh terminal where you can put your pem keys
    to be authorized by the VPS



     


```

https://aws.amazon.com/premiumsupport/knowledge-center/new-user-accounts-linux-instance/
