Chouette2 is an open source web project in Ruby/Rails for editing and viewing Public Transport data
For more information see https://github.com/afimb/chouette2/
and http://www.chouette.mobi
For any question please use [the User Forum](http://forum.chouette.mobi/index.php) or [Contact us](http://www.chouette.mobi/club-utilisateurs/contact-support/) !

## For Linux/Ubuntu
If you are new to docker : so as to avoid lauching docker with sudo, docker, you'll need to add your user to the docker group (if it doesn't exist : `sudo groupadd docker`) ;
for Ubuntu the command will be
`sudo adduser nom_utilisateur docker`
or
`sudo usermod -a -G docker nom_utilisateur`
Then restart docker

## For docker-toolbox on Mac or Windows:

If your are on Mac or Windows, you must change every **localhost** with the ip address given by docker on startup.
You can see it by typing from the Docker QuickStart Terminal : `docker-machine ip`

## Getting started

### Download docker-chouette

```
git clone https://github.com/afimb/docker-chouette.git
```

or download the archive: https://github.com/afimb/docker-chouette/archive/master.zip

### Download the images docker

```
docker-compose pull
```

### Start all containers

```
docker-compose up
```

wait containers to be started...

then go to http://localhost:3000
also open Mailcatcher http://localhost:1080 to catch emails

