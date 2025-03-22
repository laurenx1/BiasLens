# db_utils.py
import mysql.connector


def connect_db(role):
    """
    Establishes a connection to the MySQL database based on the specified role.

    Args:
        role (str): The role of the user connecting to the database. 
                    Valid roles are 'admin' and 'student'.

    Returns:
        mysql.connector.connection.MySQLConnection: A connection object to the MySQL database.

    Raises:
        ValueError: If an invalid role is specified.
    """
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
    

def authenticate(username, password, expected_role):
    """
    Authenticates a user by checking the provided username and password against the database.

    Args:
        username (str): The username of the user attempting to authenticate.
        password (str): The password of the user attempting to authenticate.
        expected_role (str): The role expected for the login attempt ('admin' or 'student').

    Returns:
        bool: True if authentication is successful, False otherwise.
    """
    conn = connect_db('student')  # Use student role for authentication
    cursor = conn.cursor()
    cursor.execute("SELECT authenticate(%s, %s)", (username, password))
    result = cursor.fetchone()[0]

    if result != 1:
        cursor.close()
        conn.close()
        return False
    
    cursor.execute("SELECT is_admin FROM account WHERE username = %s", (username,))
    user_is_admin = cursor.fetchone()[0]


    cursor.close()
    conn.close()
    if expected_role == "admin" and user_is_admin == 1:
        return True  # Admin trying to log in as admin -> OK
    elif expected_role == "student" and user_is_admin == 0:
        return True  # Student trying to log in as student -> OK
    else:
        return False  # Role mismatch -> Block access


def signup(uid, username, email, password):
    """
    Registers a new user in the database by calling a stored procedure.

    Args:
        uid (str): The unique identifier for the new user.
        username (str): The username for the new user.
        email (str): The email address for the new user.
        password (str): The password for the new user.

    Returns:
        None
    """
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


