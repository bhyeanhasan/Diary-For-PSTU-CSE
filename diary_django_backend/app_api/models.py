from django.db import models
from django.contrib.auth.models import User


class Profile(models.Model):
    owner = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100, default="Not Set")
    email = models.EmailField(default="Not Set")
    pstu_id = models.CharField(max_length=100, default="Not Set")
    registration = models.CharField(max_length=100, default="Not Set")
    blood_group = models.CharField(max_length=100, default="Not Set")
    address = models.CharField(max_length=100, blank=True, null=True, default="Not Set")
    facebook = models.CharField(max_length=100, blank=True, null=True, default="Not Set")
    twitter = models.CharField(max_length=100, blank=True, null=True, default="Not Set")
    linkedin = models.CharField(max_length=100, blank=True, null=True, default="Not Set")
    phone = models.CharField(max_length=100, blank=True, null=True, default="Not Set")
    picture = models.ImageField(upload_to="profile_picture", blank=True, null=True)
