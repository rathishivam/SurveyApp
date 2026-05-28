"""
FastAPI application entry point
"""
import asyncio
import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import Base, get_engine, refresh_database_engine
from routes.survey import router as survey_router

logger = logging.getLogger(__name__)


async def refresh_database_secrets():
    """
    Refresh database secrets every hour.
    """
    while True:
        await asyncio.sleep(60 * 60)
        try:
            await asyncio.to_thread(refresh_database_engine)
        except Exception:
            logger.exception("Failed to refresh database secrets")


@asynccontextmanager
async def lifespan(app):
    """
    Initialize database settings and schedule periodic secret refresh.
    """
    await asyncio.to_thread(refresh_database_engine)
    Base.metadata.create_all(bind=get_engine())

    refresh_task = asyncio.create_task(refresh_database_secrets())
    try:
        yield
    finally:
        refresh_task.cancel()
        try:
            await refresh_task
        except asyncio.CancelledError:
            pass

# Create FastAPI app
app = FastAPI(
    title="Survey App API",
    description="A simple survey application API",
    version="1.0.0",
    lifespan=lifespan,
)

# Add CORS middleware to allow frontend requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routes
app.include_router(survey_router)


@app.get("/")
def read_root():
    """Root endpoint"""
    return {"message": "Welcome to Survey App API"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
