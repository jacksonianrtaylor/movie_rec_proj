LOOK: might want a table of contents here....


# Goal:

The full_model.ipynb notebook builds a model that could be used to predict a users rating for an unwatched movie given that they submit a few ratings for movies they have watched.

This is an invaluable goal, because the model can give users an idea about how satisfied they will be with any movie. It is a step up form simply reccomending the best fit movies to the user. 

I also wanted the model inputs to not be so demanding for a client user. The users must only provide 4-9 ratings for movies they watched as well as the single movie they desire a rating for.

In theory the prediction uses a combination of the users data along with potentially massive amounts of rating data and movie data stored in a database.


[Click here to view the Jupyter Notebook](full_model.ipynb)

## Clarification:

The process should not be confused with predicting a critics score or some metascore from a review website. It predicts user scores. 

The model could benfit if the metadata was someway integrated in a column by column basis. However, these details were not part of the focus of the model.

The only way the movies metadata is used in the model, is with term frequencies from the combined corpus of relevant column attributes.


## Challenges:

* Many times, the users ratings are not accurate to their preference. This can introduce alot of noise. Garbage in garbage out.

* Intuitively, rating predictions to a users requested movie can be worse if the user only inputs a small number of rated movies because there is less data that can be used to compare to other users and therefore less potential to accuractely rate movies based on this type of similairity. However, it is best to train and test a model where test users enter a small number of ratings because it is an easier task for the user in a front-end implementation of this model. There is a massive tradeoff between user friendly service and accuracy.

* Predictions to a movies rating can be worse when there are a small number of users who rated that same movie.

* The iterative_svd function discussed later has hyperparameters that can to be optimized. This is the purpose of the bayesian_optimization.ipynb notebook. 

* Larger initial bounds for the optimization function likely gives better performing hyperparameter outputs but also leads to a higher computation time. 

* ALso, increasing the number of calls to the optimization function and the number of tests per call can help the model produce better hyperparametrs but it is expensive. This is why dask is used for parrallel processing and numba is used as a jit compiler for the by far most taxing function found in both notebooks "epoch".


## Data source

* The raw data collected for this program/model is soley from: https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset?select=movies_metadata.csv
* It is too large to fit in the repository and reqires user credentials to download. (see the How to Install/Run section).


# Process: 

## preprocessing cells(1-4)


The first portion of the full_model.ipynb notebook (cells(1-4)) is used for preprocessing. 

Using pandas, complete data rows are removed where there is a lack of data for certain columns.

Then the data is combined into a dataframe with columns values like this: (user_id, movie_id, users_rating_for_movie, columns for movies metadata..)

After list conversion, for each user, a loop removes movies that already have a rating for that user.

Then the process randomly chooses users that fall into the apropriate bounds for the number of ratings to be a svd user, train user, or test user (It chooses 10000 of each).


LOOK: Put this in the optimization section:

It is important to distinguish svd users, train user, and test users.

SVD users are users that only contribute to the training. 
Their ratings are used as inputs to the iterative_svd function.

On the other hand, train and test users have ratings to pass to the iterative_svd function and have exactly one movie rating to be predicted by the svd.

The test users are limited because of the problem statement in the goal section. 
furthermore, train users should have the same bounds as the test users because the trained model should value features in the same way that
gives the most accurate prediction to the test ratings. It should not over or under inflate certain features by using more or less data to support them.

svd users dont have these restrictions and therefore should have more ratings. intuitively, the more svd ratings per user, the more it can contributes to the test and train predictions.

currently the svd users bounds are (20-30) ratings while test and train user bound are (5-10) ratings. 
To keep things simpler this was not part of the optmization process in bayesian_optimization.ipynb and the values are by no means optmial. 
Also, due to the sheer combinations of the min and max of the bounds it is better to optmize them manually. 

___

Finally extract the data from those users, structure it into a list, and write it into a csv file in this order (bounds_svd_users, bounds_train_users, bounds_test_users)

Then in the next part of the notebook (cells(5-8)) extracts the data in a format where random samples can be taken of the 10000 users of each type (user_to_data_svd, user_to_data_train, user_to_data_test)


## Overview for cells(5-8):

The next cells (cells(5-8)) in the full_model.ipynb notebook are for creating the model specified in the goals section.

There are three input features to the final model features 1, 2, and, 3 (both train and test version)

There is also target_rating_train used to train the model and target_rating_test to test the model

Each of these features stand on their own as predicitons to the target movie's rating but they each have a different method of doing so.

This is why there combination in a linear model is effective.


## Content Based Filtering:

### Feature_1:

Feature_1 is a non-weighted average of all the ratings for a user besides the target movie. This feature alone will not be the most precise since it does not value anything about the movie in question and is independent of what other users think about the movie. This feature works because target movie rating is inevitably linked to how high a user rates movies on average.

### Feature_2:

Feature_2 is a weighted average of the all the users ratings besides the target movie. The weighting for each rated movie is based on how similair the target movie is to the rated movies. The similairty is determined by cossine simialirty of normalized tf-idf vectors for word counts of a rated movie and a target movie. 


## Collaborative filtering:

### User Types:

It is important to distinguish svd users, train user, and test users.

SVD users are users that only contribute to the training. 
Their ratings are used as inputs to the iterative_svd function.

On the other hand, train and test users have ratings to pass to the iterative_svd function and have exactly one movie rating to be predicted by the svd.

The test users are limited because of the problem statement in the goal section. 
furthermore, train users should have the same bounds as the test users because the trained model should value features in the same way that
gives the most accurate prediction to the test ratings. It should not over or under inflate certain features by using more or less data to support them.

svd users dont have these restrictions and therefore should have more ratings. intuitively, the more svd ratings per user, the more it can contribute to the test and train predictions.

currently the svd users bounds are (20-30) ratings while test and train user bound are (5-10) ratings. 
To keep things simpler this was not part of the optmization process in bayesian_optimization.ipynb and the values are by no means optmial. 
Also, due to the sheer combinations of the min and max of the bounds it is better to optmize them manually.

### Feature_3:

Feature_3 is the prediction from the terms of the trained SVD for a (user, movie) combination:
(overall_average+b1[u]+b2[i]+np.dot(p[u],q[i]))
where u represnt the users index and i represents the movies index to be rated.

Before this prediction is made the svd_iterative function undergoes a process where it trains the SVD to make...
predictions with (overall_average+b1[u]+b2[i]+np.dot(p[u],q[i])) by using stochastic gradient descent to changes the variables b1[u], b2[i], q[i], p[u] in the direction that minimizes
the error between an actual rating and (overall_average+b1[u]+b2[i]+np.dot(p[u],q[i])). 

Initial Conditions:

nof movie x nof latent features:
q = gen_input.normal(0, .1, (nof_movies, n))

nof users x nof latent features:
p = gen_input.normal(0, .1, (nof_users, n))

Biases:
b1 = np.zeros(nof_users)
b2 = np.zeros(nof_movies)


#### Bayesian Optimization

The baysian optmization process is critical to the effectiveness of feature_3 in the final model.
This means that tuning the hyperparameters to the iterative svd funciton goes a long way.

This is what sparked the creation of the other notebook: bayesian_optimization.ipynb

The entire point of this notebook is to find the highest perfroming parameters for:
nof_svd_users, nof_train_users, nof_latent_features, epochs, rt, lr


What do these parameters mean?:

nof_svd_users is the number of users that that help train the iterative svd function but dont have a rating to be predicted by the trained svd.

The users themselves are not parameters becasue they should always be chosen randomly from the pool of svd users.

In the full_model.ipynb notebook the nof_train_users and nof_test_users are always equal and they are the number of users that both help train their respective model but also require prediction for exactly one of their movies.
(These emulate the users that the final trained model is designed for)

Again the users themselves are not parameters becasue they should always be chosen randomly.

Users are randomly chosen from the respective user_to_data_svd, user_to_data_train, user_to_data_test which each have 10000 users.

 
nof_latent_features: nof_factors in the iterative_svd function
    q : is a (nof_movies x nof_factors) array
    p : is a (nof_users x nof_factors) array
Epochs: nof cycles of stochastic gradient descent on the entire train list.
rt: regression term
lr: learning rate



## Final Model:

* The purpose of the final model (loosley speaking) is how much weight to give to each feature for the optimal prediction.

* The idea was that more than one predictor can fill in the short comings of a single model.

* After features (1, 2, and 3) for the train and test users and the target train and test ratings are collected then they are used to build a simple linear model(linear regression)

* Although feature 3 is overwelmingly the most critical feature to the model, with testing the prescence and abscence of features, Feature 1 and Feature 2 were shown have a positive impact on the linear regression model and the best performance was obtained by using all three features.


## Results:

* Gathering accurate and consistent results was a challenging task and is somewhat incomplete.

* The first challenge was finding the hyperparameters that produced the best results for the iterative_svd function. 

* A set of hyperparamters can simply produce good rmse by chance, meaning that the random conditions
in testing may contribute highly to its success.

* In order to mitigate this, many tests were done for each iteration of the gp_minimize function.
This means that the same parameter values were tested a large amount of times, each time diversifying the users involved by...
randomly selecting them from the larger pool. 

* Even with a large amount of tests (160 or 320) for each iteration, the optmization process seemed to inflate the RMSE results.

* This was observed when testing the same parameters for (160 or 320) times in a seperate cell. It showed that with these tests the average RMSE was higher than what was found in the optmimization process. In other words it produced worse results when generalizing to new data.

* Although increasing the number of tests in the bayesain optmiation process helped reduce the overestimation of the hyperparameters, there was still slight issues with over estimation. 

* Also, the more iterations of the bayesain optmiation process helps with outputing good parameters but it also increase the chance of over inflating them and likely required more tests per iteration to produce honest results.

* After many tests of the bayesian optmiation process, I decided to settle on hyperaprametrs produced by a 3 hour long process on my machine with the input parameters found here (LOOK: link to inputs) and the output hyperparameters foudn here (LOOK: link to hyperparameter results)

* The average RMSE results were the best so far and it genralizes relatively well, but there was still a descrepency between the perfromance in the optimization process and the generalization test. 

* The other challenge was with feature completion in the second to last cell in full_model.iypynb. Even though the structure is relative similair to the last cell of bayesian_optimization.ipynb, it has the addtional task of populating the train and test version of (features 1 2 and 3 and target rating). 

* I wanted this process to be accurate and consistent but not have a massive runtime since unlike the baysian optmiation process it should be practical to use and change as needed.

There seemed to be good consistency in RSME when number of runs was = 160 regardless of the seed. When the number of runs is increased the less the input seed matters. However, that would take ~30 minute to run on my machine. 

* I left the number of runs at 40 which would make 8 blocks of size 5. 

* LOOK: What are the model results in the final cell from different seeds (10, 20, 30)


...needs to somewhere else
* Something That was not previously mentioned but still importaant to the model are the svd, train and test bounds

# Tips for the notebooks:

* Currently, an excessive amount of data is randomly selected from the full dataset of applicable users (10000 of each users type) to make random selection from these user types diverse. In (cell 1 - cell 4) this data is written to the "constructed_data.csv" file in the order of svd, train, and test users.

* When (cell 1 - cell 4) have been run to completion, the data persists in the form of "constructed_data.csv" so that only (cell 5 - cell 8) needs to be rerun for training and testing to save time when testing new parameters. (cell 5 - cell 8) are for transforming the data in "constructed_data.csv" to build a model.

* Don't run the bayesian_optimization.ipynb unless you have ample time to wait and enough memory on your machine. 
It is only included for informative purposes and does not need to be run again. However, it could be useful to try larger params to get marginally more accuracte and honest results.




# How to install/run:

* Requirements:
    * Git
    * python3 and pip (my working python version: 3.10.7)
    * kaggle account and API token

1. Clone the repository with git.
2. With python3 and pip:
    1. Create a python virtual env in the main project directory. (my working python version: 3.10.7)
    2. Install the following packages to the virtual env: opendatasets, pandas, numpy, scikit-learn, scipy, ordered-set, gensim, nltk, jupyter
    5. Activate the virtual environment

3. Open the complete_11_03_2023.ipynb file in the main project directory and connect to the kernel of the python virtual environmenty you created.

4. Run the complete_11_03_2023.ipynb notebook.

5. Kaggle Requirments (same as above):

    * Upon running the first cell for the first time in the containers lifetime, the user will be asked for their username and key which can be found in a fresh api token from kaggle.

    * Instructions to get api token to authenticate the data request(Note: kaggle account required):
        1. Sign into kaggle.
        2. Go to the 'Account' tab of your user profile and select 'Create New Token'.
        3. This will trigger the download of kaggle.json, a file containing your API credentials.

    * If the files have already been downloaded and stored in the "the-movies-dataset" folder, than this cell does nothing and requires no credentials.

6. Lastly, wait for the rest of the cells to finish and observe the results printed for each cell.







LOOK: Does the fact that svd, train, and test user can be used more than once introduce problems???
Not really when they are chosen randomly and there is a large selection.


LOOK: Does the fact that the same set of svd users are used for testing and training introduce problems???

Suppose you want to give a rating to a completely new user. 
you find feature 1 and feature 2
with feature 3 you use a sample of the same collection of svd users used in training from the database
and a sample of the train/test users used in training from the database


In the training of the model the same set of svd users are used for testing and training



LOOK: https://choosealicense.com/
https://choosealicense.com/no-permission/

LOOK: NO more than two code cells per markdown cell???
https://www.dataquest.io/blog/how-to-share-data-science-portfolio/

LOOK:
How to write good notebooks:
https://www.youtube.com/watch?v=tVhh46f6_Dk








