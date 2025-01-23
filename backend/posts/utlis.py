from django.db.models import Max
from random import choice
from .models import Post

def get_latest_post_id(user_id=None):
    if user_id:
        user_posts = Post.objects.filter(author__id=user_id).values_list('id', flat=True)

    if user_posts:
        return choice(user_posts)
    
    all_post_ids = Post.objects.values_list('id', flat=True)
    return choice(all_post_ids) if all_post_ids else None
