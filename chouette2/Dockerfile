FROM centos:6.6
MAINTAINER Cityway

LABEL Description="Chouette GUI" \
      Usage="docker run -it --name chouette2 --link chouette-postgres:chouette-postgres --link smtp:smtp --link chouette-iev:chouette-iev -p 3000:3000 -d chouette2" \
      BuildUsage="docker build -t chouette2 ." \
      License="CECILL/B" \
      Version="3.0"

RUN yum -y install epel-release && yum -y update 
#RUN yum -y localinstall http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm
RUN yum -y localinstall https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-2.noarch.rpm
RUN yum -y install which tar git postgresql94-devel proj proj-devel geos-devel nmap

#-- Add user chouette
RUN adduser chouette
RUN su - chouette sh -c "mkdir ~/chouette-gui"

#-- Install Ruby
RUN gpg2 --keyserver  hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable --rails
RUN usermod -a -G rvm chouette
RUN su - chouette -c "rvm install ruby-2.3.0 && rvm --default use 2.3.0 && gem install bundler && bundle config build.pg --with-pg-config=/usr/pgsql-9.4/bin/pg_config"

#-- Install Chouette 2
RUN su - chouette -c "git clone -b $GIT_BRANCH git://github.com/afimb/chouette2 ~/chouette-gui/ && cd ~/chouette-gui && bundle install"

#-- Configure Chouette2
RUN mkdir /home/chouette/bin
COPY config/chouette.sh /home/chouette/bin
COPY config/chouette.conf /home/chouette/bin
COPY config/application.yml /home/chouette/chouette-gui/config/
COPY config/smtp_settings.rb /home/chouette/chouette-gui/config/initializers/
COPY config/database.yml /home/chouette/chouette-gui/config

RUN chown -R chouette: /home/chouette/

EXPOSE 3000

COPY config/docker-entrypoint.sh /
VOLUME ["/home/chouette/chouette-gui/referentials"]
ENTRYPOINT ["/docker-entrypoint.sh"]


