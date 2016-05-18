#!/bin/bash

CHOUETTE_HOME=`dirname $0`/..
source $CHOUETTE_HOME/.bashrc
source $CHOUETTE_HOME/bin/chouette.conf

cd $CHOUETTE_HOME/chouette-gui/

echo "RAILS_ENV=$RAILS_ENV"
export RAILS_ENV=${RAILS_ENV:-production}

echo "Chouette create databases..."
bundle exec rake db:create

echo "Chouette init postgis..."
bundle exec rake db:gis:setup

echo "Chouette migrate..."
bundle exec rake db:migrate

echo "Chouette Ruby starting..."
bundle exec rails server

