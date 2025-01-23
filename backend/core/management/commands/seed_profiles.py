# seed_profiles.py
import random
from django_seed import Seed
from django.core.management.base import BaseCommand
from django.core.files import File
from faker import Faker
from core.models import *
from core.utlis import get_media_paths_for_directory
import pandas as pd

fake = Faker()

# Generates breed list
csv_file_path = r'F:\Projects\Pet_App\backend\ml_model\data\breed_list.csv'
df = pd.read_csv(csv_file_path)
breed_list = df['breed'].tolist()


class Command(BaseCommand):
    help = 'Seed the database with sample profiles and associated pets'

    def handle(self, *args, **kwargs):
        seeder = Seed.seeder()

        filter_conditions = {
            'id__range': (246,250),
        }
  
        users = User.objects.filter(**filter_conditions)

        for user in users:
                profile = Profile.objects.create(
                user=user,
                bio=fake.text(),
                phone_number=fake.phone_number(),
                address=fake.address(),
                dob=fake.date_of_birth(),
            )
                for _ in range(1):
                    pet_name = fake.first_name()
                    breed = random.choice(breed_list)
                    age = random.randint(7, 11)

                    pet = Pet.objects.create(
                        name=pet_name,
                        species=fake.word(),
                        breed=breed,
                        age=age,
                        owner=profile,
                        # petphoto=pet_photo
                    )

                self.stdout.write(self.style.SUCCESS(
                f"Pet '{pet_name}' with breed '{breed}' created for user '{profile.user.username}'."))
                            
        self.stdout.write(self.style.SUCCESS(f"Profile created for user '{user.username}'."))


