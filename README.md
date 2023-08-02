Goal:

The goal of the program is building a model to predict what a user would rate a particular movie based on their rating to other movies. 
This should not be confused with predicting a critics score to the movie.
Rather, it predicts what the target user would score the movie as though it had already been watched.

This is not to be confused with picking movies that are good fit compared to the users movie preference. Instead it seeks to be useful for every user-movie combination even movies that the user would hate.



Process: 

Similarity scores are collected between a randomly selected movie the user has watched and rated to the rest of the movies the user has watched and rated. 

An list of input features to the model includes statsticss about the movie to guess the rting rating for (not including rating), sataistics for a single other movie that the user has watched (including rating) and the simialirty score between the movie whose rating is known and the movie whose movie is to be predicted by the model. Then each prediction is agrergated  and summed for all the other movies the used has watched

The similarity score is calculated by comparing the unrated movie and a movies the user has watched by count vectorizing...
the words/terms formed by combining textual data from metadata, keywords, ratings, and credits for both of the movies in question.
cossine similarity is used to compute the similairty between the the count vectorized versions of both combined texts.


feeding the model both the similarities of movies that the user has watched to the movie to be rated and the user ratings of the movies seen by the user it is expected that the model would be able to derive some idea of the the unwatched movies rating. 

For instance, if a movie is given a high rating and is simlair to the un-watched movie though (cosine similarity) it should be expected that the unwatched movie in question should also be similair in rating.

The model used is the mlp regresssor model...
















(LOOK) very important...
paper with similair intention:
https://www.sjsu.edu/faculty/guangliang.chen/Math285F15/285ProjectPaper.pdf





extras:

need to make sure that it is knowm that the version of python is 3.10.7

also be aware of requiremnts.txt

#https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html
#https://stackoverflow.com/questions/55296675/is-is-necessary-to-normalize-data-before-using-mlpregressor
#https://www.youtube.com/watch?v=uet8ZQpyJV8&ab_channel=NeuralNine
#https://stats.stackexchange.com/questions/278566/if-you-standardize-x-must-you-always-standardize-y



#feature importance scores:
#https://scikit-learn.org/stable/modules/permutation_importance.html
#https://scikit-learn.org/stable/modules/generated/sklearn.inspection.permutation_importance.html#sklearn.inspection.permutation_importance

#introduction:
#https://www.kaggle.com/code/dansbecker/permutation-importance

#types of feature importance:
#https://towardsdatascience.com/6-types-of-feature-importance-any-data-scientist-should-master-1bfd566f21c9


data transformation:
https://datascience.stackexchange.com/questions/45900/when-to-use-standard-scaler-and-when-normalizer
