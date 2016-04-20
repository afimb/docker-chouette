#!/bin/bash

CHOUETTE_HOME=`dirname $0`/..
source $CHOUETTE_HOME/.bashrc
source $CHOUETTE_HOME/bin/chouette.conf

cd $CHOUETTE_HOME/chouette-gui/
export BROWSER=/usr/bin/lynx
echo "RAILS_ENV=$RAILS_ENV"
export RAILS_ENV=${RAILS_ENV:-production}

if [ "$RAILS_ENV" == "development" ];then
	echo "Chouette migrate..."
	bundle exec rake db:migrate
fi

echo "Chouette Ruby starting..."
bundle exec rails server &
CHOUETTE_PID=$!
if [ ! -z $CHOUETTE_PIDFILE ]; then
	echo $CHOUETTE_PID > $CHOUETTE_PIDFILE
fi
