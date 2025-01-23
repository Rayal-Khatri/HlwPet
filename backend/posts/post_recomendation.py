import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
import pickle

def get_post_recommendations(post_id, num_recommendations=10):
    # Load the necessary data
    df = pd.read_csv('posts/preprocesses_data.csv')
    vector = pickle.load(open("posts/utils/vector.pkl", "rb"))
    cv = pickle.load(open("posts/utils/cv.pkl", "rb"))

    # Get the query post
    query_post = df[df['Post ID'] == post_id]['tags'].values[0]

    # Vectorize the query post
    query_post_vec = cv.transform([query_post])

    # Calculate cosine similarity between query post and all posts
    similarity_scores = cosine_similarity(query_post_vec, vector).flatten()

    # Sort the posts based on similarity scores
    sorted_indices = np.argsort(-similarity_scores)

    # Get the top recommendations
    top_recommendations = sorted_indices[1:num_recommendations+1]

    # Return the post IDs of the top recommendations
    return df.iloc[top_recommendations]['Post ID'].tolist()
