# app-admin.py
import mysql.connector
from db_utils import connect_db, authenticate

def admin_menu():
    """
    Displays the menu of options available for an admin account.
    The admin can input the number associated with the option they wish to execute.
    """
    print("\nAdmin Menu:")
    print("1. Add Student")
    print("2. Delete Student")
    print("3. Add Article")
    print("4. Delete Article")
    print("5. Update Information")
    print("6. Exit")

def add_student(conn):
    """
    Adds a new student to the database by inserting their details into the `account` and `student` tables.

    Args:
        conn (mysql.connector.connection.MySQLConnection): A connection object to the MySQL database.
    """
    uid = input("Enter UID: ")
    username = input("Enter username: ")
    email = input("Enter email: ")
    password = input("Enter password: ")
    name = input("Enter name: ")
    age = int(input("Enter age: "))
    major = input("Enter major: ")
    house = input("Enter house: ")
    grad_year = int(input("Enter graduation year: "))

    cursor = conn.cursor()
    try:
        # Add to account table
        cursor.callproc('sp_add_user', (uid, username, email, password))
        # Add to student table
        cursor.execute("""
            INSERT INTO student (uid, name, age, major, house, grad_year)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (uid, name, age, major, house, grad_year))
        conn.commit()
        print("Student added successfully!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()

def delete_student(conn):
    """
    Deletes a student from the database by removing their entry from the `account` table.

    Args:
        conn (mysql.connector.connection.MySQLConnection): A connection object to the MySQL database.
    """
    uid = input("Enter UID of student to delete: ")
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM account WHERE uid = %s", (uid,))
        conn.commit()
        print("Student deleted successfully!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()

def main():
    username = input("Enter username: ")
    password = input("Enter password: ")

    if not authenticate(username, password):
        print("Invalid credentials.")
        return

    conn = connect_db('admin')
    while True:
        admin_menu()
        choice = input("Enter your choice: ")
        if choice == '1':
            add_student(conn)
        elif choice == '2':
            delete_student(conn)
        elif choice == '6':
            break
    conn.close()

if __name__ == "__main__":
    main()