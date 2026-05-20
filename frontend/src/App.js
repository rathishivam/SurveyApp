/**
 * Main App Component
 * Set up routing and layout
 */
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './components/HomePage';
import CreateSurveyPage from './components/CreateSurveyPage';
import SurveyDetailPage from './components/SurveyDetailPage';
import ResponsesPage from './components/ResponsesPage';
import './styles/App.css';

function App() {
  return (
    <Router>
      <div className="app">
        <nav className="navbar">
          <div className="nav-container">
            <a href="/" className="nav-brand">
              Survey App
            </a>
          </div>
        </nav>

        <main className="main-content">
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/create" element={<CreateSurveyPage />} />
            <Route path="/survey/:surveyId" element={<SurveyDetailPage />} />
            <Route path="/responses/:surveyId" element={<ResponsesPage />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;
