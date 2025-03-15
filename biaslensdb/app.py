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

        query = "SELECT * FROM users WHERE username = %s"
        cursor.execute(query, (username,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()

        if user and verify_password(password, user['password_hash']):
            return jsonify({'message': 'Login successful!'}), 200
        else:
            return jsonify({'error': 'Invalid credentials!'}), 401
    except mysql.connector.Error as err:
        return jsonify({'error': f"Database error: {err}"}), 500

if __name__ == '__main__':
    app.run(debug=True)