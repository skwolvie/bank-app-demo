#!/bin/bash
set -e

# Run the schema creation
PGPASSWORD=$POSTGRES_PASSWORD psql -h $DB_HOST -p 5432 -U $POSTGRES_USER -d $POSTGRES_DB -f /docker-entrypoint-initdb.d/0-accounts-schema.sql
#
# Run the test data loading
PGPASSWORD=$POSTGRES_PASSWORD psql -h $DB_HOST -p 5432 -U $POSTGRES_USER -d $POSTGRES_DB -f /docker-entrypoint-initdb.d/1-load-testdata.sql

echo "Database initialization completed."
