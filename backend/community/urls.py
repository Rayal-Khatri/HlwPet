# community/urls.py
from django.urls import path
from community.views import *

urlpatterns = [
    path('', community_profile_list, name='community-list'),
    path('<int:pk>', community_profile_detail, name='community_profile_detail'),
    path('<int:pk>/make_admin', make_community_admin, name='make_community_admin'),
    path('create', create_community, name='create_community'),
]
