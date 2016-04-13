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
