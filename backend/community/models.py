# models.py
import uuid
from django.db import models
from django.contrib.auth.models import User, Permission
from django.contrib.contenttypes.models import ContentType
from django.db import transaction
from cloudinary_storage.storage import MediaCloudinaryStorage
from core.utlis import random_id

class CommunityProfile(models.Model):
    id = models.AutoField(primary_key=True)
    community_name = models.CharField(max_length=255)
    description = models.TextField()
    members = models.ManyToManyField(User, through='CommunityMembership', blank=True, null=True)
    creation_date = models.DateTimeField(auto_now_add=True)
    photo = models.ImageField(
        upload_to='community_profile_photos/',
        blank=True,
        null=True,
        storage=MediaCloudinaryStorage()
    )
    cover_photo = models.ImageField(
        upload_to='community_covers/',
        blank=True,
        null=True,
        storage= MediaCloudinaryStorage()  # Use RawMediaCloudinaryStorage for images
    )

    def __str__(self):
        return self.community_name
    
class CommunityMembership(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    community = models.ForeignKey(CommunityProfile, on_delete=models.CASCADE)
    is_admin = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.user.username} - {self.community.community_name}"

    def make_user_admin(user, community):
        try:
            with transaction.atomic():
                # Assuming there is only one CommunityMembership for a user and community
                community_membership = CommunityMembership.objects.get(user=user, community=community)
                community_membership.is_admin = True
                community_membership.save()
                
                return True  # Indicates success
        except CommunityMembership.DoesNotExist:
            # Handle the case where there is no CommunityMembership for the user
            return False  # Indicates failure

class CommunityMembershipQuestion(models.Model):
    question_text = models.TextField(null=True)
    community = models.ForeignKey(CommunityProfile, on_delete=models.CASCADE)

    def __str__(self):
        return self.question_text

class CommunityMembershipAnswer(models.Model):
    answer_text = models.TextField(null=True)
    question = models.ForeignKey(CommunityMembershipQuestion, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return f"Answer by {self.user.username} to '{self.question.question_text}'"
    
class CommunityApplication(models.Model):
    id = models.AutoField(primary_key=True)
    PENDING = 'Pending'
    APPROVED = 'Approved'
    REJECTED = 'Rejected'

    STATUS_CHOICES = [
        (PENDING, 'Pending'),
        (APPROVED, 'Approved'),
        (REJECTED, 'Rejected'),
    ]

    full_name = models.CharField(max_length=100)
    email = models.EmailField()
    why_join = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default=PENDING)

    def __str__(self):
        return f"{self.full_name} - {self.status}"


# Create custom permission for administering the community
def create_custom_permission():
    content_type = ContentType.objects.get_for_model(CommunityMembership)
    permission = Permission.objects.create(
        codename='can_administer_community',
        name='Can administer community',
        content_type=content_type,
    )
    

# class SpecialNotice(models.Model):
#     title = models.CharField(max_length=200)
#     content = models.TextField()
#     created_at = models.DateTimeField(auto_now_add=True)
#     author = models.ForeignKey(User, on_delete=models.CASCADE)
#     community = models.ForeignKey(Community, on_delete=models.CASCADE)

#     def __str__(self):
#         return self.title