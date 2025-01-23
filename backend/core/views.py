from django.shortcuts import render, redirect
from django.contrib.auth.models import User, auth
from django.contrib import messages
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from django.db.models import Q
from rest_framework import status
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.renderers import JSONRenderer
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.tokens import RefreshToken

from .utlis import get_user_id_from_token
from .models import *
from .serializers import *


@api_view(['GET'])
def check_user(request, pk):
    try:
        user_profile = Profile.objects.get(user=pk)
        profile_serializer = PetOwnerProfileSerializer(user_profile)
        return Response(profile_serializer.data, status=status.HTTP_200_OK)
    except Profile.DoesNotExist:
        return Response(
            {"message": "User profile not found for user with ID: {}".format(pk)},
            status=status.HTTP_404_NOT_FOUND
        )

@csrf_exempt
@api_view(["POST"])
@authentication_classes([SessionAuthentication, BasicAuthentication])
def login(request):
    if request.method == 'POST':
        jsondata = request.data
        serializer = LoginSerializer(data=jsondata)

        if serializer.is_valid():
            username = serializer.validated_data['username']
            password = serializer.validated_data['password']
            
            user = auth.authenticate(username=username, password=password)
            
            if user is not None:
        
                refresh = RefreshToken.for_user(user)
                return JsonResponse({
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                    'status': 200
                })
            else:
                return JsonResponse({'error': 'Credentials Invalid', 'status':status.HTTP_401_UNAUTHORIZED})
        else:
            return JsonResponse({'error': 'Invalid data', 'status':status.HTTP_400_BAD_REQUEST})


@api_view(['GET'])
@authentication_classes([JWTAuthentication])
@permission_classes([IsAuthenticated])
def get_pet_owner_profile(request):
    if request.method == 'GET':
        try:
            user_id = request.user.id
            user_profile = Profile.objects.get(user=user_id)
            profile_serializer = PetOwnerProfileSerializer(user_profile)
            print(profile_serializer.data)
            return Response(profile_serializer.data)
        except Profile.DoesNotExist:
            return Response({"message": "Authenticated user with ID: {}".format(user_id)}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            # Print or log the error message and response content
            error_message = str(e)
            print(f"Error: {error_message}")
            response_content = JSONRenderer().render({"error": error_message})
            print(f"Response Content: {response_content}")
            return Response({"error": error_message}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
@csrf_exempt
@api_view(["POST"])
def register(request):
    if request.method == 'POST':
        
        jsondata = request.data
        serializer = UserRegistrationSerializer(data=jsondata)
        
        if serializer.is_valid():
            username = serializer.validated_data.get("username")
            email = serializer.validated_data.get("email")
            password = serializer.validated_data.get("password")
            password2 = serializer.validated_data.get("password2")
            
            if password == password2:
                if User.objects.filter(email=email).exists():
                    return JsonResponse({'error': 'Email Already Used'}, status=status.HTTP_400_BAD_REQUEST)
                elif User.objects.filter(username=username).exists():
                    return JsonResponse({'error': 'Username Already Used'}, status=status.HTTP_400_BAD_REQUEST)
                else:
                    user = User.objects.create_user(username=username, email=email, password=password)
                    user.save()
                    return JsonResponse({'message': 'Registration successful'}, status=status.HTTP_200_OK)
            else:
                return JsonResponse({'error': 'Password did not match'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return JsonResponse({'error_messages': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

    return JsonResponse({'error': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)

@csrf_exempt
def search_users_view(request):
    if request.method == 'POST':
        searched = request.POST['searchTerm']
        
        user_by_username = User.objects.filter(username__icontains=searched)
        user_by_firstname = User.objects.filter(first_name__icontains=searched)
        user_by_lastname = User.objects.filter(last_name__icontains=searched)
        
        user_list = (user_by_username | user_by_firstname | user_by_lastname).distinct()
        
        profile_data = []
        for user in user_list:
            try:
                profile = Profile.objects.get(user=user)
                serializer = SearchProfile(profile) 
                profile_data.append(serializer.data) 
            except Profile.DoesNotExist:
                JsonResponse({'error': 'No user found'})
        print(profile_data)
        return JsonResponse({'profiles': profile_data}, safe=False)


@api_view(['PATCH'])
@permission_classes([IsAuthenticated])
def update_profile(request):
    user_profile = Profile.objects.get(user=request.user)

    if request.method == 'PATCH':
        serializer = UpdateProfileSerializer(user_profile, data=request.data, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



@api_view(['POST'])
@permission_classes([IsAuthenticated])
def follow_user(request, user_id):
    try:
        follower_profile = request.user.profile
        following_profile = Profile.objects.get(user=user_id)

        # Check if the user is not already followed
        if following_profile.user not in follower_profile.following.all():
            follower_profile.following.add(following_profile.user)
            following_profile.followers.add(request.user)

            return Response({"message": "You are now following user {}.".format(user_id)})
        else:
            return Response({"message": "You are already following user {}.".format(user_id)})
    except Profile.DoesNotExist:
        return Response({"message": "User with ID {} not found.".format(user_id)}, status=status.HTTP_404_NOT_FOUND)
    
# def logout(request):
#     auth.logout(request)
#     return redirect('/')


