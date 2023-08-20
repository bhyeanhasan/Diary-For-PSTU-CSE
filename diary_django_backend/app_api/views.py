from django.shortcuts import render
from django.http import HttpResponse
from rest_framework import viewsets, permissions, generics, status
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .serializers import UserSerializer
from django.contrib.auth.models import User, auth
from rest_framework.views import APIView


def home(request):
    return HttpResponse('Home')


class UserView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        print(request.user)
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
    authentication_classes = [SessionAuthentication, BasicAuthentication]

    def get(self, request):
        auth.logout(request)
        return Response("logout")

    def post(self, request):
        return Response('OK')
