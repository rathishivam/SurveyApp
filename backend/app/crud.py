"""
CRUD operations for database models
"""
from sqlalchemy.orm import Session
from models import Survey, Question, Response
from schemas import SurveyCreate, ResponseCreate


# ==================== Survey CRUD ====================

def create_survey(db: Session, survey: SurveyCreate):
    """Create a new survey with questions"""
    db_survey = Survey(title=survey.title, description=survey.description)
    db.add(db_survey)
    db.flush()  # Get the survey ID

    # Add questions to the survey
    for question in survey.questions:
        db_question = Question(survey_id=db_survey.id, question_text=question.question_text)
        db.add(db_question)

    db.commit()
    db.refresh(db_survey)
    return db_survey


def get_all_surveys(db: Session):
    """Get all surveys"""
    return db.query(Survey).all()


def get_survey_by_id(db: Session, survey_id: int):
    """Get a survey by ID with its questions"""
    return db.query(Survey).filter(Survey.id == survey_id).first()


def delete_survey(db: Session, survey_id: int):
    """Delete a survey"""
    db_survey = db.query(Survey).filter(Survey.id == survey_id).first()
    if db_survey:
        db.delete(db_survey)
        db.commit()
    return db_survey


# ==================== Question CRUD ====================

def add_question(db: Session, survey_id: int, question_text: str):
    """Add a question to a survey"""
    db_question = Question(survey_id=survey_id, question_text=question_text)
    db.add(db_question)
    db.commit()
    db.refresh(db_question)
    return db_question


def get_questions_by_survey(db: Session, survey_id: int):
    """Get all questions for a survey"""
    return db.query(Question).filter(Question.survey_id == survey_id).all()


# ==================== Response CRUD ====================

def submit_response(db: Session, survey_id: int, responses: list):
    """Submit multiple responses for a survey"""
    created_responses = []
    for response_data in responses:
        db_response = Response(
            survey_id=survey_id,
            question_id=response_data["question_id"],
            answer=response_data["answer"]
        )
        db.add(db_response)
        created_responses.append(db_response)

    db.commit()
    for response in created_responses:
        db.refresh(response)
    return created_responses


def get_responses_by_survey(db: Session, survey_id: int):
    """Get all responses for a survey"""
    return db.query(Response).filter(Response.survey_id == survey_id).all()


def get_responses_by_question(db: Session, question_id: int):
    """Get all responses for a specific question"""
    return db.query(Response).filter(Response.question_id == question_id).all()
