#!/bin/bash

#This script is used for Install/Configure Bind service
#Please notice that this script only tested under Ubuntu OS
#It should also work on any Debien based Linux Distribution.

#Auther : created 2015/10/17 by Hao

#=======================================
#Test whether the bind service has 
#beeb installed, if not then install it
#=======================================
PKG_OK=$(dpkg -s bind9 | grep -q "install ok installed"; echo $? )

if [[ PKG_OK -eq 0 ]]; then
    echo "Bind OK..."
else
    echo "Bind not found..."
    sudo apt-get install bind9 dnsutils -y >null
fi


#=======================================
# Get domain name from user
#If get something wrong then complain
#=======================================
if [[ $1 != "" ]]; then
    dname=$1
    echo "Your domain name will be $dname "
else
    read -p "Please give me your full domain name..." dname
    echo "your domain name will be $dname"
fi    

#=======================================
#Create a new zone file for new domain 
#=======================================
cd /etc/bind
    sudo  cp ./db.empty ./db.$dname
    echo "New zone file created..."
    sudo sed -i "1c ;This is zone file for $dname" /etc/bind/db.$dname
    sudo sed -i "7c @\tIN\tSOA\tns1.$dname. hostmaster.$dname. (" /etc/bind/db.$dname
    sudo sed -i "14c @\tIN\tNS\tns1." /etc/bind/db.$dname
    sudo sed -i "14a ns1\tIN\tA\t127.0.0.1" /etc/bind/db.$dname
    sudo sed -i "15a www\tIN\tA\t192.168.47.91" /etc/bind/db.$dname
    sudo sed -i "16a mail\tIN\tA\t192.168.59.5" /etc/bind/db.$dname
    echo "Zone file modified..."



#=======================================
#Create a reverse zone file
#
#=======================================
cd /etc/bind
    sudo cp ./db.empty ./db.192.168
    sudo sed -i "1c ;This is reverse zone file for db.192.168" /etc/bind/db.$dname
    sudo sed -i "7c @\tIN\tSOA\tns1.$dname. hostmaster.$dname. (" /etc/bind/db.$dname
    sudo sed -i "14c @\tIN\tNS\tns1." /etc/bind/db.$dname
    sudo sed -i "15c 91.47\tIN\tPTR\twww.$dname." /etc/bind/db.192.168
    sudo sed -i "16c 5.59\tIN\tPTR\tmail.$dname." /etc/bind/db.192.168
    echo "Reverse zone file modified..."


#=======================================
#test if named.conf file exsist
#if not then create it
#=======================================
if [[ ! -e "/etc/bind/named.conf.local" ]]; then
    sudo touch /etc/bind/named.conf.local
else
  cat <<EOF >>/etc/bind/named.conf.local
    zone "'$dname'" {
        type master;
        file "/etc/bind/db.$dname";
    };
    
    zone "168.192.in-addr.arpa" {
        type master;
        file "/etc/bind/db.192.168";
    };
EOF

    echo "named.conf.local [OK]"
fi


#=======================================
#Reload bind service 
#=======================================
sudo rndc reload


