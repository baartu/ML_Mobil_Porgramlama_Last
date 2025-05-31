from fastapi import FastAPI, Request
from pydantic import BaseModel
import joblib
import numpy as np
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Kayıtlı modeli ve scaler'ı yükle
model = joblib.load("C:/Users/basar/Desktop/yeni/lib/models/rf_model.pkl")
scaler = joblib.load("C:/Users/basar/Desktop/yeni/lib/models/scaler.pkl")

# Mobil uygulamadan gelen veriyi temsil eden model
class ModelInput(BaseModel):
    age: float
    sex: float
    cp: float
    trestbps: float
    chol: float
    fbs: float
    restecg: float
    thalach: float
    exang: float
    oldpeak: float
    slope: float
    ca: float
    thal: float

# POST isteği: Tahmin yap ve sonucu döndür
@app.post("/predict")
async def predict(data: ModelInput):
    try:
        input_data = np.array([[data.age, data.sex, data.cp, data.trestbps, data.chol,
                                data.fbs, data.restecg, data.thalach, data.exang, data.oldpeak,
                                data.slope, data.ca, data.thal]])

        input_data_scaled = scaler.transform(input_data)
        prediction = model.predict(input_data_scaled)
        prediction_prob = model.predict_proba(input_data_scaled)

        return {
            "prediction": int(prediction[0]),
            "prediction_probability": prediction_prob[0].tolist()
        }
    except Exception as e:
        return {"error": str(e)}

# GET isteği: Parametreleri URL üzerinden al
@app.get("/predict")
async def get_prediction(
    age: float, sex: float, cp: float, trestbps: float, chol: float,
    fbs: float, restecg: float, thalach: float, exang: float, oldpeak: float,
    slope: float, ca: float, thal: float):

    try:
        input_data = np.array([[age, sex, cp, trestbps, chol, fbs, restecg, thalach, 
                                exang, oldpeak, slope, ca, thal]])

        input_data_scaled = scaler.transform(input_data)
        prediction = model.predict(input_data_scaled)
        prediction_prob = model.predict_proba(input_data_scaled)

        return {"prediction": int(prediction[0]), "prediction_probability": prediction_prob[0].tolist()}
    except Exception as e:
        return {"error": str(e)}
