import pandas as pd
from scipy import sparse
import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity

ratings = pd.read_csv('dataset/ratings.csv')
moviesPartial = pd.read_csv('dataset/movies.csv')
moviesFull = pd.read_csv('dataset/movie_dataset.csv')

#remember that all movies being chosen to add with their rating must
#exist in both movie Half and moviesFull datasets
#they should be found by name since the ids are different 
#the inputs of both the collaborative anaylis as well as conten based analysis
#will be used in the regresion model

ratings = ratings.drop(['timestamp'], axis = 1)

firstUserRatings  = ratings[ratings['userId'] ==1]

moviesPartial = moviesPartial.drop(['genres'],axis=1)

moviesPartial['title'] = moviesPartial['title'].map(lambda string: string[:-7])

#print(firstUserRatings["movieId"])

def get_title_from_movieId(movieId):
    return moviesPartial[moviesPartial["movieId"] == movieId]["title"].values[0]

firstUserTitles = []
for item in firstUserRatings["movieId"]:
    firstUserTitles.append(get_title_from_movieId(item))

print(len(firstUserTitles))

fullInfo = pd.DataFrame(columns = list(moviesFull.columns))

#print(fullInfo.columns)



for name in firstUserTitles:
    if(len(moviesFull[moviesFull["title"] == name]) ==1):
        fullInfo.loc[len(fullInfo.index)] = moviesFull[moviesFull["title"] == name].iloc[0]

#print(fullInfo)

print(len(fullInfo))
print(fullInfo)
userRatings = []


#print(moviesPartial['title'])


# for item in userRatings:
#     if item[0] in moviesPartial['title'] and item[0] in moviesFull['title']:
#         #hypothesis function
#         hypothesis
#     else:
#         print(item[0], "not found!")



features = ['keywords','cast','genres','director']

def combine_features(row):
    return row['keywords']+" "+row['cast']+" "+row['genres']+" "+row['director']

for feature in features:
    moviesFull[feature] = moviesFull[feature].fillna('') #filling all NaNs with blank string

moviesFull["combined_features"] = moviesFull.apply(combine_features,axis=1)


cv = CountVectorizer() #creating new CountVectorizer() object
count_matrix = cv.fit_transform(moviesFull["combined_features"])
#print(count_matrix)


cosine_sim = cosine_similarity(count_matrix)

def get_title_from_index(index):
    return moviesFull[moviesFull.index == index]["title"].values[0]
def get_index_from_title(title):
    return moviesFull[moviesFull.title == title]["index"].values[0]


movie_user_likes = "Avatar"
movie_index = get_index_from_title(movie_user_likes)





similar_movies = list(enumerate(cosine_sim[movie_index]))


#find the nest matches
sorted_similar_movies = sorted(similar_movies,key=lambda x:x[1], reverse = True)[1:6]




#simply print
i=0
# print("Top 5 similar movies to "+movie_user_likes+" are:\n")
# for element in sorted_similar_movies:
#     print(get_title_from_index(element[0]))
#     print(element[1])
#     i=i+1
#     if i>5:
#         break

#cosine_sim = cosine_similarity(count_matrix)


#the inputs of both the collaborative analysis as well as conten based analysis
#will be used in the regresion model

#how do we get the training dataset for this?

#for each user:
#take a random selection of half the users movie ratings and use the other half in the...
#content based analysis and collaborative analysis  
#generate the expected ratings for the content based analysis and collaborative using one half to predict
#the ratings for the other half
#furthermore use linear regression with the content based and the collaborative based output as inputs
#use gradient descent to update the linear model

#for a user:
#since the content based analysis is simply comparing movies together for how simlair they are...
#for each movie in the first half(unknown rating)...
#there will be a similarity score for each item of the second half of the movies (known rating)
#each movie in the second half will test its simlairity for an item in the first half...
#and will contribute to that items predicted rating based on its similairty score and rating

#how will it contribute?:
#example:

#three sim scores: 1,1,1
#three corresponding ratings: 2,3,4

#(1*(2-2.5)+1*(3-2.5)+1*(4-2.5))/3 = (-.5+.5+1.5)/3 = .5 + 2.5 = 3

#three sim scores: .8,.75,.9
#three corresponding ratings: 2,3,4

#(.8*(2-2.5)+.75*(3-2.5) +.9*(4-2.5))/3 = (-.4+.375+1.35)/3 + 2.5 = .44167 + 2.5 = 2.94167

#note: cosine similairity is betwen (-1,1) if not simly map from (0,1) it before calling






