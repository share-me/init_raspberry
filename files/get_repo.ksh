#!/bin/bash
set -e

# Install missing packages
echo -e "\n\n --> Ansible and Python3 installation\n"
sudo apt-get -q install -y git ansible python3-pip

# Download playbook
echo -e "\n\n --> Download Ansible playbook\n"
cd
rm -Rf init_raspberry
git clone --quiet https://github.com/share-me/init_raspberry.git

# Get mandatories informations
echo -e "\n\n --> Prepare Ansible playbook\n"
default_gw=$(ip route show | head -1 | cut -d ' ' -f3)
default_ip=192.168.$(echo $default_gw|cut -d'.' -f3).42

echo -n "Type your Raspberry name: "
read name
name=$(echo $name | tr -d ' ' | tr '[:upper:]' '[:lower:]')
if [ -z "$default_gw" -o -z "$default_ip" -o -z "$name" ] ; then
	echo "Something goes wrong. Stop"
	exit 1
fi

# Modify playbook files
echo "Set Internet Box address: $default_gw"
echo "Set Raspberry eth0 IP: $default_ip"
echo "Set Raspberry name: $name"

sed -i "s/box_ip_address:.*/box_ip_address: $default_gw/" init_raspberry/group_vars/all/system_configuration.yml
sed -i "s/my_ip_address:.*/my_ip_address: $default_ip/" init_raspberry/group_vars/all/system_configuration.yml
sed -i "s/my_hostname:.*/my_hostname: $name/" init_raspberry/group_vars/all/system_configuration.yml
