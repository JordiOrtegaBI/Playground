##################################################################################################################
############################## PRACTICA DESPLIEGUE ALGORITMOS: Jordi Ortega - IA2 ################################
##################################################################################################################

# 0. Ejercicio 2. Páctica parte FastAPI

# 1. Captura de pantalla docs con al menos 5 módulos
#       1.1. fastapi_5metodos.png
# 2. Captura de cada uno de los módulos con la respuesta dentro de docs
#       2.1. fastapi_emotion.png
#       2.2. fastapi_summarize.png
#       2.3. fastapi_position.png
#       2.4. fastapi_password.png
#       2.5. fastapi_email.png
# 5. Todo el código usado durante el proceso.


from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
from transformers import pipeline
import random
import string
import re
import pandas as pd

# Arrancamos el cliente
app = FastAPI()

##################################################################################################################
############################## HUGGING FACE ######################################################################
##################################################################################################################

# 1. Como continuación de la practica de NLP, pasamos una 'review' y devuelve una de las 7 "emociones" (anger, disgust, fear, joy, neutral, sadness, surprise)
@app.get('/emotion')
def emotion_classifier(query: str):
    emotion_pipeline = pipeline('text-classification', model='j-hartmann/emotion-english-distilroberta-base')
    return emotion_pipeline(query)[0]

# 2. Resumen de texto
@app.post('/summarize')
def summarize_text(query: str):
    summarization_pipeline = pipeline('summarization')
    return summarization_pipeline(query, max_length=50, min_length=25, do_sample=False)[0]['summary_text']

##################################################################################################################
############################## OTROS #############################################################################
##################################################################################################################

# 3. Accedemos a la base de datos usada en NLP y devolvemos toda la información de una posición. Levantamos excepciones/errores.
@app.get('/data/{position}')
def read_dataframe_properties(position: int):
    try:
        df = pd.read_csv('df_sports_outdoors_unigram.csv')

        if position < 0 or position >= len(df):
            raise IndexError

        row = df.iloc[position].to_dict()

        return {
            'position': position,
            'record': row
        }
    except FileNotFoundError:
        raise HTTPException(status_code=404, detail="File not found")
    except IndexError:
        raise HTTPException(status_code=400, detail="Position out of range")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")

# 4. Generamos contraseñas
@app.get('/generate-password')
def generate_password(length: int = 12):
    if length < 6:
        return {"error": "Password length should be at least 6"}
    characters = string.ascii_letters + string.digits + string.punctuation
    password = ''.join(random.choice(characters) for _ in range(length))
    return {"password": password}

# 5. Validador de email
@app.get('/validate-email')
def validate_email(email: str):
    regex = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
    if re.match(regex, email):
        return {"email": email, "is_valid": True}
    return {"email": email, "is_valid": False}


