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
    # Determine the database user based on uid
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

    try:
        # Call the stored procedure to insert the user
        cursor.callproc('sp_add_user', (uid, username, email, password))
        conn.commit()
    except mysql.connector.Error as err:
        raise ValueError(f"Database error: {err}")
    finally:
        cursor.close()
        conn.close()

def verify_password(username, password):
    conn = mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER_STUDENT,
        password=DB_PASSWORD_STUDENT,
        database=DB_NAME
    )
    cursor = conn.cursor()

    try:
        # Call the authenticate function
        query = "SELECT authenticate(%s, %s)"
        cursor.execute(query, (username, password))
        result = cursor.fetchone()
        if result and result[0] == 1:
            print("Password verified.")
            return True
        else:
            print("Invalid username or password.")
            return False
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return False
    finally:
        cursor.close()
        conn.close()