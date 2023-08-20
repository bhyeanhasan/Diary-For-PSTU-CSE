from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('', include('app_api.urls_api')),
    path('admin/', admin.site.urls),

]
