import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000/api';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Survey APIs
export const surveyAPI = {
  // Create a new survey
  createSurvey: (title, description, questions) => {
    return api.post('/surveys', {
      title,
      description,
      questions: questions.map(q => ({ question_text: q })),
    });
  },

  // Get all surveys
  getAllSurveys: () => {
    return api.get('/surveys');
  },

  // Get a specific survey by ID
  getSurveyById: (surveyId) => {
    return api.get(`/surveys/${surveyId}`);
  },

  // Delete a survey
  deleteSurvey: (surveyId) => {
    return api.delete(`/surveys/${surveyId}`);
  },
};

// Question APIs
export const questionAPI = {
  // Add a question to a survey
  addQuestion: (surveyId, questionText) => {
    return api.post(`/surveys/${surveyId}/questions`, {
      question_text: questionText,
    });
  },

  // Get all questions for a survey
  getQuestions: (surveyId) => {
    return api.get(`/surveys/${surveyId}/questions`);
  },
};

// Response APIs
export const responseAPI = {
  // Submit survey responses
  submitResponses: (surveyId, responses) => {
    return api.post(`/surveys/${surveyId}/responses`, responses);
  },

  // Get all responses for a survey
  getResponses: (surveyId) => {
    return api.get(`/surveys/${surveyId}/responses`);
  },
};

export default api;
