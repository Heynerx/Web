#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE ROLE replicator WITH REPLICATION PASSWORD 'replicator_password' LOGIN;
    SELECT pg_create_physical_replication_slot('replica_1_slot');
    SELECT pg_create_physical_replication_slot('replica_2_slot');
EOSQL

echo "host replication replicator 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
