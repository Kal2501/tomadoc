
from rest_framework import status
from django.http import JsonResponse
from rest_framework.views import APIView
import tensorflow as tf
from tensorflow.keras.preprocessing import image
import numpy as np
from PIL import Image

class_labels = {
    0: 'Tomat Hawar Daun (Late Blight)',
    1: 'Tomat Bercak Daun Septoria',
    2: 'Tomat Tungau Laba-laba (Spider Mites)',
    3: 'Tomat Virus Keriting Daun Kuning (Yellow Leaf Curl Virus)',
    4: 'Tomat Sehat'
}


# Create your views here.

model = tf.keras.models.load_model('predict/best_model.keras')

class PredictView (APIView):
    def post(self, request):
        try:
            file = request.FILES.get('image')
            if not file:
                return JsonResponse({"error": "File tidak ada"}, status=status.HTTP_400_BAD_REQUEST)
            
            img = Image.open(file)
            img = img.convert('RGB')
            img = img.resize((224,224))
            img_array = image.img_to_array(img)
            img_array = np.expand_dims(img_array, axis=0) / 255.0

            preds = model.predict(img_array)
            predicted_class_index = np.argmax(preds[0])
            predicted_label = class_labels[predicted_class_index]
            confidence = float(np.max(preds[0]) * 100)

            return JsonResponse({
                "predicted_label": predicted_label,
                "confidence": f"{confidence:.2f}%",
                "probabilities": preds.tolist()
            })


        except Exception as e:
            return JsonResponse({
                "error": str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

