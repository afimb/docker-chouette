#!/bin/bash
CMD=$1

POSTGRES_HOME=/var/lib/pgsql/9.3/

if [ ! -e ${POSTGRES_HOME}/data/pg_hba.conf ];then
		echo "Init postgresql db..."
		service postgresql-9.3 initdb

		#-- Configure postgres
		echo "Configure pg_hba access..."
		cat ${POSTGRES_HOME}/data/pg_hba.conf |egrep -v "all.*all.*ident" > /tmp/pg_hba.conf && mv /tmp/pg_hba.conf ${POSTGRES_HOME}/data/pg_hba.conf

		echo "#Chouette_dev remote Access--" >> ${POSTGRES_HOME}/data/pg_hba.conf
		echo "host    chouette_dev          	chouette         ::1/128                md5" >> ${POSTGRES_HOME}/data/pg_hba.conf
		echo "host    chouette_dev          	chouette         0.0.0.0/0              md5" >> ${POSTGRES_HOME}/data/pg_hba.conf
		echo "host    iev         		chouette         ::1/128                md5" >> ${POSTGRES_HOME}/data/pg_hba.conf
		echo "host    iev         		chouette         0.0.0.0/0              md5" >> ${POSTGRES_HOME}/data/pg_hba.conf
		echo "host    chouette2   		chouette         ::1/128                md5" >> ${POSTGRES_HOME}/data/pg_hba.conf
		echo "host    chouette2    		chouette         0.0.0.0/0              md5" >> ${POSTGRES_HOME}/data/pg_hba.conf
		echo "host    chouette_test         	chouette         ::1/128                md5" >> ${POSTGRES_HOME}/data/pg_hba.conf
		##--  add ``listen_addresses`` 
		echo "listen_addresses='*'" >> ${POSTGRES_HOME}/data/postgresql.conf

		#-- create databases
		service postgresql-9.3 restart 
		echo "Create databases..."
		su - postgres -c "psql -c \"CREATE USER chouette WITH ENCRYPTED PASSWORD 'chouette';\"; \
				psql -c 'ALTER USER chouette SUPERUSER'; \
				createdb -O chouette iev; \
				createdb -O chouette -E UTF-8 -T template1 chouette2; \
				createdb -O chouette -E UTF-8 -T template1 chouette_dev; \
				createdb -O chouette -E UTF-8 -T template1 chouette_test"

		su - chouette -c "cd ~/chouette-gui; source ~/bin/chouette.conf; bundle exec rake db:gis:setup"

fi

su - chouette <<'EOF'
cd ~/chouette-gui
grep 'SECRET_KEY' config/application.yml && SECRET_KEY=$(bundle exec rake secret | tail -1) && sed -i -e s/SECRET_KEY/${SECRET_KEY}/g config/application.yml
EOF

service postgresql-9.3 stop
service postgresql-9.3 start
service chouette start
service wildfly stop
service wildfly start
bash

