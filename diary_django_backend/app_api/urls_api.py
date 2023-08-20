from django.contrib import admin
from django.urls import path, include
from rest_framework import routers

from app_api import views

urlpatterns = [
    path('', views.home, name='home'),
    path('users/', views.UserView.as_view()),
    path('ok/', views.ManageAuth.as_view()),
]
