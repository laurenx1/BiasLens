from flask import Flask, request, jsonify
import mysql.connector
from signup_login import store_user, verify_password
from flask_cors import CORS
from dotenv import load_dotenv
import os


app = Flask(__name__)
CORS(app)

load_dotenv()
DB_HOST = os.getenv("DB_HOST")
DB_USER_ADMIN = os.getenv("DB_USER_ADMIN")
DB_PASSWORD_ADMIN = os.getenv("DB_PASSWORD_ADMIN")
DB_NAME = os.getenv("DB_NAME")

@app.route('/signup', methods=['POST'])
def signup():
    data = request.json
    uid = data['uid']
    username = data['username']
    email = data['email']
    password = data['password']

    try:
        store_user(uid, username, email, password)
        return jsonify({'message': 'User registered successfully!'}), 201
    except ValueError as e:
        return jsonify({'error': str(e)}), 400
    except mysql.connector.Error as err:
        return jsonify({'error': f"Database error: {err}"}), 500

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data['username']
    password = data['password']

    try:
        conn = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER_ADMIN,
            password=DB_PASSWORD_ADMIN,
            database=DB_NAME
        )
        cursor = conn.cursor(dictionary=True)

        query = "SELECT * FROM account WHERE username = %s"
        cursor.execute(query, (username,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()

        if user and verify_password(password, user['password_hash']):
            # return jsonify({'message': 'Login successful!'}), 200
            if user['is_admin'] == 1:
                return jsonify({'status': 'success', 'redirect': '/admin-dashboard', 'uid': user['uid']})
            elif user['taken_survey'] == 0:
                return jsonify({'status': 'success', 'redirect': '/survey', 'uid': user['uid']})
            else:
                return jsonify({'status': 'success', 'redirect': '/home', 'uid': user['uid']})
        else:
            return jsonify({'error': 'Invalid credentials!'}), 401
    except mysql.connector.Error as err:
        return jsonify({'error': f"Database error: {err}"}), 500
    


@app.route('/submit-survey', methods=['POST'])
def submit_survey():
    try:
        # Get the data from the frontend
        uid = request.json.get('uid')  # Get the UID from the request body
        if not uid:
            return jsonify({"status": "error", "message": "User UID is required"}), 400
        
        name = request.json.get('name')
        major = request.json.get('major')
        grad_year = request.json.get('gradYear')
        age = request.json.get('age')
        house = request.json.get('house')
        

        # Validate input
        if not major or not grad_year or not age or not house or not name:
            return jsonify({"status": "error", "message": "All fields are required"}), 400

        # Connect to the database
        conn = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER_ADMIN,
            password=DB_PASSWORD_ADMIN,
            database=DB_NAME
        )
        
        if conn.is_connected():
            cursor = conn.cursor()

            # enter the student's survey info in the student table
            # if already exists update the information
            query = """
                INSERT INTO student (uid, name, major, grad_year, age, house)
                VALUES (%s, %s, %s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE
                name = VALUES(name),
                major = VALUES(major),
                grad_year = VALUES(grad_year),
                age = VALUES(age),
                house = VALUES(house)
            """
            cursor.execute(query, (uid, name, major, grad_year, age, house))

            # Update the taken_survey flag in the account table
            query = """
                UPDATE account
                SET taken_survey = 1
                WHERE uid = %s
            """
            cursor.execute(query, (uid,))

            # Commit the changes
            conn.commit()

            # Close cursor and connection
            cursor.close()
            conn.close()

            return jsonify({"status": "success", "message": "Survey submitted successfully"}), 200

        else:
            return jsonify({"status": "error", "message": "Database connection failed"}), 500

    except mysql.connector.Error as err:
        # Handle database errors
        return jsonify({"status": "error", "message": f"Database error: {err}"}), 500

    except Exception as e:
        # Handle any other exceptions
        return jsonify({"status": "error", "message": f"An error occurred: {str(e)}"}), 500


    

if __name__ == '__main__':
    app.run(debug=True)