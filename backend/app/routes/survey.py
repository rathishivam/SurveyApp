"""
API routes for survey operations
"""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from schemas import (
    Survey, SurveyCreate, SurveyWithResponses,
    Question, QuestionCreate,
    Response, ResponseCreate
)
from crud import (
    create_survey, get_all_surveys, get_survey_by_id, delete_survey,
    add_question, get_questions_by_survey,
    submit_response, get_responses_by_survey
)

router = APIRouter(prefix="/api", tags=["surveys"])


# ==================== Survey Endpoints ====================

@router.post("/surveys", response_model=Survey)
def create_new_survey(survey: SurveyCreate, db: Session = Depends(get_db)):
    """Create a new survey"""
    return create_survey(db, survey)


@router.get("/surveys", response_model=list[Survey])
def list_surveys(db: Session = Depends(get_db)):
    """Get all surveys"""
    return get_all_surveys(db)


@router.get("/surveys/{survey_id}", response_model=SurveyWithResponses)
def get_survey_detail(survey_id: int, db: Session = Depends(get_db)):
    """Get a specific survey with its questions and responses"""
    db_survey = get_survey_by_id(db, survey_id)
    if not db_survey:
        raise HTTPException(status_code=404, detail="Survey not found")
    return db_survey


@router.delete("/surveys/{survey_id}")
def delete_survey_endpoint(survey_id: int, db: Session = Depends(get_db)):
    """Delete a survey"""
    db_survey = delete_survey(db, survey_id)
    if not db_survey:
        raise HTTPException(status_code=404, detail="Survey not found")
    return {"message": "Survey deleted successfully"}


# ==================== Question Endpoints ====================

@router.post("/surveys/{survey_id}/questions", response_model=Question)
def add_new_question(survey_id: int, question: QuestionCreate, db: Session = Depends(get_db)):
    """Add a question to a survey"""
    # Check if survey exists
    db_survey = get_survey_by_id(db, survey_id)
    if not db_survey:
        raise HTTPException(status_code=404, detail="Survey not found")

    return add_question(db, survey_id, question.question_text)


@router.get("/surveys/{survey_id}/questions", response_model=list[Question])
def list_survey_questions(survey_id: int, db: Session = Depends(get_db)):
    """Get all questions for a survey"""
    # Check if survey exists
    db_survey = get_survey_by_id(db, survey_id)
    if not db_survey:
        raise HTTPException(status_code=404, detail="Survey not found")

    return get_questions_by_survey(db, survey_id)


# ==================== Response Endpoints ====================

@router.post("/surveys/{survey_id}/responses")
def submit_survey_responses(survey_id: int, responses: list[ResponseCreate], db: Session = Depends(get_db)):
    """Submit responses for a survey"""
    # Check if survey exists
    db_survey = get_survey_by_id(db, survey_id)
    if not db_survey:
        raise HTTPException(status_code=404, detail="Survey not found")

    # Convert responses to dict format for CRUD operation
    response_data = [{"question_id": r.question_id, "answer": r.answer} for r in responses]
    created_responses = submit_response(db, survey_id, response_data)
    return {"message": "Responses submitted successfully", "count": len(created_responses)}


@router.get("/surveys/{survey_id}/responses", response_model=list[Response])
def get_survey_responses(survey_id: int, db: Session = Depends(get_db)):
    """Get all responses for a survey"""
    # Check if survey exists
    db_survey = get_survey_by_id(db, survey_id)
    if not db_survey:
        raise HTTPException(status_code=404, detail="Survey not found")

    return get_responses_by_survey(db, survey_id)


# ==================== Health Check ====================

@router.get("/health")
def health_check():
    """Health check endpoint"""
    return {"status": "ok"}
