import bcrypt
import mysql.connector
from dotenv import load_dotenv
import os

load_dotenv()
DB_HOST = os.getenv("DB_HOST")
DB_USER_ADMIN = os.getenv("DB_USER_ADMIN")
DB_PASSWORD_ADMIN = os.getenv("DB_PASSWORD_ADMIN")
DB_NAME = os.getenv("DB_NAME")


DB_USER_STUDENT = os.getenv("DB_USER_STUDENT")
DB_PASSWORD_STUDENT = os.getenv("DB_PASSWORD_STUDENT")

def store_user(uid, username, email, password):

    hashed_pw = hash_password(password)

    # uids 1111111, 0000000 are not associated with any actual students
    # in the Caltech system, 
    # can be hard-coded as admin uids 
    if uid in ['1111111', '0000000']: 
    
        conn = mysql.connector.connect(
                host=DB_HOST,
                user=DB_USER_ADMIN,
                password=DB_PASSWORD_ADMIN,
                database=DB_NAME
        )

    else: 
        conn = mysql.connector.connect(
                host=DB_HOST,
                user=DB_USER_STUDENT,
                password=DB_PASSWORD_STUDENT,
                database=DB_NAME
        )
    cursor = conn.cursor()

    query = """
    INSERT INTO account (uid, username, email, password_hash)
    VALUES (%s, %s, %s, %s)
    """
    cursor.execute(query, (uid, username, email, hashed_pw))
    conn.commit()
    cursor.close()
    conn.close()

def hash_password(password: str) -> str:
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')

def verify_password(password, hashed):
    return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))

