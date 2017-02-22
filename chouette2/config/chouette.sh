#!/bin/bash

CHOUETTE_HOME=`dirname $0`/..
source $CHOUETTE_HOME/.bashrc
source $CHOUETTE_HOME/bin/chouette.conf
source $CHOUETTE_HOME/.bash_profile

cd $CHOUETTE_HOME/chouette-gui/

echo "RAILS_ENV=$RAILS_ENV"
export RAILS_ENV=${RAILS_ENV:-production}

echo "Remove old PID file..."
rm -f tmp/pids/server.pid

echo "Chouette init postgis..."
bin/rake db:gis:setup

echo "Chouette migrate..."
bin/rake db:migrate

echo "Chouette Ruby starting..."
bin/rails s -b 0.0.0.0 -p 3000

