import os
import cv2
import numpy as np

from dotenv import load_dotenv
from google.cloud import storage
from ultralytics import YOLO

# load file .env untuk mengambil GCP storage
load_dotenv()

gcp_url = os.getenv("GCP_STORAGE_URL")

model = YOLO("yolo11n.pt")

def download_image(source_blob_name):
    storage_client = storage.Client()
    bucket = storage_client.bucket(gcp_url)
    blob = bucket.blob(source_blob_name)

    image_data = blob.download_as_bytes()

    image_array = np.frombuffer(image_data, np.uint8)
    image = cv2.imdecode(image_array, cv2.IMREAD_COLOR)

    return image

def loag_model(engine_path):
    pass

def predict_image(image_name):
    image = download_image(image_name)

    results = model.predict(image, save=True)

    return results