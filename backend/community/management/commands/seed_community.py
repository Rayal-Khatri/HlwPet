from django.core.management.base import BaseCommand
from django_seed import Seed
from django.contrib.auth.models import User
from core.models import Profile
from community.models import CommunityProfile, CommunityMembership
from faker import Faker
import random

fake = Faker()

class Command(BaseCommand):
    help = 'Seed the database with sample communities, users, and admins'

    def handle(self, *args, **kwargs):
        seeder = Seed.seeder()

        # Generate 5 communities
        seeder.add_entity(CommunityProfile, 5, {
            'community_name': lambda x: fake.word(),
            'description': fake.text(),
        })

        inserted_community_profiles = seeder.execute()

        # Generate 20 profiles for each community with 2 admins
        for community_profile_id in inserted_community_profiles[CommunityProfile]:
            community_profile = CommunityProfile.objects.get(id=community_profile_id)

            # Pick 20 profiles at random
            all_profiles = list(Profile.objects.all())
            members = random.sample(all_profiles, k=min(20, len(all_profiles)))

            # Ensure user with id=1 is one of the admins
            admin_users = [User.objects.get(id=1)] + random.sample(members, k=1)

            # Assign profiles to the community
            for profile_instance in members:
                community_membership = CommunityMembership.objects.create(user=profile_instance.user, community=community_profile)
                if profile_instance in admin_users:
                    community_membership.is_admin = True
                community_membership.save()

                self.stdout.write(self.style.SUCCESS(
                    f"User '{profile_instance.user.username}' added to community '{community_profile.community_name}'."
                ))

        self.stdout.write(self.style.SUCCESS('Communities, users, and admins created successfully.'))
