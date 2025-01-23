from django.urls import path
from . import views
  
app_name = 'core'

urlpatterns = [  
    path('', views.get_pet_owner_profile, name='get_pet_owner_profile'),
    path('checkuser/<int:pk>', views.check_user, name='check_user'),
    # path('home', views.index, name = "home"),
    path('login', views.login, name = "login"),
    path('register', views.register, name='register'),
    path('search_user', views.search_users_view, name='search_users'),
    path('follow_user', views.follow_user, name='follow_user'),
    path('edit_info', views.update_profile, name='edit_info'),
    # path('logout', views.logout, name = "logout"),
]