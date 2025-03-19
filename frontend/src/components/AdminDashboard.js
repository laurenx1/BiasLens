import React, { useState } from 'react';
// import { useNavigate } from 'react-router-dom';
import './AdminDashboard.css'; // Ensure this file exists

const AdminDashboard = () => {




  return (
    <div className="admin-dashboard">
      <div className="admin-blurb">
        <p>
          <strong>Here are your administrator options:</strong>
          <br />
          (a) Manually add an article <br />
          (b) Delete an article, by article ID <br />
          (c) Manually add a student <br />
          (d) Manually delete a student, by UID <br />
          (e) Update a field for a specific student <br />
          (f) Update a field for a specific value
        </p>
      </div>
    </div>
  );
};

export default AdminDashboard;



/*
 * Here are your administrator options. Select
 * (a) manually add an article 
 * (b) delete an article, by article ID
 * (c) manually add a student
 * (d) manually delete a student, by UID
 * (e) update a field for a specific student
 * (f) update a field for a specific value
*/