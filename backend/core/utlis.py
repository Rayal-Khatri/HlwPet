import jwt
import os
import random
from django.conf import settings

# utils.py
def get_user_id_from_token(auth_header):
    try:
        _, token = auth_header.split()
        secret_key = os.environ.get('SECRET_KEY')
        decoded_token = jwt.decode(token, key=secret_key, algorithms=['HS256'])
        user_id = decoded_token['user_id']
        return user_id
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None
    
def random_id():
    return random.randint(1, 2147483647)

#is not being used right now
def get_media_paths_for_directory(subdirectory):
   
    media_root = settings.MEDIA_ROOT
    subdirectory_path = os.path.join(media_root, subdirectory)

    file_paths = []

    if os.path.exists(subdirectory_path):
        for root, dirs, files in os.walk(subdirectory_path):
            for file in files:
                # Create a full path to the file
                file_path = os.path.join(root, file)
                # Add the file path to the list
                file_paths.append(file_path)

    return file_paths

