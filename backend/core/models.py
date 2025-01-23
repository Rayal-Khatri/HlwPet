from django.db import models
from django.contrib.auth.models import User, AbstractUser, BaseUserManager, PermissionsMixin

from django.contrib.auth.models import PermissionsMixin
from cloudinary_storage.storage import MediaCloudinaryStorage
from core.utlis import random_id
import uuid

class Profile(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile_user')
    bio = models.TextField(blank=True)
    phone_number = models.CharField(max_length=20)  
    address = models.CharField(max_length=255)  
    dob = models.DateField(auto_now_add=True)
    pet_info = models.ManyToManyField('Pet', blank=True)
    followers = models.ManyToManyField(User, related_name='following', blank=True)
    following = models.ManyToManyField(User, related_name='followers', blank=True)
    photo = models.ImageField(upload_to='profile_photos/', blank=True, null=True)
    cover_photo = models.ImageField(
        upload_to='profile_covers/',
        blank=True,
        null=True,
        storage=MediaCloudinaryStorage()
    )

    def __str__(self):
        return self.user.username


class Pet(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    species = models.CharField(max_length=255)  
    breed = models.CharField(max_length=255)
    age = models.PositiveIntegerField()
    owner = models.ForeignKey(Profile, on_delete=models.CASCADE, related_name='pets')
    petphoto = models.ImageField(upload_to='pet_photos/', blank=True, null=True)

    def __str__(self):
        return self.name+ " owned by "+ self.owner.user.username
