"""
Database connection and session management
"""
import base64
import json
import os
import threading

import boto3
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

DEFAULT_DATABASE_URL = "postgresql://survey_user:survey_password@db:5432/survey_db"
SECRET_MANAGER_NAME_ENV = "SECRET_MANAGER_NAME"
DATABASE_URL_KEY = "DATABASE_URL"

_database_url = None
_engine_lock = threading.Lock()

# Engine and session factory are initialized during FastAPI startup.
engine = None
SessionLocal = sessionmaker(autocommit=False, autoflush=False)

# Create base class for models
Base = declarative_base()


def _get_database_url_from_secret_manager():
    """
    Fetch database credentials from AWS Secrets Manager.

    The secret can be either:
    - JSON containing a DATABASE_URL property
    - A plain string containing the full SQLAlchemy database URL
    """
    secret_name = os.getenv(SECRET_MANAGER_NAME_ENV)
    if not secret_name:
        return os.getenv(DATABASE_URL_KEY, DEFAULT_DATABASE_URL)

    client = boto3.client("secretsmanager")
    response = client.get_secret_value(SecretId=secret_name)
    secret_value = response.get("SecretString")

    if secret_value is None:
        secret_binary = response.get("SecretBinary")
        secret_value = base64.b64decode(secret_binary).decode("utf-8")

    try:
        secret_json = json.loads(secret_value)
    except json.JSONDecodeError:
        return secret_value

    database_url = secret_json.get(DATABASE_URL_KEY)
    if not database_url:
        raise ValueError(f"Secret {secret_name} does not contain {DATABASE_URL_KEY}")

    return database_url


def refresh_database_engine():
    """
    Refresh database settings from Secrets Manager and rebuild the engine if needed.
    """
    global _database_url, engine

    database_url = _get_database_url_from_secret_manager()
    with _engine_lock:
        if database_url == _database_url and engine is not None:
            return engine

        previous_engine = engine
        engine = create_engine(database_url)
        SessionLocal.configure(bind=engine)
        _database_url = database_url

    if previous_engine is not None:
        previous_engine.dispose()

    return engine


def get_engine():
    """
    Return the active database engine.
    """
    if engine is None:
        return refresh_database_engine()

    return engine


def get_db():
    """
    Dependency for getting database session
    """
    if engine is None:
        refresh_database_engine()

    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
