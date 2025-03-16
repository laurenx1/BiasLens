import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const SurveyForm = () => {
  const [major, setMajor] = useState('');
  const [gradYear, setGradYear] = useState('');
  const [age, setAge] = useState('');
  const [house, setHouse] = useState('');
  const [name, setName] = useState(''); 
  const navigate = useNavigate(); // To navigate after survey submission

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Retrieve UID from localStorage (this assumes the UID is saved in localStorage after login)
    const uid = localStorage.getItem('uid'); // Make sure this UID is saved when the user logs in

    if (!uid) {
      alert('User is not logged in.');
      return;
    }

    // Prepare the data to submit (including the UID)
    const surveyData = { name, major, gradYear, age, house, uid }; 

    try {
      const response = await fetch('http://127.0.0.1:5000/submit-survey', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(surveyData),
      });

      const data = await response.json();

      if (response.ok) {
        // Redirect to the next page after successful survey submission
        navigate('/home'); // Modify the route you want to navigate to
      } else {
        alert('Error submitting survey: ' + data.message);
      }
    } catch (error) {
      alert('An error occurred while submitting the survey');
    }
  };

  return (
    <div className="survey-form">
      <h1>Survey</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label>
            Major:
            <input
              type="text"
              value={major}
              onChange={(e) => setMajor(e.target.value)}
              required
            />
          </label>
        </div>
        <div>
          <label>
            Graduation Year:
            <input
              type="number"
              value={gradYear}
              onChange={(e) => setGradYear(e.target.value)}
              required
            />
          </label>
        </div>
        <div>
          <label>
            Age:
            <input
              type="number"
              value={age}
              onChange={(e) => setAge(e.target.value)}
              required
            />
          </label>
        </div>
        <div>
          <label>
            House:
            <input
              type="text"
              value={house}
              onChange={(e) => setHouse(e.target.value)}
              required
            />
          </label>
        </div>
        <div>
          <label>
            Name
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
            />
          </label>
        </div>
        <button type="submit">Submit Survey</button>
      </form>
    </div>
  );
};

export default SurveyForm;
