import psycopg2
import os
import json
from psycopg2.extras import RealDictCursor

# Construct the path to the JSON file in the parent folder
current_directory = os.path.dirname(os.path.abspath(__file__))
parent_directory = os.path.abspath(os.path.join(current_directory, os.pardir))
json_file_path = os.path.join(parent_directory, 'database.json')

# Open the JSON file and load the data into a dictionary
with open(json_file_path, 'r') as file:
    config = json.load(file)

def db():
    return psycopg2.connect(
        host=config['host'],
        user=config['user'],
        password=config['password'],
        dbname=config['database'],  # assuming 'database' is the key in your JSON file
        port=config['port'],
        cursor_factory=RealDictCursor  # Allows access via column name like locations['locationdesc'] instead of locations[1].
    )

def run(query: str, vars=(), fetch=True):
    with db() as conn:
        with conn.cursor() as cur:
            print(f'[db.run]: VARS = {vars}, SQL = [{query}]')
            cur.execute(query, vars)
            if fetch:
                return cur.fetchall()
