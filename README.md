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

## For docker-toolbox on Mac or Windows:

If your are on Mac or Windows, you must change every **localhost** with the ip address given by docker on startup.
You can see it by typing from the Docker QuickStart Terminal : `docker-machine ip`

## Run Mailcatcher to catch emails:
(you can also use letter_opener)

`docker run -d -p 1080:80 --name=smtp tophfr/mailcatcher:0.6.4`

Then open your browser to: http://localhost:1080

## Run Chouette2:

Current stable version is 3.2 if you want to test the next version change at the end of the line `3.2` to `latest`

`docker run -d --link smtp -e SMTP_HOST=smtp -e TZ=Europe/Paris -p 3000:3000 -it --name docker-chouette afimb/docker-chouette:3.2`

Then open your browser to: http://localhost:3000

## Create a Chouette2 user:

The user first has to create an account. The inscription e-mail will be catched by MailCatcher so you'll have to go to localhost:1080 to read the inscription e-mail, click on the confirmation button, which will be bring you back to the chouette2 application, where you can now log in. (If on Mac or Windows, you'll have to substitute localhost by the IP of your docker VM when confirming your inscription...)

## How to use external SMTP like Gmail

To-Do

