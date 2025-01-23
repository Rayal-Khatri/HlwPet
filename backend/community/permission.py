from django.contrib.auth.models import User, Permission
from .models import CommunityProfile, CommunityMembership

def add_community_member(user, community, is_admin=False):
    membership = CommunityMembership.objects.create(user=user, community=community, is_admin=is_admin)
    if is_admin:
        permission = Permission.objects.get(codename='can_administer_community')
        user.user_permissions.add(permission)