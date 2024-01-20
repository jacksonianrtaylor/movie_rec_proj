# Table of Contents:

1. [Project Goal](#project-goal)
2. [Process](#process)
3. [How to (Install/Run):](#how-to-installrun)


# Project Goal:

The [full_model.ipynb](full_model.ipynb) notebook builds a model that could be used to predict a client users rating for an unwatched movie given that they submit a few ratings for movies they have watched.

This is an invaluable objective, because the model can give users an idea about how satisfied they will be with any movie. It is a step up from simply recommending the best fit movies to the user.

One of my concerns was limiting the demand for the client user. In the current model, the user only needs to enter 4-9 ratings for movies they watched as well as the single movie they desire a rating for.

In theory, the prediction uses a combination of the users provided ratings along with potentially massive amounts of rating data and movie data stored in a database. The model is designed to harness this data with both content based and collaborative based filtering to make predictions.

The process should not be confused with predicting a critics score or some metascore from a review website. It predicts user scores which have there own set of rules.

The model could benefit if the metadata was someway integrated in a column by column basis. However, these details were not part of the focus of the model.

The only way the movies metadata is used in the model, is with term frequencies from the combined corpus of relevant column attributes.

[Link to the full_model Notebook](full_model.ipynb)


## Data source:

The raw data collected for this program/model is solely from: https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset?select=movies_metadata.csv

It is too large to fit in the repository and requires user credentials to download. [See How to (Install/Run).](#how-to-installrun)

# Process: 

## Preprocessing (cells(1-4)):


The first portion of the [full_model.ipynb](full_model.ipynb) notebook (cells(1-4)) is used for preprocessing.

* Using pandas, complete data rows are removed where there is a lack of data for certain columns.

* Then the data is combined into a dataframe with columns values like this: (user_id, movie_id, users_rating_for_movie, columns for movies metadata...)

* After converting the dataframe into a list, for each user, a loop removes rows of the list that contain a movie which already has a previous rating by the corresponding user. In other words, the first movie rating for a particular movie is kept on a user by user basis.


* Then the process randomly chooses users that fall into the appropriate bounds for the number of ratings to be a Singular_Value_Decomposition (SVD) user, train user, or test user (It chooses 10000 of each).


* Finally, the data is extracted from those users, structured into a list, and written into a csv file in this order (SVD users, train users, test users).

Then in the next part of the notebook, cells(5-8) extract the data in a format where random samples can be taken of the 10000 users of each type (user_to_data_svd, user_to_data_train, user_to_data_test).


## Overview for cells(5-8):

The next cells (cells(5-8)) in the [full_model.ipynb](full_model.ipynb) notebook are for creating the model specified in the goals section.

There are three input features to the final model (features 1, 2, and, 3).

Furthermore, there are train and test users with these features in addition to a target rating from one of their randomly selected movies. Intuitively, train users train the final model against their target rating and test users test the final model against their target rating.

For each user (train or test), feature_1 and feature_2 are respectively un_weighted and weighted averages of the users non-target movie ratings and serve as predictions to the users target movie rating. feature_3 is another rating prediction of the users target movie by an SVD model using the best hyperparameters found in the [bayesian_optimization.ipynb](bayesian_optimization.ipynb) notebook.

Each of the three features stand on their own as predictions to the target movie's rating but they each have a different method of making these predictions.

This is why their combination in a linear model is effective.


## Content Based Filtering:

### Feature_1: 

Feature_1 is a non-weighted average of all the ratings for a user besides the target movie. This feature alone will not be the most precise since it does not value anything about the movie in question and is independent of what other users think about the movie. This feature works because a target movie rating is inevitably linked to how high a user rates movies on average.

### Feature_2:

Feature_2 is a weighted average of the all the users ratings besides the target movie. The weighting for each rated movie is based on how similar the target movie is to the rated movies. The similarity is determined by cosine similarity between the normalized 
tf-idf vectors of the word counts of the target movie and the normalized 
tf-idf vectors of the word counts of other movies provided by the user.


## Collaborative filtering:

### User Types:

It is important to distinguish SVD users, train user, and test users.

SVD users are users that only contribute to the training. 
Their ratings are used as inputs to the iterative_svd function.

On the other hand, train and test users have ratings to pass to the iterative_svd function to train the model and they also have exactly one movie rating to be predicted by the SVD model.

The number of test users are limited because of the problem statement in the [goal section](#project-goal). 
Furthermore, train users should have the same bounds as the test users because the trained model should value features in the same way that
gives the most accurate prediction for the test ratings. It should not over or under estimate certain features by using more or less data to support them.

SVD users don't have these restrictions and therefore should have more ratings. Intuitively, the more SVD ratings per user, the more it can positively interact with train and test users.

Currently, the SVD users bounds are (20-30) ratings while test and train user bound are (5-10) ratings. 
The test and train bounds stay consistent with the goal of the project, but the SVD user bounds can be modified.
To keep things simpler, this was not part of the optimization process in [bayesian_optimization.ipynb](bayesian_optimization.ipynb) and the values are by no means optimal. 
Also, due to the sheer combinations of the min and max of the bounds, it may be better to optimize them manually.

### Feature_3:

Feature_3 is the prediction from the terms of the trained SVD model for a (user, movie) combination: (overall_average+b1[u]+b2[i]+np.dot(p[u],q[i]))\
where u represents the users index and i represents the movies index to be rated. 

Before this prediction is made, the iterative_svd function trains the SVD model to make predictions with (overall_average+b1[u]+b2[i]+np.dot(p[u],q[i])) by using stochastic gradient descent to change the variables (b1[u], b2[i], q[i], p[u]) in the direction that minimizes the error between an actual rating and (overall_average+b1[u]+b2[i]+np.dot(p[u],q[i])). 

Initial Conditions:\
overall_average: The average of all ratings used to train the SVD model (does not change in training)\
Users factors: p = gen_input.normal(0, .1, (nof_users, n))\
Movie factors: q = gen_input.normal(0, .1, (nof_movies, n))\
User biases: b1 = np.zeros(nof_users)\
Movie biases: b2 = np.zeros(nof_movies)


#### Bayesian Optimization:

The Bayesian Optimization process is critical to the effectiveness of feature_3 in the final model.
This means that tuning the hyperparameters to the iterative_svd function goes a long way.

This is what sparked the creation of the other notebook: [bayesian_optimization.ipynb](bayesian_optimization.ipynb)

The entire point of this notebook is to find the highest performing parameters for:
nof_svd_users, nof_train_users, nof_latent_features, epochs, rt, lr


What do these parameters mean?

nof_svd_users is the number of users that that help train the SVD model but don't have a rating to be predicted by the trained SVD model.

The users themselves are not parameters because they should always be chosen randomly from the pool of SVD users to limit noise.

In the [full_model.ipynb](full_model.ipynb) notebook, the nof_train_users and nof_test_users are always equal and they are the number of users that both help train their respective model but also require predictions for exactly one of their movies. (These simulate the users that the final trained model is designed to make predictions for)

Again, the users themselves are not parameters. Users are randomly sampled each run from their respective user pool (user_to_data_svd, user_to_data_train, or user_to_data_test) which each have 10000 users.

nof_latent_features: nof_factors in the iterative_svd function (used like this):\
q : is a (nof_movies x nof_factors) array\
p : is a (nof_users x nof_factors) array

Epochs: nof cycles of stochastic gradient descent on the entire train list.\
rt: regularization term\
lr: learning rate



## Final Model:

The purpose of the final model (loosely speaking) is how much weight to give to each feature for the optimal prediction.

The idea was that more than one predictor can fill in the short comings of a single model.

After features (1, 2, and 3) for the train and test users and the target train and test ratings are collected, then they are used as input features to build and test a simple linear regression model.

Although feature 3 is overwhelmingly the most critical feature to the model, in testing the presence and absence of features, Feature 1 and Feature 2 were shown have a positive impact on the linear regression model and the best performance was obtained by using all three features.


## Results:

* Gathering accurate and consistent results was a challenging task and is somewhat incomplete.

* The first challenge was finding the hyperparameters that produced the best results for the SVD model. 

* A set of hyperparamters can simply produce a good Root_Mean_Squared_Error(RMSE) by chance, meaning that the random conditions
in testing may contribute highly to its success.

* In order to mitigate this, many tests were done for each iteration of the gp_minimize function.
This means that the same parameter values were tested a large amount of times, each time diversifying the users involved by randomly selecting them from the larger pool. 

* Even with a large amount of tests (160 or 320) for each iteration, the optimization process seemed to inflate the RMSE results.

* This was observed when testing the same parameters for (160 or 320) times in a separate cell. It showed that with these tests, the average RMSE was higher than what was found in the optimization process. In other words, it produced worse results when generalizing to new data.

* Although increasing the number of tests in the Bayesian Optimization process helped reduce the overestimation of the hyperparameters, there was still slight evidence of over estimation. 

* Also, more iterations of the Bayesian Optimization process helps with outputting good parameters, but it also increases the chance of over inflating them and likely required more tests per iteration to produce more realistic results.

* After many tests of the Bayesian Optimization process, I decided to settle on hyperparameters produced by a three hour long process on my machine with the input parameters found in the results file: [results.txt](results.txt)

* The average RMSE results were the best so far and it generalized relatively well, but there was still a discrepancy between the performance in the optimization process and the generalization test. 

* The most important results were the Final Model results from [full_model.ipynb](full_model.ipynb) (combination of all features 1, 2, and 3) using the best hyperparameters found in [bayesian_optimization.ipynb](bayesian_optimization.ipynb)

* There seemed to be reasonable consistency in RMSE when the number of Iterations was 160 after testing multiple seeds to the generator function (10,20,30). Intuitively, when the number of Iterations is increased the less the input seed matters. 

* I left the number of Iterations at 40 in the notebook for user friendly runtimes and again tested three different seeds to the generator function (10,20,30).

* Here is the summary of the error results for these tests: [results.txt](results.txt)

## Challenges:

* Realistically, the users ratings are not always accurate to their preference. This introduces poorly informed decisions in training and testing (Garbage in Garbage out).

* Intuitively, rating predictions to a users requested movie will lose precision when less user provided ratings are entered by the user. The less data that can be used to relate or dissociate users, the less grounded the predictions become. On the other hand, the benefits of training a model that requires less from the user, will only improve the user experience when the model is implemented. Unfortunately, there is a massive tradeoff between effective service and accuracy in model predictions.

* Predictions to a movies rating can be worse when there are a small number of users who rated that same movie.

* Larger initial bounds for the parameters of the Bayesian Optimization function may lead to the output of more effective hyperparameters, but it also magnifies the cost of the already time consuming optimization process. Increasing the number of calls to the optimization function and the number of tests per call has the same effect. This is why dask is used for parallel processing and numba is used as a just-in-time(jit) compiler for the by far most taxing function found in both notebooks: "epoch".


# How to (Install/Run):

* Requirements:
    * Git
    * python3 and pip (my working python version: 3.10.7)
    * Kaggle account and API token
    * 16 GBs of total ram on machine to be safe (less is workable depending on the concurrent tasks running on machine).

1. Clone the repository with git.
2. With python3 and pip:
    1. Create a python virtual env in the main project directory. (my working python version: 3.10.7)
    2. Activate the virtual environment
    3. Install the following packages to the virtual env using pip: numpy==1.23.5, jupyter, opendatasets, pandas, spacy, ordered-set,
scikit-learn, numba, dask, scikit-optimize, dask\[distributed\]


3. Open the [full_model.ipynb](full_model.ipynb) file in the main project directory and connect to the kernel of the python virtual environment you created.

4. Run the [full_model.ipynb](full_model.ipynb) notebook top to bottom.

5. Kaggle Requirements:

    * Upon running the first cell, the user will be asked for their username and key which can be found in a fresh api token from kaggle.com.

    * Instructions to get api token to authenticate the data request(Note: kaggle account required):
        1. Sign into kaggle.
        2. Go to the 'Account' tab of your user profile and select 'Create New Token'.
        3. This will trigger the download of kaggle.json, a file containing your API credentials.

    * After inputting credentials, the files from the-movies-dataset will start downloading in a new folder called "the-movies-dataset".

    * If the files have already been downloaded and stored in the "the-movies-dataset" folder, than this cell does nothing and requires no credentials.

6. Lastly, wait for the rest of the cells to finish and observe the results printed for each cell.

## Tips for the notebooks:

* Currently, an excessive amount of data is randomly selected from the full dataset of applicable users (10000 of each users type) to make random sampling from these user types diverse. In cells(1-4) this data is written to the "constructed_data.csv" file in the order of SVD, train, and test users.

* When cells(1-4) have been run to completion, the data persists in the form of "constructed_data.csv" so that only cells(5-8) needs to be rerun for training and testing to save time when testing new parameters. 

* Don't run the [bayesian_optimization.ipynb](bayesian_optimization.ipynb) unless you have ample time to wait and sufficient total memory on your machine (16 GBs). 
It is only included for informative purposes and does not need to be run again. 
However, it could be useful to try larger parameter bounds and some different inputs to get better results. 










