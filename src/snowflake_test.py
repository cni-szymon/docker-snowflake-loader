#!/usr/bin/env python
from sqlalchemy import create_engine
from sqlalchemy import text
from snowflake.connector import ProgrammingError, DatabaseError, IntegrityError
import snowflake.connector

import mysql.connector as sql
import pandas as pd

# Function to write error message to a text file
def log_error_to_file(file_name, message):
    with open('../logs/' + file_name, 'a') as file:
        file.write(message + '\n')

# Replace the user, password, host, port, and database with your own details
username = 'dbuser'
password = 'password_goes_here'
host = 'url_goes_here'
port = '3306'  # default MySQL port is 3306
database_name = 'applicants'

applicants_report_filename = 'sql/applicants_dataset_test.sql'
campaigns_report_filename = 'sql/campaign_dataset.sql'
files_uploaded_report_filename = 'sql/files_uploaded_dataset_test.sql'

applicants_snowflake_table = 'source_cir_applicants_us_test'
campaigns_snowflake_table = 'source_cir_campaigns_us_test'
files_uploaded_snowflake_table = 'source_cir_files_uploaded_us_test'

# BBC -> cir-prd-bbc-main-rds-cmk.ckrwh3yhpk85.eu-west-1.rds.amazonaws.com

# Define the MySQL connection string
# Format: dialect+driver://username:password@host:port/database
# The default dialect and driver for MySQL is mysql+mysqlconnector
connection_string = f"mysql+mysqlconnector://{username}:{password}@{host}:{port}/{database_name}"

## snowflake 
snowflake_engine = create_engine(
    'snowflake://{user}:{password}@{account_identifier}/{database_name}/{schema_name}?warehouse={warehouse_name}&role={role_name}'.format(
        user="snowflake_user",
        password="password",
        account_identifier="account_id.eu-west-1",
        database_name="DEV",
        schema_name="public",
        warehouse_name="PC_DBT_WH",
        role_name="ACCOUNTADMIN",
    )
)

try:
    # Create the engine to connect to the MySQL database
    mysql_engine = create_engine(connection_string)
    mysql_connection = mysql_engine.raw_connection()
    # connect to snowflake and insert the DF into the table there
    snow_connection = snowflake_engine.connect()
    # Now you can use the engine to execute queries, create sessions, etc.
    
    # applicants 
    file = open(applicants_report_filename, 'r')
    sql_code = " ".join(file.readlines())
    print('Fetching data from MySQL with query: {}'.format(applicants_report_filename))
    df = pd.read_sql_query(sql_code, mysql_connection)
    # connect to snowflake and insert the DF into the table there
    print('Loading dataframe to Snowflake table: {}'.format(applicants_snowflake_table))
    df.to_sql(applicants_snowflake_table, snowflake_engine, index=False, if_exists='replace', chunksize=10000) #make sure index is False, Snowflake doesnt accept indexes
    print('Data loaded into Snowflake, next load ...')

    # # campaigns
    file = open(campaigns_report_filename, 'r')
    sql_code = " ".join(file.readlines())
    print('Fetching data from MySQL with query: {}'.format(campaigns_report_filename))
    df = pd.read_sql_query(sql_code, mysql_connection)
    print('Loading dataframe to Snowflake table: {}'.format(campaigns_snowflake_table))
    df.to_sql(campaigns_snowflake_table, snowflake_engine, index=False, if_exists='replace', chunksize=10000) #make sure index is False, Snowflake doesnt accept indexes
    print('Data loaded into Snowflake, next load ...')

    # files uploaded
    file = open(files_uploaded_report_filename, 'r')
    sql_code = " ".join(file.readlines())
    print('Fetching data from MySQL with query: {}'.format(files_uploaded_report_filename))
    df = pd.read_sql_query(sql_code, mysql_connection)
    print('Loading dataframe to Snowflake table: {}'.format(campaigns_snowflake_table))
    df.to_sql(files_uploaded_snowflake_table, snowflake_engine, index=False, if_exists='replace', chunksize=10000) #make sure index is False, Snowflake doesnt accept indexes
    print('Data loaded into Snowflake, next load ...')
    

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

finally:
    snow_connection.close()
    snowflake_engine.dispose()
