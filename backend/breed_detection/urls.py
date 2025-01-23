from django.urls import path
from .views import breed_detection, breed_detection_api,hello_world

urlpatterns = [
    # path('detection', breed_detection, name='breed_detection'),
    path('detection', breed_detection_api, name='breed_detection_api'),
    # path('api/hello', hello_world, name='hello_world'),
]