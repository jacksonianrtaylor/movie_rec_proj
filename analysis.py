import pandas as pd
from scipy import sparse

ratings = pd.read_csv('dataset/ratings.csv')
moviesPartial = pd.read_csv('dataset/movies.csv')
moviesFull = pd.read_csv('dataset/movie_dataset.csv')

#remember that all movies being chosen to add with their rating must
#exist in both movie Half and moviesFull datasets
#they should be found by name since the ids are different 
#the inputs of both the collaborative anaylis as well as conten based analysis
#will be used in the regresion model

ratings = ratings.drop(['timestamp'], axis = 1)

moviesPartial = moviesPartial.drop(['genres'],axis=1)

print(list(ratings.columns))
print(list(moviesPartial.columns))
print(list(moviesFull.columns))

print(list(moviesFull.dtypes))


userRatings = []

moviesPartial['title'] = moviesPartial['title'].map(lambda string: string[:-7])

print(moviesPartial['title'])


for item in userRatings:
    if item[0] in moviesPartial['title'] and item[0] in moviesFull['title']:
        #hypothesis function
        hypothesis
    else:
        print(item[0], "not found!")


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






