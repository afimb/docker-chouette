#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE iev OWNER chouette;
    CREATE DATABASE chouette2 OWNER chouette TEMPLATE template1;
    CREATE DATABASE chouette_test OWNER chouette TEMPLATE template1;
EOSQL
