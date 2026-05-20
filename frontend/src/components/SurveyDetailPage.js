/**
 * SurveyDetailPage Component
 * Display survey questions and allow users to submit responses
 */
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { surveyAPI, responseAPI } from '../api';
import '../styles/SurveyDetailPage.css';

function SurveyDetailPage() {
  const { surveyId } = useParams();
  const navigate = useNavigate();
  const [survey, setSurvey] = useState(null);
  const [responses, setResponses] = useState({});
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState(null);

  // Fetch survey details on component mount
  useEffect(() => {
    fetchSurvey();
  }, [surveyId]);

  const fetchSurvey = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await surveyAPI.getSurveyById(surveyId);
      setSurvey(response.data);
      // Initialize responses object
      const initialResponses = {};
      response.data.questions.forEach(q => {
        initialResponses[q.id] = '';
      });
      setResponses(initialResponses);
    } catch (err) {
      setError('Failed to load survey');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleResponseChange = (questionId, value) => {
    setResponses({
      ...responses,
      [questionId]: value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);

    // Check if all questions are answered
    const allAnswered = survey.questions.every(
      q => responses[q.id] && responses[q.id].trim()
    );

    if (!allAnswered) {
      setError('Please answer all questions before submitting');
      return;
    }

    setSubmitting(true);
    try {
      const submissionData = survey.questions.map(q => ({
        question_id: q.id,
        answer: responses[q.id],
      }));

      await responseAPI.submitResponses(surveyId, submissionData);
      alert('Survey submitted successfully!');
      navigate('/');
    } catch (err) {
      setError('Failed to submit survey. Please try again.');
      console.error(err);
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return <div className="loading">Loading survey...</div>;
  }

  if (!survey) {
    return <div className="error-message">{error || 'Survey not found'}</div>;
  }

  return (
    <div className="survey-detail-page">
      <div className="survey-container">
        <h1>{survey.title}</h1>
        {survey.description && (
          <p className="survey-description">{survey.description}</p>
        )}

        {error && <div className="error-message">{error}</div>}

        <form onSubmit={handleSubmit} className="survey-form">
          {survey.questions.map((question, index) => (
            <div key={question.id} className="question-item">
              <label htmlFor={`q-${question.id}`}>
                <span className="question-number">{index + 1}.</span>
                {question.question_text}
              </label>
              <textarea
                id={`q-${question.id}`}
                placeholder="Enter your answer"
                value={responses[question.id] || ''}
                onChange={(e) =>
                  handleResponseChange(question.id, e.target.value)
                }
                rows="3"
              />
            </div>
          ))}

          <div className="form-actions">
            <button
              type="submit"
              className="btn btn-primary"
              disabled={submitting}
            >
              {submitting ? 'Submitting...' : 'Submit Survey'}
            </button>
            <button
              type="button"
              className="btn btn-secondary"
              onClick={() => navigate('/')}
            >
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default SurveyDetailPage;
