import os

MODEL_SERVICE_URL = os.getenv("MODEL_SERVICE_URL")
if not MODEL_SERVICE_URL:
    raise ValueError("MODEL_SERVICE_URL environment variable is not set")

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import requests

app = FastAPI(
    title="API Sentiment",
    description="API pour l'analyse de sentiment de textes en français",
    version="1.0.0"
)


class InputText(BaseModel):
    text: str = Field(
        examples=["Ce filme était vraiment excellent"],
        description="Texte à analyser"
    )


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/predict")
async def predict(input_data: InputText):
    try:
        response = requests.post(
            f"{MODEL_SERVICE_URL}/predict",
            json={"text": input_data.text},
            timeout=5  # timeout en secondes
        )
        response.raise_for_status()
        return response.json()
    except requests.Timeout:
        raise HTTPException(status_code=504, detail="Service modèle timeout")
    except requests.ConnectionError:
        raise HTTPException(status_code=503, detail="Service modèle inaccessible")
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=str(e))
