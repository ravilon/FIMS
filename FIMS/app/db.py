import psycopg2
import os

from psycopg2.extras import RealDictCursor

def db():
    return psycopg2.connect(
        host='localhost',
        user=os.environ['DB_USERNAME'],
        password=os.environ['DB_PASSWORD'],
        cursor_factory=RealDictCursor # Allows access via column name like locations['locationdesc'] instead of locations[1].
    )

def run(query: str, vars = (), fetch = True):
    with db() as conn:
        with conn.cursor() as cur:
            print(f'[db.run]: VARS = {vars}, SQL = [{query}]')
            cur.execute(query, vars)
            if fetch: return cur.fetchall()
