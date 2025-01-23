# posts/urls.py
from django.urls import path
from posts.views import *

urlpatterns = [
    # path('', display_posts, name='post-list'),
    path('', display_posts_recomm, name='post-list'),
    path('int <id>', post_community_list, name='post-community-list'),
    path('create', post_create, name='create post'),
    path('export_posts_to_csv', export_posts_to_csv, name='export_posts_to_csv'),
    # path('upvote/int <post_pk>', upvote_create, name='create upvote'),
    # path('comment', comment_create, name='create comment'),
]