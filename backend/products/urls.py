from django.urls import path
from .views import *

urlpatterns = [
    path('', display_products, name='display_products'),
    path('upload_csv/', upload_csv, name='upload_csv'),
]