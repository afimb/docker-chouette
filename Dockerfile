FROM centos:6.6
MAINTAINER dlallemand@cityway.fr

ENV CHOUETTE_IEV_VERSION 3.3.1-SNAPSHOT
ENV CHOUETTE_WEB_VERSION develop
ENV MAVEN_REPO maven-snapshot

RUN sed -i "s/\[base\]/\[base\]\nexclude=postgresql*/g" /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i "s/\[updates\]/\[updates\]\nexclude=postgresql*/g" /etc/yum.repos.d/CentOS-Base.repo

#-- Update Centos
RUN yum -y install epel-release && yum -y update && \
    yum -y localinstall http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm

#--Install Tools
RUN yum -y install wget curl make git unzip vim procps gnupg2 proj proj-devel geos-devel lynx \
    postgresql93-server postgis2_93.x86_64 postgresql93-libs postgresql93-devel tar \
    java-1.7.0-openjdk.x86_64 apache-maven

#-- Add user chouette
RUN adduser chouette
RUN su - chouette sh -c "mkdir ~/chouette-gui"

#-- Install Ruby
RUN gpg2 --keyserver  hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable --rails
RUN usermod -a -G rvm chouette
RUN su - chouette -c "rvm install ruby-2.3.0 && rvm --default use 2.3.0 && gem install bundler && bundle config build.pg --with-pg-config=/usr/pgsql-9.3/bin/pg_config"

#-- Install Chouette 2 
RUN su - chouette -c "git clone -b ${CHOUETTE_WEB_VERSION} git://github.com/afimb/chouette2 ~/chouette-gui/ && cd ~/chouette-gui && bundle install"

#-- Install Wildfly
RUN wget -q http://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz && tar xzf wildfly-9.0.2.Final.tar.gz && \
    mv wildfly-9.0.2.Final /opt/wildfly && rm wildfly-9.0.2.Final.tar.gz && adduser wildfly && chown -R wildfly:wildfly /opt/wildfly && \
    usermod -d /opt/wildfly wildfly && ln -s /opt/wildfly/bin/init.d/wildfly-init-debian.sh /etc/init.d/wildfly

#-- Configure Wildfly
RUN mkdir -p /etc/default/wildfly
ADD config/wildfly.conf /etc/default/
ADD config/wildfly-init-redhat.sh /etc/init.d/wildfly
RUN sh /opt/wildfly/bin/add-user.sh admin admin && \
    wget -q https://jdbc.postgresql.org/download/postgresql-9.3-1103.jdbc41.jar -P /opt/wildfly
ADD config/jboss/cli/wildfly-datasources.cli /opt/wildfly/
RUN /etc/init.d/wildfly start && \
    sh /opt/wildfly/bin/jboss-cli.sh --connect --user=admin --password=admin  --file=/opt/wildfly/wildfly-datasources.cli

###-- Update hibernate module
RUN wget -q http://www.hibernatespatial.org/repository/org/hibernate/hibernate-spatial/4.3/hibernate-spatial-4.3.jar -P /tmp && \
    wget -q http://central.maven.org/maven2/com/vividsolutions/jts/1.13/jts-1.13.jar -P /tmp && \
    cp /tmp/hibernate-spatial-*.jar /tmp/jts-*.jar /opt/wildfly/modules/system/layers/base/org/hibernate/main/ && \
    cp /opt/wildfly/modules/system/layers/base/org/hibernate/main/module.xml /opt/wildfly/modules/system/layers/base/org/hibernate/main/module.xml.sav && \
    sed -i '/<resources>/a\\t<resource-root path="hibernate-spatial-4.3.jar"/>'  /opt/wildfly/modules/system/layers/base/org/hibernate/main/module.xml && \
    sed -i '/<resources>/a\\t<resource-root path="jts-1.13.jar"/>'  /opt/wildfly/modules/system/layers/base/org/hibernate/main/module.xml && \
    sed -i '/<dependencies>/a\\t<module name="org.postgres"/>'  /opt/wildfly/modules/system/layers/base/org/hibernate/main/module.xml && \
    chown -R wildfly: /opt/wildfly

#-- Install Chouette_IEV
RUN wget http://${MAVEN_REPO}.chouette.mobi/mobi/chouette/chouette_iev/${CHOUETTE_IEV_VERSION}/maven-metadata.xml && \
    CHOUETTE_EAR_VERSION=`sed -n 's:.*<version>\(.*\)</version>.*:\1:p' maven-metadata.xml` && \
    CHOUETTE_EAR_VERSION=${CHOUETTE_EAR_VERSION%SNAPSHOT} && \
    CHOUETTE_EAR_VERSION+=`sed -n 's:.*<timestamp>\(.*\)</timestamp>.*:\1:p' maven-metadata.xml` && \
    CHOUETTE_EAR_VERSION+='-' && \
    CHOUETTE_EAR_VERSION+=`sed -n 's:.*<buildNumber>\(.*\)</buildNumber>.*:\1:p' maven-metadata.xml` && \
    wget -q http://${MAVEN_REPO}.chouette.mobi/mobi/chouette/chouette_iev/${CHOUETTE_IEV_VERSION}/chouette_iev-${CHOUETTE_EAR_VERSION}.ear && \
    cp chouette_iev-*.ear /opt/wildfly/standalone/deployments/chouette.ear

#-- Copy confirm registration script
ADD config/confirm-registration.sh /home/chouette/
RUN chmod 777  /home/chouette/confirm-registration.sh && echo "localhost:5432:chouette_dev:chouette:chouette" > /home/chouette/.pgpass && \
    chmod 600  /home/chouette/.pgpass && chown chouette:chouette /home/chouette/.pgpass /home/chouette/confirm-registration.sh && \
    echo "localhost:5432:chouette_dev:chouette:chouette" > /root/.pgpass && chmod 600  /root/.pgpass

#-- Configure Chouette2
RUN mkdir /home/chouette/bin
COPY config/chouette-init.sh /etc/init.d/chouette
COPY config/chouette.sh /home/chouette/bin
COPY config/chouette.conf /home/chouette/bin
COPY config/application.yml /home/chouette/chouette-gui/config/
COPY config/smtp_settings.rb /home/chouette/chouette-gui/config/initializers/

RUN chown -R chouette: /home/chouette/

EXPOSE 8080 9990 3000 5432

COPY config/docker-entrypoint.sh /
VOLUME ["/var/lib/pgsql/9.3", "/home/chouette/chouette-gui/referentials"]
ENTRYPOINT ["/docker-entrypoint.sh"]

