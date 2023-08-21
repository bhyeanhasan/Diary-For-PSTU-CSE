from django.shortcuts import render
from django.http import HttpResponse
from rest_framework import viewsets, permissions, generics, status
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .serializers import UserSerializer, ProfileSerializer
from django.contrib.auth.models import User, auth
from rest_framework.views import APIView
from .models import Profile


def home(request):
    return HttpResponse('Home')


class UserView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ManageAuth(APIView):
    def get(self, request):
        auth.logout(request)
        print("logged out")
        return Response("logout")

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        print(username)
        user = auth.authenticate(username=username, password=password)
        if user is not None:
            auth.login(request, user)
            print('logged in')
            return Response("logged in", status=status.HTTP_200_OK)
        else:
            return Response("Login failed", status=status.HTTP_400_BAD_REQUEST)


class ManageProfile(APIView):

    def get(self, request):
        profile = Profile.objects.all()
        serializer = ProfileSerializer(profile, many=True)
        return Response(serializer.data)

    def post(self, request):
        data = request.data
        data['owner'] = request.user.pk
        serializer = ProfileSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
