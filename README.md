Goal:

The goal of the program is to predict what a user would rate a particular movie based on their rating to other movies. 

This should not be confused with predicting a critics score to the movie.

Rather, it predicts what the target user would score the movie as though it had already been watched.



The basic model collects similarity scores between each of the movies the user has watched and rated and the movie in question (which rating needs to be predicted)

This similarity score is calculated by comparing the unrated movie and a movies the user has watched by count vectorizing...

the words/terms formed by combining textual data from metadata, keywords, ratings, and credits for both of the movies in question.

cossine similarity is used to compute the similairty between the the count vectorized versions of both combined texts.


It also collects the rating of the movies the user has watched. 

feeding the model both the similarities of movies that the user has watched to the movie to be rated and the user ratings of the movies seen by the user it is expected that the model would be able to derive some idea of the the unwatched movies rating. 

For instance, if a movie is given a high rating and is simlair to the un-watched movie though (cosine similarity) it should be expected that the unwatched movie in question should also be similair in rating.














This is not to be confused with picking movies that are good fit compared to the users movie preference. Instead it seeks to be useful for every user-movie combination even movies that the user would hate.







Process:


Certain target features are picked to feed into a MLP model.










need to make sure that it is knowm that the version of python is 3.10.7

also be aware of requiremnts.txt