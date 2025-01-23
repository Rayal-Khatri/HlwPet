from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.contrib.auth.models import User
from .models import *

class UserRegistrationSerializer(serializers.Serializer):
    username = serializers.CharField()
    email = serializers.EmailField()
    password = serializers.CharField()
    password2 = serializers.CharField()

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=100)
    password = serializers.CharField(max_length=100)
    
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id","username","first_name","last_name"]
        

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = '__all__'
        
class PetSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pet
        fields = '__all__'
    

class PetOwnerProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    pets = PetSerializer(many=True, read_only=True)

    class Meta:
        model = Profile
        fields = ['user', 'bio', 'photo', 'dob', 'pets']
        

class UpdateUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["first_name", "last_name"]

class UpdateProfileSerializer(serializers.ModelSerializer):
    user = UpdateUserSerializer()

    class Meta:
        model = Profile
        fields = ['bio', 'user']

    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', {})
        instance.bio = validated_data.get('bio', instance.bio)

        user_serializer = UpdateUserSerializer(instance.user, data=user_data, partial=True)
        if user_serializer.is_valid():
            user_serializer.save()

        instance.save()
        return instance
    
class SearchUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["username","first_name","last_name"]  

class SearchProfile(serializers.ModelSerializer):
    user = SearchUserSerializer()

    class Meta:
        model = Profile
        fields = ['id', 'user','address']



        
# class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
#     @classmethod
#     def get_token(cls, user):
#         token = super().get_token(user)

#         # Add custom claims
#         token['name'] = user.username
#         return token