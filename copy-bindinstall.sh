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
#echo $PKG_OK
if [[ PKG_OK -eq 0 ]]; then
    echo "Bind OK..."
else
    echo "Bind not found..."
    sudo apt-get install bind9 
fi


#=======================================
# Get domain name from user
#If get something wrong then complain
#=======================================
dname=localhost

if [ $1 != "" ]; then
    dname=$1
    echo "Your domain name will be $dname "
else
    read -p "Please give me your full domain name..." dname
    echo "your domain name will be $dname"
fi    

#=======================================
#Create a new zone file for new domain 
#Adding somet information in it 
#=======================================

if [ /etc/bind/db.$dname == "" ]; then
    echo "Creating your zone file..."
    sudo cp /etc/bind/db.empty /etc/bind/db.$dname
else 
    echo "Detected exsist zone file..."
fi




#=======================================
#Create a reverse zone file
#
#=======================================


#=======================================
#test if named.conf file exsist
#if not then create it
#=======================================


#=======================================
#Reload bind service 
#=======================================


#=======================================
#Test the bind service use nslookup
#=======================================
