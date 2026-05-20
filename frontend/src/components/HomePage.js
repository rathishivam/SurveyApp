/**
 * HomePage Component
 * Display list of surveys and option to create new survey
 */
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { surveyAPI } from '../api';
import '../styles/HomePage.css';

function HomePage() {
  const [surveys, setSurveys] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  // Fetch surveys on component mount
  useEffect(() => {
    fetchSurveys();
  }, []);

  const fetchSurveys = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await surveyAPI.getAllSurveys();
      setSurveys(response.data);
    } catch (err) {
      setError('Failed to fetch surveys');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleViewSurvey = (surveyId) => {
    navigate(`/survey/${surveyId}`);
  };

  const handleDeleteSurvey = async (surveyId) => {
    if (window.confirm('Are you sure you want to delete this survey?')) {
      try {
        await surveyAPI.deleteSurvey(surveyId);
        fetchSurveys(); // Refresh the list
      } catch (err) {
        alert('Failed to delete survey');
        console.error(err);
      }
    }
  };

  return (
    <div className="home-page">
      <div className="home-header">
        <h1>Survey App</h1>
        <p>Create and manage surveys easily</p>
        <button
          className="btn btn-primary"
          onClick={() => navigate('/create')}
        >
          + Create New Survey
        </button>
      </div>

      {error && <div className="error-message">{error}</div>}

      {loading && <div className="loading">Loading surveys...</div>}

      {!loading && surveys.length === 0 ? (
        <div className="empty-state">
          <p>No surveys yet. Create one to get started!</p>
        </div>
      ) : (
        <div className="surveys-grid">
          {surveys.map((survey) => (
            <div key={survey.id} className="survey-card">
              <h3>{survey.title}</h3>
              <p className="survey-description">{survey.description}</p>
              <p className="survey-meta">
                {survey.questions.length} questions
              </p>
              <div className="survey-actions">
                <button
                  className="btn btn-secondary"
                  onClick={() => handleViewSurvey(survey.id)}
                >
                  Take Survey
                </button>
                <button
                  className="btn btn-secondary"
                  onClick={() => navigate(`/responses/${survey.id}`)}
                >
                  View Responses
                </button>
                <button
                  className="btn btn-danger"
                  onClick={() => handleDeleteSurvey(survey.id)}
                >
                  Delete
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default HomePage;
