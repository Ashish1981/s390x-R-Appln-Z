# Ensure that assigned uid has entry in /etc/passwd.

if [ `id -u` -ge 10000 ]; then
 cat /etc/passwd | sed -e "s/^$user:/builder:/" > /tmp/passwd
 echo "$user:x:`id -u`:`id -g`:,,,:/home/$user:/bin/bash" >> /tmp/passwd
 cat /tmp/passwd > /etc/passwd
 rm /tmp/passwd
 fi