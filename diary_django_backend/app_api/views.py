from django.core.mail import send_mail
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.serializers import AuthTokenSerializer

from django.http import HttpResponse
from rest_framework import viewsets, permissions, generics, status
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .serializers import UserSerializer, ProfileSerializer
from django.contrib.auth.models import User, auth
from rest_framework.views import APIView
from .models import Profile


def home(request):
    return HttpResponse('Home')


class UserView(APIView):
    def get(self, request):
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data)

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        if User.objects.filter(username=username).exists():
            return Response("username already exist", status=status.HTTP_406_NOT_ACCEPTABLE)

        user = User.objects.create_user(username=username, password=password)
        user.save()
        return Response("user created", status=status.HTTP_201_CREATED)


@api_view()
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_user_profile(request):
    try:
        profile = Profile.objects.get(owner=request.user.pk)
    except:
        profile = Profile()
        profile.owner = request.user
        profile.name = "Not set"
        profile.email = "not set"
        profile.address = "not set"
        profile.blood_group = "not set"
        profile.pstu_id = "not set"
        profile.registration = "not set"
        profile.facebook = "not set"
        profile.linkedin = "not set"
        profile.twitter = "Not set"
        profile.save()

    try:
        profile = Profile.objects.get(owner=request.user.pk)
        serializer = ProfileSerializer(profile)
        print(serializer.data)

        return Response(serializer.data, status=status.HTTP_200_OK)
    except:
        return Response("User not found", status=status.HTTP_404_NOT_FOUND)


class ManageAuth(APIView):
    def get(self, request):
        auth.logout(request)
        print("logged out")
        return Response("logout")

    def post(self, request):
        serializer = AuthTokenSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.validated_data['user']
            token, created = Token.objects.get_or_create(user=user)
            return Response({'token': token.key}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        # username = request.data.get('username')
        # password = request.data.get('password')
        # print(username)
        # user = auth.authenticate(username=username, password=password)
        # if user is not None:
        #     auth.login(request, user)
        #     print('logged in')
        #     return Response("logged in", status=status.HTTP_200_OK)
        # else:
        #     return Response("Login failed", status=status.HTTP_400_BAD_REQUEST)


class ManageProfile(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [TokenAuthentication, SessionAuthentication]

    def get(self, request):
        profile = Profile.objects.all()
        serializer = ProfileSerializer(profile, many=True)
        return Response(serializer.data)

    def post(self, request):
        data = request.data
        serializer = ProfileSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request):
        data = request.data
        data['owner'] = request.user.pk
        old_profile = Profile.objects.get(owner=request.user.pk)
        print(data)
        serializer = ProfileSerializer(old_profile, data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        print(serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def mail_service(request):
    send_mail(
        "Subject here",
        "Here is the message.",
        "oboyob16.official@gmail.com",
        ["bhyean@gmail.com"],
        fail_silently=False,
    )
    return HttpResponse("Done", status=status.HTTP_200_OK)
