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

## ldap

echo "base $LDAP_BASE_DN" > /etc/ldap.conf
echo "uri ldap://$LDAP_SERVER/" >> /etc/ldap.conf
echo "ldap_version 3" >> /etc/ldap.conf
echo "rootbinddn cn=manager,$LDAP_BASE_DN" >> /etc/ldap.conf
echo "pam_password md5" >> /etc/ldap.conf
echo "nss_initgroups_ignoreusers backup,bin,daemon,games,gnats,irc,libuuid,list,lp,mail,man,news,proxy,root,sshd,sync,sys,syslog,uucp,www-data" >> /etc/ldap.conf

## Rstudio
/usr/lib/rstudio-server/bin/rserver --server-daemonize=0 --www-port $RS_PORT
