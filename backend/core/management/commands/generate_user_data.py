# seed_data.py
import random
import pandas as pd
from django_seed import Seed
from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from django.core.files import File
from faker import Faker
from core.utlis import get_media_paths_for_directory
from core.models import *

fake = Faker()

# # Generates breed list
# csv_file_path = r'F:\Projects\Pet_App\backend\ml_model\data\breed_list.csv'
# df = pd.read_csv(csv_file_path)
# breed_list = df['breed'].tolist()

# # Generates photos paths list
# photo_directory = 'profile_photos'
# profile_photo_paths = get_media_paths_for_directory(photo_directory)
# profile_photo_queue = list(profile_photo_paths)

# photo_directory = 'Pet'
# pet_photo_paths = get_media_paths_for_directory(photo_directory)
# pet_photo_queue = list(pet_photo_paths)

# Start the generation
class Command(BaseCommand):
    help = 'Seed the database with sample data'

    def handle(self, *args, **kwargs):
        seeder = Seed.seeder()

        seeder.add_entity(User, 200, {
            'password': 'whysohansome',
        })

        seeder.execute()

        users = User.objects.all()
        
        for user in users:
            user.set_password('whysohansome')
            user.save()


        self.stdout.write(self.style.SUCCESS('User created successfully.'))
