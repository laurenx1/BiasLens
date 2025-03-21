# app-student.py
from db_utils import connect_db, authenticate, signup

def student_menu():
    print("\nStudent Menu:")
    print("1. View Average Sensation Score (by UID)")
    print("2. View Average Sensation Score (by Username)")
    print("3. Rank Students by Category (House, Major, Year, etc.)")
    print("4. View Self Stats (Rankings within Major, Year, and House)")
    print("5. View Top X Students by Sensation Score")
    print("6. Exit")

def view_avg_sensation_by_uid(conn, uid):
    cursor = conn.cursor()
    cursor.execute("SELECT get_avg_sensation_by_uid(%s)", (uid,))
    result = cursor.fetchone()[0]
    print(f"Your average sensation score is: {result}")
    cursor.close()

def view_avg_sensation_by_username(conn, username):
    cursor = conn.cursor()
    cursor.execute("SELECT get_avg_sensation_by_username(%s)", (username,))
    result = cursor.fetchone()[0]
    print(f"Your average sensation score is: {result}")
    cursor.close()

def rank_by_choice(conn):
    print("\nRank by Category:")
    print("y - Graduation Year")
    print("h - House")
    print("m - Major")
    print("a - Age")
    print("f - UID")
    choice = input("Enter your choice: ").strip().lower()

    cursor = conn.cursor()
    try:
        cursor.callproc('rank_by_choice', (choice,))
        for result in cursor.stored_results():
            rows = result.fetchall()
            for row in rows:
                print(row)
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()

def view_self_stats(conn, uid):
    cursor = conn.cursor()
    try:
        cursor.callproc('view_self_stats', (uid,))
        for result in cursor.stored_results():
            rows = result.fetchall()
            for row in rows:
                print(f"Average Score: {row[0]}")
                print(f"Total Score: {row[1]}")
                print(f"Rank in Major: {row[2]}")
                print(f"Rank in Year: {row[3]}")
                print(f"Rank in House: {row[4]}")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()

def view_top_x(conn):
    x = int(input("Enter the number of top students to view: "))
    cursor = conn.cursor()
    try:
        cursor.callproc('view_top_x', (x,))
        for result in cursor.stored_results():
            rows = result.fetchall()
            for row in rows:
                print(f"UID: {row[0]}, Name: {row[1]}, Avg Score: {row[2]}")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()

def main():
    print("1. Login")
    print("2. Signup")
    choice = input("Enter your choice: ")

    if choice == '1':
        username = input("Enter username: ")
        password = input("Enter password: ")
        if not authenticate(username, password):
            print("Invalid credentials.")
            return
    elif choice == '2':
        uid = input("Enter UID: ")
        username = input("Enter username: ")
        email = input("Enter email: ")
        password = input("Enter password: ")
        signup(uid, username, email, password)
        return
    else:
        print("Invalid choice.")
        return

    conn = connect_db('student')
    uid = input("Enter your UID: ")  # Prompt for UID after login
    while True:
        student_menu()
        choice = input("Enter your choice: ")
        if choice == '1':
            view_avg_sensation_by_uid(conn, uid)
        elif choice == '2':
            view_avg_sensation_by_username(conn, username)
        elif choice == '3':
            rank_by_choice(conn)
        elif choice == '4':
            view_self_stats(conn, uid)
        elif choice == '5':
            view_top_x(conn)
        elif choice == '6':
            break
    conn.close()

if __name__ == "__main__":
    main()