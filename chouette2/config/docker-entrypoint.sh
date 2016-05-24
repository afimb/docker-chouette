#!/bin/bash

function waitPostgres {
  status="closed"
  while [[ $status == *"closed"* ]];do
    status=$(nmap -v -p 5432 chouette-postgres)
    echo 'Waiting for Postgres...'
    sleep 2
  done
}

waitPostgres

/home/chouette/bin/chouette.sh

tail -f /home/chouette/bin/chouette.sh


