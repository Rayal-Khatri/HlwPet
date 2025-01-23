import pandas as pd
import re
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

def clean_title(title):
    return re.sub("[^a-zA-Z0-9 ]", "", title)

def search_items(itemset, search_term):
    itemset['name'] = itemset["name"].apply(clean_title)
    itemset['brand'] = itemset["brand"].apply(clean_title)
    itemset['description'] = itemset["description"].apply(clean_title)

    vectorizer = TfidfVectorizer(ngram_range=(1, 2))
    tfidf = vectorizer.fit_transform(itemset['name'])

    query_vec = vectorizer.transform([search_term])
    cossimilarity = cosine_similarity(query_vec, tfidf).flatten()

    indices = np.argpartition(cossimilarity, -5)[-10:]
    results = itemset.iloc[indices][::-1]
    results = results[['name', 'price (NRs)']]

    return results

# def item_search_widget(itemset):
#     item_input = widgets.Text(
#         value='',
#         placeholder='Search Item',
#         description='Item:',
#         disabled=False
#     )

#     item_list = widgets.Output()

#     def on_type(data):
#         with item_list:
#             item_list.clear_output()
#             name = data["new"]
#             if len(name) > 2:
#                 display(search_items(itemset, name))

#     item_input.observe(on_type, names='value')

#     display(item_input, item_list)

