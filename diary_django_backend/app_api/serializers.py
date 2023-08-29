from django.contrib.auth.models import User, Group
from rest_framework import serializers
from .models import Profile


class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email']


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ["owner",
                  "name",
                  "email",
                  "pstu_id",
                  "registration",
                  "blood_group",
                  "address",
                  "facebook",
                  "twitter",
                  "linkedin",
                  "phone",
                  "picture"
                  ]
