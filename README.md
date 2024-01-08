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

## Data source

* The raw data collected for this program/model is soley from: https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset?select=movies_metadata.csv
* It is too large to fit in the repository and reqires user credentials to download. (see the How to Install/Run section).


# Process: 


## Overview

There are three input features to he model
Each of these features standon their own as predicitons the target movies rating...

The model takes features_1 2 and 3 as inputs the model for traning and testing...

## Content Based Filtering:

### Feature_1:

Feature_1 is a non-weighted average of all the ratings for a user besides the target movie. This feature alone will not be the most precise since it does not value anything about the movie in question and is independent of what other users think about the movie. This feature works because target movie rating is inevitably linked to how high a user rates movies on average.

### Feature_2:

Feature_2 is a weighted average of the all the users ratings besides the target movie. The weighting for each rated movie is based on how similair the target movie is to the rated movies. The similairty is determined by cossine simialirty of normalized tf-idf vectors for word counts of a rated movie and a target movie. 


## Collaborative filtering:

### Train Operation:
* #### svd_full:

    The matrix factorization is created with the svd function on the normalized ratings. Then each factor is truncated to n (currently 10) "components". Then the factors are multiplied together to make a new array with the same dimension as the (normalized ratings) but where the target ratings once were normalized to 0, new normalized predictions takes its place. Then this array is scaled back into an array of ratings from (1-5) giving a real and more reasonable rating prediction of the target movie than the movies average rating. These are the outputs of the first call of the svd_full function "svd_out_train". The predicted rating for the train users target movies are found by acessing the row for the train user in question and the column corresponding to the saved target movie index for the user. These predicted ratings fed into feature_3 are used to train the model.


### Test Operation (similair to Train Operation):
* Data is organized into a ((user) x (movies ratings of corresponding user)) list

* The users that are included are train_users and test users (in that order).

* all_movies_in_order is an ordered list of movie ids ordered by there first occurance in the combined list of train and test users (in that order). 

* (movies ratings of corresponding user) is a list of ratings for a user that follow the order of all_movies_in_order.

* For each movie id in the order of all_movies_in_order, if the user has a rating for that movie id and that movie id is not the target movie id for that user, than set the value at the corresponding index of (movies ratings of corresponding user) with the users rating, otherwise fill it in with the movies average rating for all train and test users (loosely speaking)
 
* Each movie rating in every user row is normalized by subtracting the movies average rating for all train and test users users.

* Then use this as one of the inputs to svd_full function below.

* #### svd_full:
    The matrix factorization is created with the svd function on the normalized ratings. Then each factor is truncated to n (currently 15) "components". Then the factors are multiplied together to make a new array with the same dimension as the (normalized ratings) but where the target ratings once were normalized to 0, new normalized predictions takes its place. Then this array is scaled back into an array of ratings from (1-5) giving a real and more reasonable rating prediction of the target movie than the movies average rating. These are the outputs of the second call of the svd_full function "svd_out_full". The predicted rating for the test users target movies are founds by acessing the row for the test user in question (test users are at the end of the svd_out_full list) and the column correspong to the saved target movie index for the user. These predicted ratings fed into feature_3 are used to validate the model that was trained in the train operation. 

* For more details about the process, see the notebook (complete_11_03_2023.ipynb) and follow the comments.



## Final Model/Cell 8:

* After features (1, 2, and 3) for the test and train users are collected in (cell 7), then they are used to build a model.

* It is important to note that each feature can function as a predictor to the target movies rating on their own.

* The purpose of the model (loosley speaking) is how much weight to give to each feature for the optimal prediction.

* Using more than one predictor can fill in the short comings of a single model.

* From testing it was shown that the best combination of features are feature_1 and feature_3.

* #### Question: Isn't it optimal to use all three features?  Answer: No!
    Since feature 1 and feature 2 are so similair in nature, using both, only seems to complicate the optimization algorithm. This conclusion was gathered when acknowledging the decrease in performance when tested.

* This logic doesn't follow for the combination of feature_1 and feature_3, since they are completley different angles of prediciton.

* The fact that feature_1 was found to be more predicting than feature_2, was a suprising hearistic.

* This could mean that movies that have similair word counts in the metadata don't necessarily mean that the user will rate them similairly and perhaps the opposite behavior is more common.

* There could be other combinations of text sources or more explicit categories and datatypes besides text that could replace feature_2 and make up the shortcomings of the predictor.


# Results:

* All the relevant tests can be observed in the results.txt file.
LOOK: a hierachy of shared variables can be established

* The parameters that stay the same for every test are:

    1. Number of train users: 5000, Number of test users: 1000
    2. Test user rating bounds: 5-10 
    3. 100 models tested with the same input. The output is the average r2 score for all tests to reduce random model error.


## Feature 1 and Feature 3:

* The best feature combination (feature 1 and feature 3) are tested with different train user bounds.

* There are three train rating bounds for the train users that are tested:
11-31, 30-50, and 50-70.

* For each of these rating bounds, different combinations of n used with the svd_full functions were tested with linear regression.

* Once the n values leading to the aproximate best average r2 score for linear rergession were found for each of the train bounds, the results were recorded. 

---

* Standard sklearn mlp models were also tested on feature 1 and feature 3 with the only extra parameter being layers.

* The approximate best mlp models for the corresponding train rating bounds were found by using the best combination of n values for the best linear regression model with matching rating bounds.

* For each of the three (rating bounds and corresponding best n values) three mlp models are tested to show the aproximate best mlp layer parameters.

* This is the number of layer combinations that is neither too small nor too large.

* For 30-50, and 50-70 train user bounds, the best performing model happened to be the best (middle range layered) mlp model and for 11-31 train user bounds the best performing model was linear regression. (See results.txt)


* When comparing the linear regression model and the three other mlp models for each (rating bounds and corresposning best n values) the observations show that the average r2 scores results are very similair,
often only differening in the thousandths place.


* However, there is more noticable differences in performance when comparing tests with different (rating bounds and corresponding best n values). These differences are often in the hundredths place. 

* The tests above account for 12 tests shown in results. 

* There are 4 unique models for each of 3 (rating bounds and corresposning best n values).

* The absolute best r2 performance which can be observed in results.txt is 0.27639324087457673 with the following parameters: 
    * feature 1 and feature 3
    * train user rating bounds: 30-50
    * n = 10, 15 for svd train and full
    * Model type: mlp, layers = (10,10,5)
    * no rounding

* There is a slight shortcut used here to reduce the testing for mlp models for different values of n.

* One could potentially state that the optimal n values for linear regression are not the optimal values for mlp models with the same (rating bounds and corresposning best n values).

* However, judging the small difference between models with the same (rating bounds and corresposning best n values), if there were mlp models with different optimal values of n than the linear regression model with the same (rating bounds and corresponding best n values) it would likely lead to very little perfromance gain.


## Feature 2 and Feature 3:

* Since it was clear that the performance of (feature 2 and feature 3) was worse than (feature 1 and feature 3) after a few tests, only the best performing (rating bounds and corresposning best n values) for feature 1 and feature 3 were used to test feature 2 and feature 3 knowing that even the most optimaize tweaks to the paramters would not lead to feature 2 and feature 3 outperforming feature 1 and feature 3. 


* The reason feature 2 and feature 3 are part of the results is to show the difference between using only the genre column vs all the relevant columns.

* Linear regression was tested with the variables forced above for (feature 2 and feature 3), for only the genres column and then again for all the columns saved in the constructed_data.csv.

* From this test, it was clear that utilizing all the columns was superior to only using genres.

* The full corpus parameter was also tested with mlp models using the same technique in the
feature 1 and feature 3 section. Essentially, sandwitching the model with the close to best number of layers for performance, between a worse model with a lower number of model combinations and a worse model with a higher number of layer combinations 

* This medium layer combination was the highest performing parameters for feature 2 and feature 3.


# How to install/run:

## Automated Way (with docker):

* Requirements:
    * Git
    * Docker
    * Kaggle account and API token

1. Clone the repository with git.

2. Navigate to the main project directory.

3. Start the docker daemon.

4. Build docker image using the provided Dockerfile using this shell command:

    ```shell
    docker build -t movie_rec_image .
    ```

5. Using the same shell, create a contianer from the image while binding the port of the listening jupyter server (8888) to port 8888 of the host machine: 

    ```shell
    docker run -p 8888:8888 movie_rec_image 
    ```

6. Choose one of the following methods to utilize the python kernel of the jupyter server (there are other methods that can be found online).

    Browser method: 

    1. Follow the url that is found in the shells console ouput where you created the container. It is the second url after "Jupyter Server \*.\*.\* is running at:" and starts with "http://127.0.0.1:8888". This should open a webpage with the current working directory set in the dockerfile with the complete_11_03_2023.ipynb file.
    
    2. Open the complete_11_03_2023.ipynb file in the browser notebook and run all the cells.

    Vscode method: 

    1. Open the complete_11_03_2023.ipynb file in the main project directory in vscode.

    2. Follow these step to connect to the jupyter servers python kernel:
        1. Select kernel in top right.
        2. Select another kernel.
        3. Select existing jupyter server.
        4. Copy and paste the jupyter server access token that is found in the console. 
        It is the second url after "Jupyter Server \*.\*.\* is running at:" and starts with "http://127.0.0.1:8888".
        5. Create a server display name.
        6. Select the Python 3 (ipykernel).

    3. Then run all the cells in the notebook.

7. Kaggle Requirments:

    * Upon running the first cell for the first time in the containers lifetime, the user will be asked for their username and key which can be found in a fresh api token from kaggle.

    * Instructions to get api token to authenticate the data request(Note: kaggle account required):
        1. Sign into kaggle.
        2. Go to the 'Account' tab of your user profile and select 'Create New Token'. 
        3. This will trigger the download of kaggle.json, a file containing your API credentials.

    * If the files have already been downloaded and stored in the "the-movies-dataset" folder, than this cell does nothing and requires no credentials.


8. Lastly, wait for the rest of the cells to finish and observe the results printed for each cell.



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


# Notes for the notebook:

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


Look: https://choosealicense.com/
https://choosealicense.com/no-permission/

LOOK: NO more than two code cells per markdown cell???
https://www.dataquest.io/blog/how-to-share-data-science-portfolio/

LOOK:
How to write good notebooks:
https://www.youtube.com/watch?v=tVhh46f6_Dk








