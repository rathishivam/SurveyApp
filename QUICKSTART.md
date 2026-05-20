# Quick Start Guide - Survey App

## 🚀 Fastest Way to Get Started

### Step 1: Run Docker Compose
```bash
docker compose up --build
```

### Step 2: Wait for initialization
- First time: ~2-3 minutes (building images)
- Subsequent: ~30 seconds

### Step 3: Open in browser
- Frontend: http://localhost:3000
- API Docs: http://localhost:8000/docs

### Step 4: Use the app
1. Click "Create New Survey"
2. Add survey title, description, and questions
3. Click "Create Survey"
4. Click "Take Survey" to answer
5. Submit your responses
6. Click "View Responses" to see all answers

---

## 📝 Complete Commands Reference

### Start the application
```bash
docker compose up --build
```

### Start without rebuilding images
```bash
docker compose up
```

### Stop the application
```bash
docker compose down
```

### View logs
```bash
docker compose logs -f                    # All services
docker compose logs -f backend            # Backend only
docker compose logs -f frontend           # Frontend only
docker compose logs -f db                 # Database only
```

### Rebuild specific service
```bash
docker compose up --build backend
docker compose up --build frontend
```

### Clean up everything
```bash
docker compose down -v                    # Remove volumes too
```

---

## 🔗 Access Points

| Service | URL | Purpose |
|---------|-----|---------|
| Frontend | http://localhost:3000 | User interface |
| Backend API | http://localhost:8000 | REST API |
| API Documentation | http://localhost:8000/docs | Interactive Swagger UI |
| Database | localhost:5432 | PostgreSQL |

---

## ✅ Verify Everything Works

After `docker compose up --build` completes:

1. **Check Frontend**
   - Open http://localhost:3000
   - Should see "Survey App" header

2. **Check Backend**
   - Open http://localhost:8000/docs
   - Should see API documentation

3. **Check Database**
   - Tables created automatically
   - No manual setup needed

4. **Create Test Survey**
   - Click "Create New Survey"
   - Add title: "Test Survey"
   - Add one question: "How are you?"
   - Click "Create Survey"
   - Should see survey in list

---

## 🐛 If Something Goes Wrong

### Application won't start
```bash
# Check logs
docker compose logs

# Restart everything
docker compose down
docker compose up --build
```

### Frontend blank page
```bash
# Check frontend logs
docker compose logs frontend

# Browser console (F12) should show no errors
```

### Cannot reach backend from frontend
```bash
# Make sure backend is running
docker compose logs backend

# Check if port 8000 is accessible
curl http://localhost:8000/health
```

### Database connection error
```bash
# Make sure database is running and healthy
docker compose logs db

# Restart database
docker compose restart db
```

---

## 📚 File Structure Explained

```
survey-app/
├── backend/                 # Python FastAPI server
│   ├── app/                # Application code
│   ├── Dockerfile          # Container configuration
│   └── requirements.txt    # Python dependencies
│
├── frontend/               # React application
│   ├── public/            # Static files
│   ├── src/               # React components
│   ├── Dockerfile         # Container configuration
│   └── package.json       # Node dependencies
│
├── docker-compose.yml     # Multi-container setup
├── README.md              # Full documentation
└── .gitignore            # Git ignore rules
```

---

## 💻 Development Mode (Without Docker)

### Backend
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
cd app
python main.py
```

### Frontend (in new terminal)
```bash
cd frontend
npm install
REACT_APP_API_URL=http://localhost:8000/api npm start
```

---

## 🎯 What Each Component Does

### Backend (Python/FastAPI)
- Handles all data operations
- Stores surveys, questions, responses
- Provides REST API endpoints
- Automatic API documentation at /docs

### Frontend (React)
- User interface for creating/taking surveys
- Makes HTTP requests to backend
- Displays responses
- Fully responsive design

### Database (PostgreSQL)
- Stores all data persistently
- Created and initialized automatically
- Data survives container restarts

---

## 📞 Need Help?

See the main `README.md` for:
- Detailed API documentation
- Database schema
- Troubleshooting guide
- Learning resources
- Feature ideas for extensions

---

**That's it! You're ready to use the Survey App! 🎉**
