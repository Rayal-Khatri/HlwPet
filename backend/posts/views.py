# from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import get_object_or_404
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.response import Response
# from rest_framework.parsers import JSONParser
from rest_framework import status
# from rest_framework.permissions import IsAuthenticated
# from rest_framework_simplejwt.authentication import JWTAuthentication
from posts.models import *
from posts.serializers import *
from posts.post_recomendation import get_post_recommendations
from posts.utlis import get_latest_post_id
from core.utlis import get_user_id_from_token
import csv
from django.http import FileResponse
from tempfile import NamedTemporaryFile
from core.utlis import get_user_id_from_token


@api_view(['GET'])
def display_posts(request):
    if request.method == 'GET':
        latest_posts = Post.objects.all().order_by('-created_at')[:5]
        serializer = ViewPostSerializer(latest_posts, many=True)
        print(serializer.data)
        return Response(serializer.data[:5])
    
    
@api_view(['GET', 'POST'])
def post_create(request):
    auth_header = request.headers.get('Authorization')
    user_id = get_user_id_from_token(auth_header)
    print(user_id)
    if user_id is None:
        return Response({'error': 'Invalid or expired token'}, status=status.HTTP_401_UNAUTHORIZED)
    user_queryset = User.objects.get(id=user_id) 
    if request.method == 'POST':
        serializer = CreatePostSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(author=user_queryset)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    

@api_view(['GET'])
def display_posts_recomm(request):
    if request.method == 'GET':
        auth_header = request.headers.get('Authorization')
        user_id = get_user_id_from_token(auth_header)

        post_id = get_latest_post_id(user_id)
        if post_id is not None:
            latest_posts_ids = get_post_recommendations(post_id)
            latest_posts = Post.objects.filter(id__in=latest_posts_ids)
            serializer = ViewPostSerializer(latest_posts, many=True)
            return Response(serializer.data[:10])
        else:
            return Response({"error": "Unable to retrieve recommended posts."}, status=500)



def export_posts_to_csv(request):
    # Create a temporary file to write CSV data
    temp_file = NamedTemporaryFile(delete=False)

    # Write CSV data to the temporary file
    with open(temp_file.name, 'w', newline='', encoding='utf-8') as csv_file:
        writer = csv.writer(csv_file)
        
        # Write header
        writer.writerow(['Post ID', 'Community ID', 'Community Name', 'Author ID', 'Author Username', 'Created At', 'Title', 'Content'])

        # Retrieve data from the Post model (customize as per your model fields)
        posts = Post.objects.all()

        # Write data to CSV
        for post in posts:
            author_id = post.author.id
            author_username = post.author.username
            community_id = post.community.id if post.community else ''
            community_name = post.community.community_name if post.community else ''

            writer.writerow([post.id, community_id, community_name, author_id, author_username, post.created_at, post.title, post.content])

    # Create a FileResponse with the temporary file
    response = FileResponse(open(temp_file.name, 'rb'), as_attachment=True, filename='post_dataset.csv')

    # Delete the temporary file after it's served
    temp_file.close()

    return response

    
# @api_view(['GET'])
# def post_list(request, pk):
#     post = get_object_or_404(Post, pk=pk)
#     serializer = ViewPostSerializer(post)
#     return Response(serializer.data)

@api_view(['GET'])
def post_community_list(request, id):
    posts = Post.objects.filter(community__id=id)
    serializer = ViewPostSerializer(posts, many=True)
    return Response(serializer.data)

    
    
    

# @api_view(['GET', 'PUT'])
# @permission_classes([IsAuthenticated])
# def post_edit(request, pk):
#     post = get_object_or_404(Post, pk=pk)

#     if request.method == 'GET':
#         serializer = PostSerializer(post)
#         return Response(serializer.data)

#     elif request.method == 'PUT':
#         # Ensure that the user updating the post is the original author
#         if request.user != post.author:
#             return Response({'status': 'error', 'message': 'You do not have permission to edit this post'},
#                             status=status.HTTP_403_FORBIDDEN)

#         serializer = PostSerializer(post, data=request.data)
#         if serializer.is_valid():
#             serializer.save()
#             return Response(serializer.data, status=status.HTTP_200_OK)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# @api_view(['GET', 'POST'])
# def comment_create(request, post_pk):
#     post = get_object_or_404(Post, pk=post_pk)

#     if request.method == 'GET':
#         comments = Comment.objects.filter(post=post)
#         serializer = CommentSerializer(comments, many=True)
#         return Response(serializer.data)

#     elif request.method == 'POST':
#         serializer = CommentSerializer(data=request.data)
#         if serializer.is_valid():
#             serializer.save(author=request.user, post=post)
#             return Response(serializer.data, status=status.HTTP_201_CREATED)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# @api_view(['POST','GET'])
# @permission_classes([IsAuthenticated])
# def upvote_create(request, post_pk):
#     post = get_object_or_404(Post, pk=post_pk)
#     if request.method == 'POST':
#         upvote, created = Upvote.objects.get_or_create(user=request.user, post=post)
#         if created:
#             return Response({'status': 'success', 'message': 'Upvoted successfully'}, status=status.HTTP_201_CREATED)
#         return Response({'status': 'error', 'message': 'Already upvoted'}, status=status.HTTP_400_BAD_REQUEST)
#     if request.method == 'GET':
#         return Response({'status': 'success', 'message': 'GET'}, status=status.HTTP_201_CREATED)