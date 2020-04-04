# What will be installed ?

- 0.system_configuration.yml  # Basic configuration (IP, keyboard layout, timezone, hostname, network, ...)
- 1.docker.yml                # Prerequisite to run other apps (Pihole, ...)
- 2.pihole.yml                # Local DNS, filters advertisements on local network
- 3.radicale.yml              # Cardav/Caldav, Store contacts and Agenda locally
- 4.duplicacy.yml             # Backup software, Used to backup any files (Radicale's address book/agendas, pihole settings, ...)

See Installation section for partial installations.

# First

Unbox your Raspberry with Raspbian, and connect screen, ethernet cable, mouse and keyboard.  

login is pi  
password is raspberry

/!\ By default, keyboard layout is QWERTY.

- AZERTY users have to type rqspberry as a password
- QWERTZ users have to type raspberrz as a password


# Change your keyboard layout

```
sudo raspi-config
```

/!\ AZERTY users have to type rqspi-config

- go to 4 Internationalisation Options
- I3 Change Keyboard Layout
- Select your keyboard layout




# Install prerequisites (Ansible and Python)

```shell
apt-get install -y git ansible python3-pip
```

# Download this Ansible playbook (3 options)

By wget

```shell
wget https://github.com/share-me/init_raspberry/archive/master.zip
unzip master.zip
cd init_raspberry-master
```

By git https  

```
git clone https://github.com/share-me/init_raspberry.git
cd init_raspberry
```

By git ssh  

```
git clone git@github.com:share-me/init_raspberry.git
cd init_raspberry
```

# Installation

If you want to change default settings (keyboard layout, IP, password, ports used, Radical initial account/password, ...) please modify this file first:  
- `group_vars/all/main.yml`

Then launch this playbook

```shell
ansible-playbook playbook.yml                               # Install all
ansible-playbook playbook.yml --tags system_configuration   # Only configure system
ansible-playbook playbook.yml --tags docker                 # Only install Docker
ansible-playbook playbook.yml --tags pihole                 # Only install Docker and Pihole
ansible-playbook playbook.yml --tags radicale               # Only install Radicale
ansible-playbook playbook.yml --tags duplicacy              # Only install Duplicacy
```

# Softwares

## Docker - Process isolation by containers

https://docs.docker.com/install/linux/docker-ce/debian/

Container technology, to isolate processes, users and network

## Pihole - DNS relay (with blacklists)

https://pi-hole.net/

Used to block all advertisements on any device connected to the local network (computer, laptop, tablet, mobile app, ...)
Pihole is delivered with a Docker container.

Access Pihole interface http://your.raspberry.ip.address

---

After installation:

1. Connect to your ISP box, disable DHCP server
2. Connect to your Pihole interface, enable DHCP server
3. Restart one of your wifi devices and check on Pihole interface DNS requests are now going through Pihole.  



If you want to keep your ISP box's DHCP, Pi-hole won't be able to determine the names of devices on your local network. As a result, tables such as Top Clients will only show IP addresses.  
If so, apply this workaround :
- Connect on your ISP box and replace DNS IP address by Raspberry IP address
- Connect on Pihole interface and enable "conditional forwarding" in DNS settings but you have to know local domain name delivered by your ISP box.


## Radicale - Cardav / Caldav server

https://radicale.org/

Used to store your contacts and agenda.  
Compatible with any Caldav/Cardav software.  
On Android mobile, you need a third-party connector, like Davdroid.

Access Radicale interface http://your.raspberry.ip.address:5232 (default port)

---

Default Linux user is radicale (with password radicale), change its password  

```shell
su - radicale
passwd
```


If you didn't change default Radicale account in settings  
Create your account (my_new_account) and delete default one (radicale)

```shell
su - radicale
file=/home/radicale/.config/radicale/users
htpasswd -B $file my_new_account
htpasswd -D $file radicale
```


## Duplicacy - Backup solution (cloud compatible)

https://www.duplicacy.com/

Duplicacy is from far the best backup software i ever found for cloud backups.  
I Strongly advice you to take a look on licenses to get full functionnalities.  
Duplicacy Web interface is delivered for those who don't like CLI :-)

Access Duplicacy Web http://your.raspberry.ip.address:3875 (default port)  

---

CLI is there `/usr/local/bin/duplicacy`

Supported storage backends: 
- Local disk
- SFTP
- Dropbox
- Amazon S3
- Wasabi
- DigitalOcean Spaces
- Google Cloud Storage
- Microsoft Azure
- Backblaze B2
- Google Drive
- Microsoft OneDrive
- Hubic
- OpenStack Swift
- WebDav
