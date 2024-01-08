# Goal:

The full_model.ipynb notebook builds a model that could be used to predict a users rating for an unwatched movie given that they submit a few ratings for movies they have watched.

This is an invaluable goal, because the model can give users an idea about how satisfied they will be with any movie rather then simply reccomending the best fit movies to the user. 

I also wanted the model inputs to not be so demanding for a client user. The users must only provide 4-9 ratings for movies they watched as well as the single movie they desire a rating for.

In theory the prediction uses a combiantion of the users data along with potentially massive amounts of users rating data and movie data stored in a database.


[Click here to view the Jupyter Notebook](full_model.ipynb)

## Clarification:

The process should not be confused with predicting a critics score or some metascore from a review website. It predicts user scores. 

The model could benfit if the metadata was someway integrated in a column by column basis. However, these details were not part of the focus of the model.

The only way the movies metadata is used in the model, is with term frequencies from the combined corpus of relevant column attributes.


## Challenges:

* Many times, the users ratings are not accurate to their preference. This can introduce alot of noise. Garbage in garbage out.

* Intuitively, rating predictions to a users requested movie can be worse if the user only inputs a small number of rated movies because there is less data that can be used to compare to other users and thereforre less potential to accuractely rate movies based on this type of similairity. However, it is best to train and test a model where test users enter a small number of ratings because it is easier for the user in a front-end implementation of this model. There is a massive tradeoff between user friendly service and accuracy.

* Predictions to a movies rating can be worse when there are a small number of users who rated that same movie

* The iterative_svd function discussed later has hyperparameters that need to be optimized. This is the pupose of the bayesian_optimization.ipynb notebook. 
With larger bounds comes better performance but higher computation time. This is why dask and numba are used to speed up computations.

## Data source

* The raw data collected for this program/model is soley from: https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset?select=movies_metadata.csv
* It is too large to fit in the repository and reqires user credentials to download. (see the How to Install/Run section).


# Process: 


## Overview

There are three input features to the final model (features 1 2 and 3)

Each of these features stand on their own as predicitons the target movies rating but they each have a different method of doing so.

This is why there combination in a linear model is effecttive even if the benefits are marginal comapared to the most effective feature (feature_3).


## Content Based Filtering:

### Feature_1:

Feature_1 is a non-weighted average of all the ratings for a user besides the target movie. This feature alone will not be the most precise since it does not value anything about the movie in question and is independent of what other users think about the movie. This feature works because target movie rating is inevitably linked to how high a user rates movies on average.

### Feature_2:

Feature_2 is a weighted average of the all the users ratings besides the target movie. The weighting for each rated movie is based on how similair the target movie is to the rated movies. The similairty is determined by cossine simialirty of normalized tf-idf vectors for word counts of a rated movie and a target movie. 


## Collaborative filtering:


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

The baysian optmization process is critical to the effectiveness of the feature 3 in the final model.
This means that tuning the hyperparameters to the iterative svd funciton goes a long way.

This is what sparked the creation of the other notebook: bayesian_optimization.ipynb

The entire point of this notebook is to find the highest perfroming parameters for:
nof_svd_users, nof_train_users, nof_latent_features, epochs, rt, lr


What do these all mean?:

nof_svd_users is the number of users that that help train the iterative svd function but dont have a rating to be predicted by the trained svd.
The users themselves are not parameters becasue they should always be chosen randomly 

nof_train_users is the number of users that both help train the model but also require prediction for exactly one of their movies.
(These emulate the users that the model is designed for)
again the users themselves are not parameters becasue they should always be chosen randomly 

nof_train users is a number that is used for both the number of train and test users in the full_model.ipynb notebook


Question: do i need to explain all the variables???



## Final Model:


* It is important to note that each feature can function as a predictor to the target movies rating on their own.

* The purpose of the model (loosley speaking) is how much weight to give to each feature for the optimal prediction.

* The idea was that more than one predictor can fill in the short comings of a single model.

* After features (1, 2, and 3) for the train and test users and the target train and test ratings are collected then they are used to build a simple linear model.

* Although feature 3 is overwelmingly the most critical feature to the model, with testing the prescence and abscence of features. Feature 1 and feature 2 were shown have a positive impact on the linear regression model.


# How to install/run:

## Manual Way (no docker):

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


# Notes for the notebooks:

* For tweaking and testing, it is important to note that there are two major sections of the notebook.

* (cell 1 - cell 4) is mainly for formatting and cleaning data before building the model. It saves the data in the form of a csv file called "constructed_data.csv".

* (cell 5 - cell 8) are for transforming the data in "constructed_data.csv" to build a model.
If the pykernel were restarted than the data in the form of "constructed_data.csv" persists so that only (cell 5 - cell 8) 
needs to be rerun. 

* Imagine running the (cell 1 - cell 4) on a excessive amount of data. 

* This will take along time.
However, once this is run it will take no time to select a smaller subset of that data to build the model. This is part of the functionality of cell 6.

* Then after creating the model, the users decide they need more data.

* All the user needs to do is make some tweaks to cell 6 where a subset of the larger set is selected instead or wasting time runing (cell 1 - cell 4)
again. 

* There are still parameters set in (cell 1 - cell 4), so those variables take extra time to tweak and test compared to varables in (cell 5 - cell 8).

* Don't run the bayesian_optimization.ipynb unless you have ample time and memory space on your machine. It is only included for informative purposes and does not need to be run again.

* For both notebooks need to change 


Look: https://choosealicense.com/
https://choosealicense.com/no-permission/

LOOK: NO more than two code cells per markdown cell???
https://www.dataquest.io/blog/how-to-share-data-science-portfolio/

LOOK:
How to write good notebooks:
https://www.youtube.com/watch?v=tVhh46f6_Dk








