#!/usr/bin/env python
from snowflake.connector import ProgrammingError, DatabaseError, IntegrityError
import snowflake.connector

import psycopg2
import os
import boto3

# Function to write error message to a text file
def log_error_to_file(file_name, message):
    with open('../logs/' + file_name, 'a') as file:
        file.write(message + '\n')

# Replace the user, password, host, port, and database with your own details
username = 'user_name_goes_here'
password = 'password_goes_here'
host = 'b21-db-rr.prd.castingnetworks.io'  # cir-prd-us-db.cr4v05shrgei.us-east-1.rds.amazonaws.com
port = 5432  # default MySQL port is 3306
database_name = 'prdb21db'

table_name = 'account'
snowflake_table = f'tmp_cni_{table_name}'
temp_csv_file = f'{table_name}_data.csv'

# Define the SQL connection string
# Format: dialect+driver://username:password@host:port/database
DATABASE_URL = f"postgresql://{username}:{password}@{host}:{port}/{database_name}"

AWS_ACCESS_KEY_ID = 'aws_key_goes_here'
AWS_SECRET_ACCESS_KEY = 'aws_secret_goes_here'
S3_BUCKET_NAME = 'prd-bi-datalake'

snowconn = snowflake.connector.connect(
    user="snowflake_user_goes_here",
    password="snowflake_password_goes_here",
    account="wd94289.eu-west-1",
    role_name="ACCOUNTADMIN",
    database="DOCKER_STG",
    schema="PUBLIC",
    warehouse="PC_DBT_WH"
)

try:
    # Construct the COPY command
    copy_command = f"""COPY {table_name} TO STDOUT WITH (FORMAT CSV, HEADER)"""

    # Create the engine to connect to the database
    conn = psycopg2.connect(f"host={host} dbname={database_name} user={username} password={password}")
    cur = conn.cursor()

    # Execute the COPY command and capture the output (CSV data)
    with open(temp_csv_file, "w") as file:
        cur.copy_expert(copy_command, file)

    # Upload the CSV file to S3
    s3 = boto3.resource('s3',
                   aws_access_key_id=AWS_ACCESS_KEY_ID,
                   aws_secret_access_key=AWS_SECRET_ACCESS_KEY)
    s3.Bucket(S3_BUCKET_NAME).upload_file(temp_csv_file, f'cni_etl_tmp/{temp_csv_file}')  # Replace with desired key

    # # Remove the local temporary file (optional)
    os.remove(temp_csv_file)
        
    # Putting Data using Snowflake STAGE
    copy_command = f"""
    COPY INTO DOCKER_STG.public.{snowflake_table}
    FROM @test_cni_stage_s3/{temp_csv_file}
    FILE_FORMAT = (FORMAT_NAME = test_cni_stage_file_format)
    ON_ERROR = 'CONTINUE';
    """
    snowconn.cursor().execute(copy_command)

except ProgrammingError as e:
    # Handle specific programming errors, e.g., syntax errors in SQL statements
    error_message = f"ProgrammingError occurred: {str(e)}"
    print("ProgrammingError occurred:", e)
    log_error_to_file('general_error_log.txt', error_message)

except IntegrityError as e:
    error_message = f"IntegrityError occurred: {str(e)}"
    print(error_message)
    log_error_to_file('integrity_error_log.txt', error_message)

except DatabaseError as e:
    error_message = f"DatabaseError occurred: {str(e)}"
    print(error_message)
    log_error_to_file('database_error_log.txt', error_message)

except Exception as e:
    error_message = f"An unexpected error occurred: {str(e)}"
    print(error_message)
    log_error_to_file('general_error_log.txt', error_message)
