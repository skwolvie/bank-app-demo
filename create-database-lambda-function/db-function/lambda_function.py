# Description: This Lambda function creates a new user and a new database in a PostgreSQL database.

# Import the PostgreSQL python adapter library
import psycopg2
import json

# Define the lambda handler function
def lambda_handler(event, context):
    # Extract details from the 'event' object
    db_name = event.get('dbname')
    db_user = event.get('dbuser')
    db_password = event.get('dbpassword')
    db_host = event.get('dbhost')
    new_user = event.get('newuser')
    new_user_password = event.get('newuserpassword')
    new_db = event.get('newdb')
    
    try:
        # Connect to your database
        conn = psycopg2.connect(
            dbname=db_name,
            user=db_user,
            password=db_password,
            host=db_host,
            port="5432"
        )

        # Set connection to autocommit mode
        conn.autocommit = True

        # Open a cursor to perform database operations
        cur = conn.cursor()
        
        # Since we're in autocommit mode, we don't need an explicit transaction block
        try:
            # Create a new user
            cur.execute(f"CREATE USER {new_user} WITH PASSWORD '{new_user_password}';")
        except psycopg2.Error as e:
            print(f"Skipping user creation, encountered an error: {e}")
        
        try:
            # Create the new database
            cur.execute(f"CREATE DATABASE {new_db};")
        except psycopg2.Error as e:
            print(f"Skipping database creation, encountered an error: {e}")
        
        try:
            # Alter the database owner to the new user
            cur.execute(f"ALTER DATABASE {new_db} OWNER TO {new_user};")
        except psycopg2.Error as e:
            print(f"Error during operation: {e}")
        
        # Note: No need to commit since we're in autocommit mode
        
        # Close communication with the database
        cur.close()
        conn.close()
        return {
            'statusCode': 200,
            'body': json.dumps('Database and user created successfully.')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(str(e))
        }
