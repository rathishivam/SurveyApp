"""
Pydantic schemas for request/response validation
"""
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime


class QuestionBase(BaseModel):
    """Base schema for questions"""
    question_text: str


class QuestionCreate(QuestionBase):
    """Schema for creating questions"""
    pass


class Question(QuestionBase):
    """Schema for question response"""
    id: int
    survey_id: int

    class Config:
        from_attributes = True


class SurveyBase(BaseModel):
    """Base schema for surveys"""
    title: str
    description: Optional[str] = None


class SurveyCreate(SurveyBase):
    """Schema for creating surveys"""
    questions: List[QuestionCreate] = []


class Survey(SurveyBase):
    """Schema for survey response"""
    id: int
    created_at: datetime
    questions: List[Question] = []

    class Config:
        from_attributes = True


class ResponseBase(BaseModel):
    """Base schema for responses"""
    question_id: int
    answer: str


class ResponseCreate(ResponseBase):
    """Schema for creating responses"""
    pass


class Response(ResponseBase):
    """Schema for response data"""
    id: int
    survey_id: int

    class Config:
        from_attributes = True


class SurveyWithResponses(Survey):
    """Schema for survey with all responses"""
    responses: List[Response] = []

    class Config:
        from_attributes = True
