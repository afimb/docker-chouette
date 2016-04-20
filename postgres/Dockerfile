FROM postgres:9.4

RUN apt-get update && apt-get install -y postgresql-9.4-postgis-2.2 postgresql-contrib-9.4

COPY docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d/

# docker build -t chouette-postgres .
# docker run --name chouette-postgres -p 5433:5432 -e POSTGRES_PASSWORD=chouette -d chouette-postgres
