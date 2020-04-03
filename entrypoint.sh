#!/bin/sh

# create user

groupadd -f -g $RS_GID $RS_GROUP || exit 1
useradd -d $RS_HOME -u $RS_UID -g $RS_GID -p `echo "$RS_PASSWORD" | mkpasswd -s -m sha-512` $RS_USER || exit 1

if [ $RS_GRANT_SUDO = "yes" ]; then
  echo "$RS_USER ALL=(ALL) ALL" >> /etc/sudoers.d/$RS_USER
elif [ $RS_GRANT_SUDO = "nopass" ]; then
  echo "$RS_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$RS_USER
fi

mkdir -p $RS_HOME
chown $RS_USER:$RS_GROUP $RS_HOME
su - $RS_USER -c "cp -n -r --preserve=mode /etc/skel/. $RS_HOME"

## Rstudio
/usr/lib/rstudio-server/bin/rserver --server-daemonize=0 --www-port $RS_PORT
