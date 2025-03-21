# db_utils.py
import mysql.connector


def connect_db(role):
    if role == 'admin':
        return mysql.connector.connect(
            host='localhost',
            user='biaslensadmin',
            password='fakepassword123',
            database='biaslensDB'
        )
    elif role == 'student':
        return mysql.connector.connect(
            host='localhost',
            user='biaslensstudent',
            password='fakepw1234567',
            database='biaslensDB'
        )
    else:
        raise ValueError("Invalid role specified.")
    

def authenticate(username, password):
    conn = connect_db('student')  # Use student role for authentication
    cursor = conn.cursor()
    cursor.execute("SELECT authenticate(%s, %s)", (username, password))
    result = cursor.fetchone()[0]
    cursor.close()
    conn.close()
    return result == 1


def signup(uid, username, email, password):
    conn = connect_db('student')  # Use student role for signup
    cursor = conn.cursor()
    try:
        cursor.callproc('sp_add_user', (uid, username, email, password))
        conn.commit()
        print("Signup successful!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()
        conn.close()


