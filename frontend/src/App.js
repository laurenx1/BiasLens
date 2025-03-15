import React, { useState } from 'react';
import './App.css';

function App() {
  const [isSignup, setIsSignup] = useState(false);
  const [uid, setUid] = useState('');
  const [email, setEmail] = useState('');
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [message, setMessage] = useState('');

  const handleAuth = async (e) => {
    e.preventDefault();

    const endpoint = isSignup ? 'signup' : 'login';
    const payload = isSignup
      ? { uid, email, username, password }
      : { username, password };

    try {
      const response = await fetch(`http://127.0.0.1:5000/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
        mode: 'cors', // Ensure CORS is enabled
      });

      const data = await response.json();

      if (response.ok) {
        setMessage(data.message);
        setError('');
      } else {
        setError(data.error || 'An error occurred.');
      }
    } catch (err) {
      setError('An error occurred. Please try again later.');
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>{isSignup ? 'Sign Up' : 'Login'}</h1>
        <form onSubmit={handleAuth}>
          {isSignup && (
            <>
              <div>
                <label>
                  UID:
                  <input type="text" value={uid} onChange={(e) => setUid(e.target.value)} required />
                </label>
              </div>
              <div>
                <label>
                  Email:
                  <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
                </label>
              </div>
            </>
          )}
          <div>
            <label>
              Username:
              <input type="text" value={username} onChange={(e) => setUsername(e.target.value)} required />
            </label>
          </div>
          <div>
            <label>
              Password:
              <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} required />
            </label>
          </div>
          <button type="submit">{isSignup ? 'Sign Up' : 'Login'}</button>
        </form>
        <button onClick={() => setIsSignup(!isSignup)}>
          {isSignup ? 'Already have an account? Login' : "Don't have an account? Sign up"}
        </button>
        {error && <p style={{ color: 'red' }}>{error}</p>}
        {message && <p style={{ color: 'green' }}>{message}</p>}
      </header>
    </div>
  );
}

export default App;
