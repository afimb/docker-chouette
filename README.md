Chouette2 is an open source web project in Ruby/Rails for editing and viewing Public Transport data
For more information see https://github.com/afimb/chouette2/
and http://www.chouette.mobi

## For Linux/Ubuntu
If you are new to docker : so as to avoid lauching docker with sudo, docker, you'll need to add your user to the docker group (if it doesn't exist : `sudo groupadd docker`) ;
for Ubuntu the command will be
`sudo adduser nom_utilisateur docker`
or
`sudo usermod -a -G docker nom_utilisateur`
Then restart docker
```
docker-compose up
```
wait containers to be started...

then go to http://localhost:3000
