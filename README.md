# Survey App - A Simple Full-Stack Survey Application

A beginner-friendly, minimal survey application built with React, FastAPI, and PostgreSQL.

## 📋 Features

- ✅ **Create Surveys** - Create surveys with titles, descriptions, and multiple questions
- ✅ **Submit Responses** - Users can take surveys and submit their answers
- ✅ **View Responses** - See all submitted survey responses
- ✅ **Manage Surveys** - Delete surveys you no longer need
- ✅ **Simple UI** - Clean, minimal, and easy-to-use interface
- ✅ **REST API** - FastAPI with automatic Swagger documentation
- ✅ **Docker Ready** - Run everything with Docker Compose

## 🏗️ Project Structure

```
survey-app/
├── backend/
│   ├── app/
│   │   ├── main.py              # FastAPI app entry point
│   │   ├── database.py          # Database connection
│   │   ├── models.py            # SQLAlchemy models
│   │   ├── schemas.py           # Pydantic validation schemas
│   │   ├── crud.py              # Database operations
│   │   └── routes/
│   │       └── survey.py        # API endpoints
│   ├── requirements.txt         # Python dependencies
│   └── Dockerfile
│
├── frontend/
│   ├── public/
│   │   └── index.html           # HTML template
│   ├── src/
│   │   ├── api.js               # Axios API client
│   │   ├── App.js               # Main React component
│   │   ├── index.js             # React entry point
│   │   ├── components/
│   │   │   ├── HomePage.js      # Survey list page
│   │   │   ├── CreateSurveyPage.js  # Create survey page
│   │   │   ├── SurveyDetailPage.js  # Take survey page
│   │   │   └── ResponsesPage.js     # View responses page
│   │   └── styles/
│   │       ├── index.css        # Global styles
│   │       ├── App.css          # App layout styles
│   │       ├── HomePage.css     # Home page styles
│   │       ├── CreateSurveyPage.css
│   │       ├── SurveyDetailPage.css
│   │       └── ResponsesPage.css
│   ├── package.json
│   ├── Dockerfile
│   └── .env.example
│
└── docker-compose.yml
```

## 🛠️ Tech Stack

### Backend
- **Framework**: FastAPI (Python web framework)
- **Database**: PostgreSQL (SQL database)
- **ORM**: SQLAlchemy (database toolkit)
- **Validation**: Pydantic (data validation)
- **Server**: Uvicorn (ASGI server)

### Frontend
- **Library**: React 18 (UI library)
- **Routing**: React Router v6 (client-side routing)
- **HTTP Client**: Axios (HTTP requests)
- **Styling**: CSS3 (custom CSS)

### DevOps
- **Containerization**: Docker
- **Orchestration**: Docker Compose
- **Database**: PostgreSQL 16

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Git (optional, if cloning)

### Installation & Running

1. **Clone or navigate to the project**
   ```bash
   cd survey-app
   ```

2. **Build and start the application**
   ```bash
   docker compose up --build
   ```

3. **Wait for all services to start**
   - The build process takes 2-3 minutes
   - You'll see log messages from all three containers

4. **Access the application**
   - **Frontend**: http://localhost:3000
   - **Backend API**: http://localhost:8000
   - **API Docs**: http://localhost:8000/docs

5. **Stop the application**
   ```bash
   docker compose down
   ```

## 📖 How to Use

### Creating a Survey
1. Click **"Create New Survey"** on the home page
2. Enter survey title and description
3. Add questions (at least one required)
4. Click **"Create Survey"**

### Taking a Survey
1. Click **"Take Survey"** on a survey card
2. Answer all questions (required to submit)
3. Click **"Submit Survey"**

### Viewing Responses
1. Click **"View Responses"** on a survey card
2. See all submitted responses grouped by submission
3. Go back to home with **"Back to Home"** button

### Deleting a Survey
1. Click **"Delete"** on a survey card
2. Confirm the deletion

## 🔌 API Endpoints

All endpoints are prefixed with `/api`

### Survey Endpoints
- `POST /surveys` - Create a survey
- `GET /surveys` - Get all surveys
- `GET /surveys/{survey_id}` - Get survey with questions
- `DELETE /surveys/{survey_id}` - Delete a survey

### Question Endpoints
- `POST /surveys/{survey_id}/questions` - Add question to survey
- `GET /surveys/{survey_id}/questions` - Get survey questions

### Response Endpoints
- `POST /surveys/{survey_id}/responses` - Submit survey responses
- `GET /surveys/{survey_id}/responses` - Get survey responses

### Utility
- `GET /health` - Health check
- `GET /docs` - Interactive API documentation (Swagger UI)

## 📊 Database Schema

### surveys table
```sql
id (PRIMARY KEY)
title (VARCHAR)
description (TEXT)
created_at (TIMESTAMP)
```

### questions table
```sql
id (PRIMARY KEY)
survey_id (FOREIGN KEY)
question_text (TEXT)
```

### responses table
```sql
id (PRIMARY KEY)
survey_id (FOREIGN KEY)
question_id (FOREIGN KEY)
answer (TEXT)
```

## 🔧 Development

### Backend Development

If you want to develop without Docker:

1. Install Python 3.11+
2. Create a virtual environment
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

4. Set database URL
   ```bash
   export DATABASE_URL="postgresql://survey_user:survey_password@localhost:5432/survey_db"
   ```

5. Run the server
   ```bash
   cd app
   python main.py
   ```

### Frontend Development

If you want to develop without Docker:

1. Install Node.js 18+
2. Install dependencies
   ```bash
   cd frontend
   npm install
   ```

3. Create `.env` file
   ```bash
   REACT_APP_API_URL=http://localhost:8000/api
   ```

4. Start development server
   ```bash
   npm start
   ```

## 📝 Code Examples

### Creating a Survey (Frontend)
```javascript
const response = await surveyAPI.createSurvey(
  "Customer Satisfaction",
  "Help us improve our service",
  ["How satisfied are you?", "What can we improve?"]
);
```

### Submitting Responses (Frontend)
```javascript
const responses = [
  { question_id: 1, answer: "Very satisfied" },
  { question_id: 2, answer: "Improve response time" }
];
await responseAPI.submitResponses(surveyId, responses);
```

### Creating a Survey (Backend API)
```bash
curl -X POST http://localhost:8000/api/surveys \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My Survey",
    "description": "A test survey",
    "questions": [
      {"question_text": "Question 1?"},
      {"question_text": "Question 2?"}
    ]
  }'
```

## 🐛 Troubleshooting

### Database Connection Error
```
error: could not connect to database
```
**Solution**: Ensure PostgreSQL container is healthy. Wait a few seconds and retry.

### Frontend Cannot Connect to Backend
```
Error: Network Error
```
**Solution**: 
- Check if backend is running: `docker compose logs backend`
- Ensure `REACT_APP_API_URL` is set correctly
- Restart containers: `docker compose restart`

### Port Already in Use
```
Error: bind: address already in use
```
**Solution**: 
- Find process using port: `lsof -i :3000` (or 8000, 5432)
- Kill the process or change ports in docker-compose.yml

### Slow Build Time
- First build takes 2-3 minutes (dependencies download)
- Subsequent builds are faster (cached layers)

## 📱 Responsive Design

The application is fully responsive and works on:
- ✅ Desktop (1200px+)
- ✅ Tablet (768px - 1199px)
- ✅ Mobile (< 768px)

## 🎨 Styling Notes

- Colors are defined as CSS variables in `styles/index.css`
- Primary color: `#3498db` (blue)
- Secondary color: `#2c3e50` (dark gray)
- All components use CSS Flexbox and CSS Grid
- No CSS framework dependencies (pure CSS)

## 📚 Learning Resources

### Backend
- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [SQLAlchemy Docs](https://docs.sqlalchemy.org/)
- [Pydantic Docs](https://docs.pydantic.dev/)

### Frontend
- [React Docs](https://react.dev/)
- [React Router Docs](https://reactrouter.com/)
- [Axios Docs](https://axios-http.com/)

### DevOps
- [Docker Docs](https://docs.docker.com/)
- [Docker Compose Docs](https://docs.docker.com/compose/)

## ✅ Checklist for Verification

After starting the app, verify it works:

- [ ] Frontend loads at http://localhost:3000
- [ ] Can create a survey
- [ ] Can view survey list
- [ ] Can take a survey
- [ ] Can submit responses
- [ ] Can view submitted responses
- [ ] Can delete surveys
- [ ] API docs available at http://localhost:8000/docs
- [ ] Database is persisting data (check after restart)

## 📄 License

This project is open source and available for learning purposes.

## 💡 Next Steps (Optional Enhancements)

Want to extend this project? Here are some ideas:

- Add authentication (users and login)
- Add survey editing capabilities
- Add survey expiration dates
- Add response analytics/charts
- Add email notifications
- Add multiple choice question types
- Add conditional questions
- Add survey sharing via links
- Add export responses to CSV
- Add user profiles and permissions

---

**Happy Surveying! 🎉**

If you have any questions or issues, please refer to the troubleshooting section or check the application logs.
