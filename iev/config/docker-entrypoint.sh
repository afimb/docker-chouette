#!/bin/bash
set -e

sh /opt/jboss/wildfly/bin/jboss-cli.sh --connect --user=admin --password=admin  --file=/tmp/wildfly-datasources.cli
sh /opt/jboss/wildfly/bin/jboss-cli.sh --connect --user=admin --password=admin --command="deploy /tmp/chouette.ear"

exec "$@"
