FROM chouette-centos
MAINTAINER dlallemand@cityway.fr

#-- Install Chouette 2
RUN su - chouette -c "git clone -b develop git://github.com/afimb/chouette2 ~/chouette-gui/ && cd ~/chouette-gui && bundle install"

#-- Configure Chouette2
RUN mkdir /home/chouette/bin
COPY config/chouette-init.sh /etc/init.d/chouette
COPY config/chouette.sh /home/chouette/bin
COPY config/chouette.conf /home/chouette/bin
COPY config/application.yml /home/chouette/chouette-gui/config/
COPY config/smtp_settings.rb /home/chouette/chouette-gui/config/initializers/

RUN chown -R chouette: /home/chouette/

EXPOSE 3000

COPY config/docker-entrypoint.sh /
VOLUME ["/home/chouette/chouette-gui/referentials"]
ENTRYPOINT ["/docker-entrypoint.sh"]

# docker build -t chouette2 .
# docker run -it --name chouette2 --link chouette-postgres:chouette-postgres -d chouette2
