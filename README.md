docker-chouette is a pre-installed docker container 
of Chouette2, an open source web project in Ruby/Rails for editing and viewing Public Transport data
For more information see https://github.com/afimb/chouette2/
and http://www.chouette.mobi
For any question please use [the User Forum](http://forum.chouette.mobi/index.php) or [Contact us](http://www.chouette.mobi/club-utilisateurs/contact-support/) !

# 1. Installation in a nutshell
If you already have docker on your machine,
you'll just have to download and unzip https://github.com/afimb/docker-chouette/archive/master.zip 
(which contains the instructions for composing the 3 images located at https://hub.docker.com/r/afimb)
and then launch the application with:

```
docker-compose pull
docker-compose up -d
```

# 2. Prerequisites
- docker-compose v1.7.1
- docker version 1.10 (or newer)
Only Centos 7 has been tested, but it should work on any Linux distribution
For Windows and MacOS, see the last section of this readme

# 3. For Linux / Centos7
## 3.1 Docker installation
Add yum docker.repo :

```
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
```

```
sudo yum install -y docker-engine git
```

## 3.2 docker-compose installation
```
curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

```
chmod +x /usr/local/bin/docker-compose
```

## 3.3 Run docker without root permissions
If you are new to docker : so as to avoid lauching docker with sudo, docker, you'll need to add your user to the docker group (if it doesn't exist : `sudo groupadd docker`) ;
for Ubuntu the command will be
```
sudo adduser nom_utilisateur docker
```
or
```
sudo usermod -a -G docker nom_utilisateur
```
Then, restart docker

## 3.4 Retrieve and Start the application
### Download docker-chouette
```
mkdir -p /opt/chouette && git clone https://github.com/afimb/docker-chouette.git /opt/chouette
```

or if you don't have git, download the archive: https://github.com/afimb/docker-chouette/archive/master.zip and unzip archive into /opt/chouette

### Download the docker images
```
cd /opt/chouette
docker-compose pull
```

### Start all containers
```
cd /opt/chouette
docker-compose up
```

### Use the Application
wait until containers start...

then go to http://localhost:3000
also open Mailcatcher http://localhost:1080 to catch e-mails

For docker-toolbox on Mac or Windows: you must change every localhost with the ip address given by docker on startup (see below)
From the Docker QuickStart Terminal, ```docker-machine ip``` will give your ip address.

## 3.5 How to launch "Chouette2" at startup

### Systemd script
You need to create chouette.service in /usr/lib/systemd/system/
```
sudo tee /usr/lib/systemd/system/chouette.service <<-'EOF'
[Unit]
Description=Infra Serv
Requires=docker.service
After=docker.service
BindsTo=docker.service
Conflicts=shutdown.target reboot.target halt.target
[Service]
Restart=always
WorkingDirectory=/opt/chouette
TimeoutStartSec=0
TimeoutStopSec=30
ExecStart=/usr/local/bin/docker-compose -f docker-compose.yml up
ExecStop=/usr/local/bin/docker-compose -f docker-compose.yml stop
[Install]
WantedBy=local.target
EOF
```

Check that everything works (chouette must be installed first):
```
sudo systemctl start chouette.service
```

Enable service at boot:
```
sudo systemctl enable chouette.service
```
and then start the containers with:
```
docker-compose up
```

### System V (init) script
TODO


## 3.6 SMTP settings
If you don't want to use MailCatcher, you can use an external SMTP.
Stop all the containers first and then fill all the lines in the file docker-compose.yml with the information from your provider:
- smtp_host=smtp
- smtp_port=25
- smtp_domain=
- smtp_user_name=
- smtp_password=
- smtp_authentication=


## 3.7 Google API Key
If you want to use Google API services, you must specify a key https://developers.google.com/maps/documentation/javascript/get-api-key
Fill the field with your key:
- google_api_key=


# 4. Detailed installation instruction for docker-toolbox on Mac or Windows (also valid for Linux!):

- if you want to understand docker, read this https://docs.docker.com/windows/ 
- until Docker for Windows/Mac is released ([in beta now](https://blog.docker.com/2016/03/docker-for-mac-windows-beta/), and only for Windows 10 and above), you'll have to [install the docker toolbox](https://www.docker.com/products/docker-toolbox), which includes docker-compose ;
- download https://github.com/afimb/docker-chouette/archive/master.zip and unzip in a local directory (ex. D:/docker-chouette)
- launch the Docker QuickStart Terminal (it is also possible to launch docker from a DOS terminal windows if you have already created a docker-machine, for more advanced users : see https://docs.docker.com/engine/installation/windows/)
- if you are behind a proxy, followed the instructions of http://www.netinstructions.com/how-to-install-docker-on-windows-behind-a-pr…  (from "docker-machine ssh default" to "docker-machine restart default")
- the next steps are the same in any OS (except that on linux you can use the localhost URL because docker runs natively on your OS without the need for a VM host)
- go in the directory where you have downloaded docker-chouette (i.e. where the docker-compose.yml file is), and ```docker-compose pull``` then ```docker-compose up -d``` (this will start the application in the background, you can check if processes are started with ```docker ps```)
- wait until all files are downloaded and the chouette2 is started (it may take several minutes)
- find the IP adress of your docker machine with ```docker ip```
- to access to the Chouette application, go in your browser to ```your_ip_address:3000```
- when you first sign up (create an organisation and user), you'll have to validate your account by going to mailCatcher (your_docker-machine_ip_address:1080) and click in the e-mail you'll just received (change the localhost address into your_docker-machine_ip_address)
- sign in with your Chouette user name and you can use the application
- if needed you can connect the Chouette PostgreSQL database from  PGADMIN (create a server with host: your_docker-machine_ip_address, port: 5433, user: chouette, password: chouette)

# 5. Trouble with shared folders for docker-machine version for windows

If you have any trouble with shared folders you can have a look at the code below.

```
$env:Path += "C:\Program Files\Oracle\VirtualBox"

VBoxManage sharedfolder add default --name "chouette-iev" --hostpath "C:\PATH\TO\YOUR\docker-chouette-develop" --transient
 
docker-machine ssh default sudo mkdir -p /c/PATH/TO/YOUR/docker-chouette-develop
 
docker-machine ssh default 

sudo mount -t vboxsf -o defaults,uid=`id -u docker`,gid=`id -g docker` "chouette-iev" /c/PATH/TO/YOUR/docker-chouette-develop
```
