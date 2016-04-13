FROM postgres

RUN su - postgres -c "psql -c 'CREATE USER chouette WITH ENCRYPTED PASSWORD \'chouette\'"
psql -c 'ALTER USER chouette SUPERUSER'; \
				createdb -O chouette iev; \
				createdb -O chouette -E UTF-8 -T template1 chouette2; \
				createdb -O chouette -E UTF-8 -T template1 chouette_dev; \
				createdb -O chouette -E UTF-8 -T template1 chouette_test"
