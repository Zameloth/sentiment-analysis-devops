FROM python:3.10-slim

WORKDIR /app

# 4. Copier les fichiers de dépendances et installer
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copier le reste du code (FastAPI + modèle)
COPY main.py .

# 6. Exposer le port (Uvicorn en écoute)
EXPOSE 80

# 7. Lancer Uvicorn pour servir FastAPI
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]