FROM postgres:15

# Copy initialization scripts
COPY 0_init_tables.sql /docker-entrypoint-initdb.d/
COPY 1_create_transactions.sh /docker-entrypoint-initdb.d/

# Make the shell script executable
RUN chmod +x /docker-entrypoint-initdb.d/1_create_transactions.sh

# Set environment variable for demo data
ENV USE_DEMO_DATA=True

# Install any additional tools if needed
RUN apt-get update && apt-get install -y curl

# Create an entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
