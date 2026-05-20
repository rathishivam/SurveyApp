/**
 * ResponsesPage Component
 * Display all responses for a survey
 */
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { surveyAPI, responseAPI } from '../api';
import '../styles/ResponsesPage.css';

function ResponsesPage() {
  const { surveyId } = useParams();
  const navigate = useNavigate();
  const [survey, setSurvey] = useState(null);
  const [responses, setResponses] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Fetch survey and responses on component mount
  useEffect(() => {
    fetchData();
  }, [surveyId]);

  const fetchData = async () => {
    setLoading(true);
    setError(null);
    try {
      const [surveyRes, responsesRes] = await Promise.all([
        surveyAPI.getSurveyById(surveyId),
        responseAPI.getResponses(surveyId),
      ]);
      setSurvey(surveyRes.data);
      setResponses(responsesRes.data);
    } catch (err) {
      setError('Failed to load responses');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div className="loading">Loading responses...</div>;
  }

  if (!survey) {
    return <div className="error-message">{error || 'Survey not found'}</div>;
  }

  // Group responses by question
  const responsesByQuestion = {};
  survey.questions.forEach(q => {
    responsesByQuestion[q.id] = responses.filter(r => r.question_id === q.id);
  });

  // Group responses by submission (each question should have same number of answer groups)
  const submissionCount = responses.length > 0 
    ? Math.max(...Object.values(responsesByQuestion).map(r => r.length))
    : 0;

  const submissions = [];
  for (let i = 0; i < submissionCount; i++) {
    const submission = {};
    survey.questions.forEach(q => {
      const qResponses = responsesByQuestion[q.id];
      submission[q.id] = qResponses[i]?.answer || '';
    });
    submissions.push(submission);
  }

  return (
    <div className="responses-page">
      <div className="responses-container">
        <h1>Survey Responses: {survey.title}</h1>
        <p className="response-count">Total Responses: {submissions.length}</p>

        {error && <div className="error-message">{error}</div>}

        {submissions.length === 0 ? (
          <div className="empty-state">
            <p>No responses yet</p>
          </div>
        ) : (
          <div className="responses-list">
            {submissions.map((submission, submissionIndex) => (
              <div key={submissionIndex} className="response-card">
                <h3>Response #{submissionIndex + 1}</h3>
                {survey.questions.map((question, qIndex) => (
                  <div key={question.id} className="response-item">
                    <h4>
                      <span className="question-number">{qIndex + 1}.</span>
                      {question.question_text}
                    </h4>
                    <p className="answer">{submission[question.id]}</p>
                  </div>
                ))}
              </div>
            ))}
          </div>
        )}

        <button
          className="btn btn-secondary"
          onClick={() => navigate('/')}
        >
          Back to Home
        </button>
      </div>
    </div>
  );
}

export default ResponsesPage;
