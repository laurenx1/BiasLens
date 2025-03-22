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
    print("5. Update Student/Account Information")
    print("6. Update Article Information")
    print("7. Exit")


def add_student(conn):
    """
    Adds a new student to the database by calling the `sp_add_student_db` stored procedure.

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
        cursor.callproc('sp_add_student_db', (uid, username, email, password, name, age, major, house, grad_year))
        conn.commit()
        print("Student added successfully!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()


def delete_student(conn):
    """
    Deletes a student from the database by calling the `sp_delete_student` stored procedure.

    Args:
        conn (mysql.connector.connection.MySQLConnection): A connection object to the MySQL database.
    """
    uid = input("Enter UID of student to delete: ")
    cursor = conn.cursor()
    try:
        cursor.callproc('sp_delete_student', (uid,))
        conn.commit()
        print("Student deleted successfully!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()


def add_article(conn):
    """
    Adds a new article to the database by calling the `sp_add_article` stored procedure.

    Args:
        conn (mysql.connector.connection.MySQLConnection): A connection object to the MySQL database.
    """
    keyword = input("Enter keyword: ")
    article_title = input("Enter article title: ")
    author = input("Enter author: ")
    publisher = input("Enter publisher: ")
    ai_or_web = input("Enter source (ai or web): ")
    sensation_score = float(input("Enter sensation score: "))
    sentiment_score = int(input("Enter sentiment score: "))

    cursor = conn.cursor()
    try:
        cursor.callproc('sp_add_article', (keyword, article_title, author, publisher, ai_or_web, sensation_score, sentiment_score))
        conn.commit()
        print("Article added successfully!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()


def delete_article(conn):
    """
    Deletes an article from the database by calling the `sp_delete_article` stored procedure.

    Args:
        conn (mysql.connector.connection.MySQLConnection): A connection object to the MySQL database.
    """
    article_id = input("Enter article ID to delete: ")
    cursor = conn.cursor()
    try:
        cursor.callproc('sp_delete_article', (article_id,))
        conn.commit()
        print("Article deleted successfully!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()


def update_student_account_info(conn):
    """
    Updates student or account information by calling the `sp_update_student_account_info` stored procedure.

    Args:
        conn (mysql.connector.connection.MySQLConnection): A connection object to the MySQL database.
    """
    uid = input("Enter UID of the student to update: ")
    print("What would you like to update?")
    print("1. Username")
    print("2. Email")
    print("3. Password")
    print("4. Name")
    print("5. Age")
    print("6. Major")
    print("7. House")
    print("8. Graduation Year")
    choice = input("Enter your choice: ")

    cursor = conn.cursor()
    try:
        if choice == '1':
            new_username = input("Enter new username: ")
            cursor.callproc('sp_update_student_account_info', (uid, 'username', new_username))
        elif choice == '2':
            new_email = input("Enter new email: ")
            cursor.callproc('sp_update_student_account_info', (uid, 'email', new_email))
        elif choice == '3':
            new_password = input("Enter new password: ")
            cursor.callproc('sp_update_student_account_info', (uid, 'password_hash', new_password))
        elif choice == '4':
            new_name = input("Enter new name: ")
            cursor.callproc('sp_update_student_account_info', (uid, 'name', new_name))
        elif choice == '5':
            new_age = int(input("Enter new age: "))
            cursor.callproc('sp_update_student_account_info', (uid, 'age', new_age))
        elif choice == '6':
            new_major = input("Enter new major: ")
            cursor.callproc('sp_update_student_account_info', (uid, 'major', new_major))
        elif choice == '7':
            new_house = input("Enter new house: ")
            cursor.callproc('sp_update_student_account_info', (uid, 'house', new_house))
        elif choice == '8':
            new_grad_year = int(input("Enter new graduation year: "))
            cursor.callproc('sp_update_student_account_info', (uid, 'grad_year', new_grad_year))
        else:
            print("Invalid choice.")
            return

        conn.commit()
        print("Information updated successfully!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()


def update_article_info(conn):
    """
    Updates article information by calling the `sp_update_article_info` stored procedure.

    Args:
        conn (mysql.connector.connection.MySQLConnection): A connection object to the MySQL database.
    """
    article_id = input("Enter article ID to update: ")
    print("What would you like to update?")
    print("1. Keyword")
    print("2. Article Title")
    print("3. Author")
    print("4. Publisher")
    print("5. Source (ai or web)")
    print("6. Sensation Score")
    print("7. Sentiment Score")
    choice = input("Enter your choice: ")

    cursor = conn.cursor()
    try:
        if choice == '1':
            new_keyword = input("Enter new keyword: ")
            cursor.callproc('sp_update_article_info', (article_id, 'keyword', new_keyword))
        elif choice == '2':
            new_title = input("Enter new article title: ")
            cursor.callproc('sp_update_article_info', (article_id, 'article_title', new_title))
        elif choice == '3':
            new_author = input("Enter new author: ")
            cursor.callproc('sp_update_article_info', (article_id, 'author', new_author))
        elif choice == '4':
            new_publisher = input("Enter new publisher: ")
            cursor.callproc('sp_update_article_info', (article_id, 'publisher', new_publisher))
        elif choice == '5':
            new_source = input("Enter new source (ai or web): ")
            cursor.callproc('sp_update_article_info', (article_id, 'ai_or_web', new_source))
        elif choice == '6':
            new_sensation_score = float(input("Enter new sensation score: "))
            cursor.callproc('sp_update_article_info', (article_id, 'sensation_score', new_sensation_score))
        elif choice == '7':
            new_sentiment_score = int(input("Enter new sentiment score: "))
            cursor.callproc('sp_update_article_info', (article_id, 'sentiment_score', new_sentiment_score))
        else:
            print("Invalid choice.")
            return

        conn.commit()
        print("Article information updated successfully!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()


def main():
    """
    Main function to handle admin login and interaction with the admin menu.
    """
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
        elif choice == '3':
            add_article(conn)
        elif choice == '4':
            delete_article(conn)
        elif choice == '5':
            update_student_account_info(conn)
        elif choice == '6':
            update_article_info(conn)
        elif choice == '7':
            break
    conn.close()


if __name__ == "__main__":
    main()