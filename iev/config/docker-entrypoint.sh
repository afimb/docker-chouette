#!/bin/bash

INIT_FILE="/opt/jboss/initialized.done"

function waitWildfly {
	status=""
	while [ "$status" != "running" ];do
		status=$(/opt/jboss/wildfly/bin/jboss-cli.sh -c --user=admin --password=admin --commands="read-attribute server-state")
		if [ "$status" != "running" ]; then
			echo "Waiting for Wildfly............"
			sleep 1
		fi
	done
}

function initWildfly {
	waitWildfly
	/opt/jboss/wildfly/bin/jboss-cli.sh -c --user=admin --password=admin --file=/tmp/wildfly-datasources.cli
	/opt/jboss/wildfly/bin/jboss-cli.sh -c --user=admin --password=admin --command="deploy /tmp/chouette.ear"
	/opt/jboss/wildfly/bin/jboss-cli.sh -c --user=admin --password=admin --command="/:reload"
	touch $INIT_FILE
}

[ ! -e $INIT_FILE ] && initWildfly &


[ ! $# -eq 0 ] && echo "Starting wildfly...."
exec "$@"
[ ! $# -eq 0 ] && echo "End wildfly."
