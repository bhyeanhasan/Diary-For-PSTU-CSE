from django.contrib import admin
from django.urls import path, include
from rest_framework import routers
from django.views.decorators.csrf import csrf_exempt

from app_api import views

urlpatterns = [
    path('', views.home, name='home'),
    path('user-profile/', views.get_user_profile),
    path('mail/', views.mail_service),
    path('users/', views.UserView.as_view()),
    path('auth/', csrf_exempt(views.ManageAuth.as_view())),
    path('profile/', csrf_exempt(views.ManageProfile.as_view())),
]
