import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

from fastapi import FastAPI
from pydantic import BaseModel
from transformers import (
    AutoTokenizer,
    TFAutoModelForSequenceClassification,
    pipeline
)

app = FastAPI()

tokenizer = AutoTokenizer.from_pretrained("alosof/camembert-sentiment-allocine", use_fast=False)
model = TFAutoModelForSequenceClassification.from_pretrained("alosof/camembert-sentiment-allocine")

classifier = pipeline(
    "text-classification",
    model=model,
    tokenizer=tokenizer,
    framework="tf"
)

class InputText(BaseModel):
    text: str

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/predict")
def predict(input_data: InputText):
    result = classifier(input_data.text)[0]
    return {
        "label": result["label"],
        "score": round(result["score"], 3)
    }