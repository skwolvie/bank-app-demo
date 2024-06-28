#!/bin/bash
set -e

# Run the schema creation
PGPASSWORD=$POSTGRES_PASSWORD psql -h $DB_HOST -U $POSTGRES_USER -d $POSTGRES_DB -f /docker-entrypoint-initdb.d/0_init_tables.sql

# Run the transaction creation script
export PGPASSWORD=$POSTGRES_PASSWORD
export PGHOST=$DB_HOST
export PGUSER=$POSTGRES_USER
export PGDATABASE=$POSTGRES_DB
/docker-entrypoint-initdb.d/1_create_transactions.sh

echo "Ledger database initialization completed."
