FROM postgres:15

# Copy initialization scripts
COPY 0-accounts-schema.sql /docker-entrypoint-initdb.d/
COPY 1-load-testdata.sql /docker-entrypoint-initdb.d/

# Set environment variable for demo data
ENV USE_DEMO_DATA=True

# Install any additional tools if needed
RUN apt-get update && apt-get install -y curl

# Create an entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
