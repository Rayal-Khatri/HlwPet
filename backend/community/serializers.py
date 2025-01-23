# community/serializers.py
from rest_framework import serializers
from community.models import *

class CommunityUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id","username","first_name","last_name"]

class CommunityMembershipSerializer(serializers.ModelSerializer):
    users = CommunityUserSerializer
    class Meta:
        model = CommunityMembership
        fields = ['users', 'community', 'is_admin']

class CommunityProfileSerializer(serializers.ModelSerializer):
    display_member = CommunityMembershipSerializer
    class Meta:
        model = CommunityProfile
        fields = '__all__'
        
class CommunityApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityApplication
        fields = '__all__'
        
        
class CommunityListingSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityProfile
        fields = ['community_name','id']
        