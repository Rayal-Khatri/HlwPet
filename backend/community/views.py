from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import get_object_or_404
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.response import Response
from rest_framework.parsers import JSONParser
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from .models import *
from .serializers import *
from core.utlis import get_user_id_from_token

#views
@api_view(['POST'])
@authentication_classes([JWTAuthentication])
@permission_classes([IsAuthenticated])
def create_community(request):
    if request.method == 'POST':
        auth_header = request.headers.get('Authorization')
        user_id = get_user_id_from_token(auth_header)
        if user_id is None:
            return Response({'error': 'Invalid or expired token'}, status=status.HTTP_401_UNAUTHORIZED)

        json_object = request.data
        serializer = CommunityProfileSerializer(data=json_object)

        if serializer.is_valid():
            community_name = serializer.validated_data.get("community_name")
            description = serializer.validated_data.get("description")

            if CommunityProfile.objects.filter(community_name=community_name).exists():
                return Response({'error': 'Community Name Already Used'}, status=status.HTTP_400_BAD_REQUEST)
            else:
                community = CommunityProfile.objects.create(
                    community_name=community_name,
                    description=description,
                )

                user_instance = User.objects.get(id=user_id)
                if user_instance is not None:
                    membership = CommunityMembership.objects.create(
                        user=user_instance,
                        community=community,
                        is_admin=True  # Assuming you want the creator to be an admin
                    )
                else:
                    return Response({'message': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
                return Response({'message': 'Community is created successfully'}, status=status.HTTP_200_OK)

        errors = serializer.errors
        return Response(data={'errors': errors}, status=status.HTTP_400_BAD_REQUEST)

    return Response(data={'message': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)



@api_view(['GET'])
def community_profile_list(request):
    communities = CommunityProfile.objects.all()
    serializer = CommunityListingSerializer(communities, many=True)
    print(serializer.data)
    return Response(data={'data': serializer.data}, status=status.HTTP_200_OK)

@api_view(['GET'])
def community_profile_detail(request, pk):
    auth_header = request.headers.get('Authorization')
    user_id = get_user_id_from_token(auth_header)

    if user_id is None:
        return Response({'error': 'Invalid or expired token'}, status=status.HTTP_401_UNAUTHORIZED)

    try:
        community = CommunityProfile.objects.get(id=pk, members=user_id)
    except CommunityProfile.DoesNotExist:
        return Response(data={'error': 'Community not found or user is not the creator'}, status=status.HTTP_404_NOT_FOUND)

    serializer = CommunityProfileSerializer(community)
    return Response(data={'data': serializer.data}, status=status.HTTP_200_OK)

api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_member_by_admin(request, cid):
    auth_header = request.headers.get('Authorization')
    admin_user_id = get_user_id_from_token(auth_header)

    try:
        community = CommunityProfile.objects.get(id=cid, members=admin_user_id)
    except CommunityProfile.DoesNotExist:
        return Response({'error': 'Community not found or user is not the admin'}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'POST':
        serializer = CommunityMembershipSerializer(data=request.data)
        
        if serializer.is_valid():
            user = serializer.validated_data.get('user')

            if not CommunityMembership.objects.filter(user=user, community=community).exists():
                membership = CommunityMembership.objects.create(
                    user=user,
                    community=community,
                    is_admin=False  # Set to True if the admin wants to make the user an admin immediately
                )
                
                return Response({'message': 'Member added successfully'}, status=status.HTTP_201_CREATED)
            else:
                return Response({'error': 'User is already a member of the community'}, status=status.HTTP_400_BAD_REQUEST)

        errors = serializer.errors
        return Response(data={'errors': errors}, status=status.HTTP_400_BAD_REQUEST)

    return Response(data={'message': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)

@csrf_exempt
@api_view(['POST'])
def community_application(request):
    if request.method == 'POST':
       
        data = JSONParser().parse(request)
        serializer = CommunityApplicationSerializer(data=data)
        
        if serializer.is_valid():
            application = serializer.save(status='Pending')

            return Response(data={'data': serializer.data}, status=status.HTTP_201_CREATED)

        errors = serializer.errors
        return Response(data={'errors': errors}, status=status.HTTP_400_BAD_REQUEST)

    return Response(data={'message': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)

@csrf_exempt
@api_view(['GET', 'PATCH'])
def community_admin_view(request):
    if request.method == 'GET':
        # Retrieve pending forms
        pending_applications = CommunityApplication.objects.filter(status='Pending')
        serializer = CommunityApplicationSerializer(pending_applications, many=True)
        return Response(data={'status': 'success', 'data': serializer.data}, status=status.HTTP_200_OK)

    elif request.method == 'PATCH':
        # Parse JSON data from the request
        data = JSONParser().parse(request)

        try:
            # Retrieve the application
            application = CommunityApplication.objects.get(id=data.get('id'), status='Pending')
        except CommunityApplication.DoesNotExist:
            return Response(data={'status': 'error', 'message': 'Application not found or already processed'}, status=status.HTTP_404_NOT_FOUND)

        # Update the application status based on the action
        if data.get('action') == 'approve':
            application.status = 'Approved'
        elif data.get('action') == 'reject':
            application.status = 'Rejected'
        else:
            return Response(data={'status': 'error', 'message': 'Invalid action'}, status=status.HTTP_400_BAD_REQUEST)

        application.save()

        # Return the updated application data
        serializer = CommunityApplicationSerializer(application)
        return Response(data={'status': 'success', 'data': serializer.data}, status=status.HTTP_200_OK)

    return Response(data={'status': 'error', 'message': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)

# @csrf_exempt
# def make_community_admin(request, community_id, user_id):
#     if request.method == 'PATCH':
#         print(1)
#         try:
#             # Ensure the user making the request is an admin of the community
#             community_membership = CommunityMembership.objects.get(
#                 user=request.user,
#                 community_id=community_id,
#                 is_admin=True
#             )
#         except CommunityMembership.DoesNotExist:
#             return Response(data={'status': 'error', 'message': 'You do not have permission to make someone an admin'}, status=status.HTTP_403_FORBIDDEN)

#         try:
#             # Find the membership for the user to be made an admin
#             target_user_membership = CommunityMembership.objects.get(user_id=user_id, community_id=community_id)
#             target_user_membership.is_admin = True
#             target_user_membership.save()
#             print(target_user_membership)
#             serializer = CommunityMembershipSerializer(target_user_membership)
#             return Response(data={'data': serializer.data}, status=status.HTTP_200_OK)

#         except CommunityMembership.DoesNotExist:
#             return Response(data={'message': 'User not found in the community'}, status=status.HTTP_404_NOT_FOUND)

#     return Response(data={'message': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)

@csrf_exempt
def make_community_admin(request, community_id, user_id):
    try:
        target_user_membership = CommunityMembership.objects.get(user_id=user_id, community_id=community_id)
        print(target_user_membership)
        return Response(data={'data': target_user_membership}, status=status.HTTP_200_OK)
    except:
        return Response(data={'message': 'User not found in the community'}, status=status.HTTP_404_NOT_FOUND)
    
    
    
# def post(request):
#     if request.method == 'GET':
#         queryset = Post.objects.all()
#         serializer = PostSerializer(queryset)
#         return Response(data={'data': serializer.data}, status=status.HTTP_200_OK)
#     if request.method == 'POST':
#         data = JSONParser().parse(request)
#         serializer = PostSerializer(data=data)
#         if serializer.is_valid():
#             serializer.save()
#             return Response({
#                 'message': 'Post has been created',
#                 'data': serializer.data
#             },status=status.HTTP_200_OK)
#         else:
#             return Response(data={'message': 'Post has not been created try again'}, status=status.HTTP_404_NOT_FOUND)
#     if request.method == 'PATCH':
#         pass
    





