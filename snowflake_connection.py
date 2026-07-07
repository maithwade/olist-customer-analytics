import snowflake.connector
import pandas as pd
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.backends import default_backend

with open("/Users/maithiliwade/Documents/Data Projects/Olist/python_analysis/rsa_key.pem", "rb") as key_file:
    private_key = serialization.load_pem_private_key(
        key_file.read(),
        password=None,
        backend=default_backend()
    )

conn = snowflake.connector.connect(
    account='ELJXLGQ-LE82203',
    user='MAITHILIWADE',
    private_key=private_key,
    database='PC_DBT_DB',
    warehouse='PC_DBT_WH',
    role='ACCOUNTADMIN'
)

cursor = conn.cursor()
cursor.execute("SELECT CURRENT_VERSION()")
print(cursor.fetchone())
conn.close()