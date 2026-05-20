/**
 * CreateSurveyPage Component
 * Create a new survey with multiple questions
 */
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { surveyAPI } from '../api';
import '../styles/CreateSurveyPage.css';

function CreateSurveyPage() {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [questions, setQuestions] = useState(['']);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  // Add a new question input field
  const handleAddQuestion = () => {
    setQuestions([...questions, '']);
  };

  // Remove a question input field
  const handleRemoveQuestion = (index) => {
    setQuestions(questions.filter((_, i) => i !== index));
  };

  // Update a question text
  const handleQuestionChange = (index, value) => {
    const newQuestions = [...questions];
    newQuestions[index] = value;
    setQuestions(newQuestions);
  };

  // Submit the form
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);

    // Validate inputs
    if (!title.trim()) {
      setError('Survey title is required');
      return;
    }

    if (questions.length === 0 || questions.every(q => !q.trim())) {
      setError('At least one question is required');
      return;
    }

    // Filter out empty questions
    const validQuestions = questions.filter(q => q.trim());

    setLoading(true);
    try {
      const response = await surveyAPI.createSurvey(
        title,
        description,
        validQuestions
      );
      // Navigate to survey detail page
      navigate(`/survey/${response.data.id}`);
    } catch (err) {
      setError('Failed to create survey. Please try again.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="create-survey-page">
      <div className="form-container">
        <h1>Create New Survey</h1>

        {error && <div className="error-message">{error}</div>}

        <form onSubmit={handleSubmit}>
          {/* Survey Title */}
          <div className="form-group">
            <label htmlFor="title">Survey Title *</label>
            <input
              id="title"
              type="text"
              placeholder="Enter survey title"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
            />
          </div>

          {/* Survey Description */}
          <div className="form-group">
            <label htmlFor="description">Description</label>
            <textarea
              id="description"
              placeholder="Enter survey description (optional)"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows="3"
            />
          </div>

          {/* Questions */}
          <div className="questions-section">
            <h3>Questions *</h3>
            {questions.map((question, index) => (
              <div key={index} className="question-input-group">
                <input
                  type="text"
                  placeholder={`Question ${index + 1}`}
                  value={question}
                  onChange={(e) => handleQuestionChange(index, e.target.value)}
                />
                {questions.length > 1 && (
                  <button
                    type="button"
                    className="btn btn-remove"
                    onClick={() => handleRemoveQuestion(index)}
                  >
                    Remove
                  </button>
                )}
              </div>
            ))}
          </div>

          {/* Add Question Button */}
          <button
            type="button"
            className="btn btn-secondary"
            onClick={handleAddQuestion}
          >
            + Add Question
          </button>

          {/* Submit Button */}
          <div className="form-actions">
            <button
              type="submit"
              className="btn btn-primary"
              disabled={loading}
            >
              {loading ? 'Creating...' : 'Create Survey'}
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

export default CreateSurveyPage;
