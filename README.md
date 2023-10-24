Goal:

The goal of the program is building a model to predict what a new user would rate a particular movie based on their rating to other movies and the movie ratings of similiar users

In other words, the model attempts to predict what the target user would score movies as though they had already been watched.

In practice this is valuable because it gives a precise value to unwatched movies so the user knows a great deal about how satisfied they will be with the movie
(of course there is error)

There are alot of challenges with this task, including:
- Many times the users ratings are not accuracte to their preference (there is weird unexplained variance)
- What is the definition of similair movies? (what concrete data can we use to test simlairity)
- predictions to a movie rating can be worse if the user who rated it has a small number of rated movies
- predictions to a movies rating can be worse when there are a small number of users who rated that same movie

functionality notes:
- this program has the ability to choose users with a specific number of ratings for test and train users
- the default program focuses on test users with 5-10 ratings and train users with 50-75 rating
- the point with keeping the number of test users low is to test how accurate predictions can be made...
- for a potential app that could use this model to guess users ratings to movies 
- in this case, the user would be more content to enter a small number of their own ratings than a large number of their own ratings
- but ease of use comes at a high cost to model performance
- for the case of the number of train users, a higher number of ratings should lead to better performance at the cost of extra runtime
- this means that the accuracy scores of the current configuration are not the highest that this system can perform

Question about this: should the train and test users be tested with more required number of ratings than the current amount to test the models
potential???


clarifications:

The process should not be confused with predicting something of the nature of a critics score or some metascore from a review website
It is based on user preference rather than a prediction based on pure production value that is generally applied to make good movies
The data used is based off random users and the movie rating predictions are for random users (not necessarily critics)

Additionally, The process should not be confused with simply picking movies that are good fit compared to the users movie preference. Instead it seeks to produce useful rating predictions for every user-movie combination even movies that the user would hate.



Process: 

Content based filtering:


The first feature, feature_1 is simply a non-weighted average of all the ratings for a user besides the the target movie
This is an effective feature because it reveals how high a user rates movies on average
this feature alone will not be the most precise since it does not value anything about the movie in question and is independent of what other users think about the movie
The logic is simply that the target movie rating is related to how high a user rates on average


In this notebook the answer to the question, how are movies similair? is answered with the notion of similair text based metadata
This is the process behind feature_2, another content based predictor

How is this data used to define the notion of similair movies and how can it be a potential asset:

- the constrcutedData.csv is built from the source data
- this includes all the relevant data columns from every .csv in the entire movies data set that might produce helpful text data
- every line in the constrcutedData.csv has a user id, a movie id and a number of columns that hold valuable text data of the movie the user watched


- for each movie the user watched, certain columns of text data are selected and combined to create an ordered set of words
- The ordered set of words is unique to a user id and is formed from the words in the columns of all the movies the user rated

- then, for the current user, a random movie is chosen to be the target movies rating
- if teh user is a train user it is use to train the model
- if the user is a test user then it is used to evaluate the model

- then for each movie the user watched, the words found in the corpus of the relavent columns for that movie are...
- count vectorized in the order of the ordered set of words 
- if a word is not present in the movies corpus, the value in the correpsonding index in the vector becomes 0
- else the value at the corresponding index of the count vector is equal to the number of times the words comes up in the particular movies corpus

- once a vector is created for each movie the user watched, including the target movie...
- then the rating of the target movie can be predicted using a function of the cossine similarity between the word count vectors of...
- the target movie and the other movies the user watched 
- the function also uses the ratings of the non-target movies 
- this function creates feature_2 which is (like the other features) a guess to the rating of the target movies of all the users using this method


- like feature_1, feature_2 is also independent of what other users think of the movie



Collaborative filtering:

Train operation:
    -Data is organized into a ((user) x (movies ratings of corresponding user)) list
    -The users that are included are train_user
    -The movies ratings that are part of (movies ratings of corresponding user) are all movies that are present in the train set
    -movies that are not rated by the user are given an average rating for that movie equal to...
    [mean rating for the correspnding movie for every other user who rated it in the train data] (loosely speaking)
    -Then the data is normalized by subtracting the mean for each entry which is again...
    [mean rating for the correspnding movie for other every user who rated it in the train data] (loosely speaking)


    svd:
    [-The matrix factorization is created with the svd function on the normalized ratings
    -Then each factor is truncated to 20 "componenets"
    -Then the factors are multiplied together to make a new array with the same dimesion as the (normalized ratings)...
    but points with a normalized rating of zero now have a more informed normalized rating based on the similairy between other users
    -therefore the target ratings can be predicted

    -then this array is scaled back into an array of ratings from (1-5) and the once normalized ratings...
    have in place of it, a reasonable rating prediction of the target movie 

    -The predicted rating for the target movies for every user is found by acessing the
    -corresponding index location of the target movie for each user]

    -These predicted ratings fed into feature_3 are used to train the model 


Test operation (similair to train operation):
    -Data is organized into a ((user) x (movies ratings of corresponding user)) list
    -The users that are included are train_users and test users (note: the test users come after the train users in the list)
    -The movies ratings that are part of (movies ratings of corresponding user) are all movies that are present in the train set or the test set

    -movies that are not rated by the user are given an average rating for that movie equal to...
    [mean rating for the corresponding movie for every other user who rated it in the train data and test data] (loosely speaking)
    -Then the data is normalized by subtracting the mean for each entry which is again...
    [mean rating for the corresponding movie for every other user who rated it in the train data and test data] (loosely speaking)

    same svd idea:
    [-The matrix factorization is created with the svd function on the normalized ratings
    -Then each factor is truncated to 20 "componenets"
    -Then the factors are multiplied together to make a new array with the same dimesion as the (normalized ratings)...
    but points with a normalized rating of zero now have a more informed normalized rating based on the similairy between other users
    -therefore the target ratings can be predicted

    -then this array is scaled back into an array of ratings from (1-5) and the once normalized ratings...
    have in place of it, a reasonable rating prediction of the target movie 

    -The predicted rating for the target movies for every user is found by acessing the
    -corresponding index location of the target movie for each user]

    -These predicted ratings fed into feature_3 are used to validate the model that was trained in the train operation


Note: There are alot more details to this left out for a simpler overview
For more details see notebook (complete_02_08_2023.ipynb) and follow the comments

After features (1, 2, and 3) for the test and train users are collected,
then they are used to build a model

Both the basic linear regression model and the strongest mlp regressor model were tested
and the best model was found to be a basic linear regression model
the order of featurs importance to all the tested models was feature_3 , feature_1, and feature_2
and the best combination of features is feature_1 and feature_3


the suprising hearistic, was that feature_1 was weighed higher than feature 2
in a sense this can be explained because they both have the same orgin (mean of users ratings)
But feature_2 was weighted and feature_1 was not weighted


-a simple conclusion is that the collaborative filtering method was the strongest predictor and the general average of the users ratings outperformed the function using cossine similarity

-This could mean that movies that have similair word counts in the metadata don't necessarily mean that the user will rate them similairly
-There could be other combinations of text sources or more explicit categories and datatypes besides text that could produce more effective predictions



-Questions !!!
-would it be smart to try to guess users rating when they have a small number of ratings???
-but still using data for users with alot more ratings???
-this can be theoreticaly be explained but not necesarliy acted upon!!!

-is the movie rating for the movie to predict averaged out (yes)
-is the mean the complete average from train and test data for the svd on the full dataset (yes)
-are some movies listed twice in the ordered complete movie set (no: the sets are combined)

-how to remove the current user from this average???
[mean rating for the correspnding movie for every user who rated it in the train data]
answer: the user is already removed

-Is the rating of the target movies from other users included in this average???
no the rating does not include target ratings and if the the movie was only a traget movie then the overall average is used



stats: 
what were the scores for different inputs???

extras:
need to make sure that it is known that the version of python is 3.10.7


How to install/run:

Quick Way(with docker):

    requirements:
        -Git
        -Dockerdesktop
        -Sufficent memory
        -kaggle account and API token

    clone the repository
    navigate to the main project directory
    build docker image using the provided Dockerfile: docker build -t movie_rec_image .
    run the created docker image: docker run -p 8888:8888 movie_rec_image

    choose one of the following methods:
    Note: there are other methods to connect to a ipython kernel of a jupyter server

        browser method: 
        [follow the url that is found in the console ouput where you created the container
        it is the second url after "Jupyter Server 2.7.3 is running at:"" and starts with http://127.0.0.1:8888 
        this should open a page with the current working directory set in the dockerfile
        open the complete_02_08_2023.ipynb file in the browser notebook and run all the cells]

        vscode method: 
        [open the complete_02_08_2023.ipynb file in the main project directory
        select kernel in top right/select another kernel/existing jupyter server
        copy and paste the jupyter server access token that is found in the console
        it is the second url after "Jupyter Server 2.7.3 is running at:"" and starts with http://127.0.0.1:8888"
        then run all the cells in the notebook]

    kaggle requirments:
    [upon running the first cell for the first time, it will ask for credentials
    These credentials is a method of authentification to access the kaggle data
    You will need a kaggle account
    Once logged in to your account, you can generate an API token in your settings on the kaggle website
    Download the token and then enter the username and key from the API token one at a time for the two pop ups from the first cell]

    then wait for cells to finish and observe the results






Explicit Way(no docker):

    requirements:
        -Git
        -Sufficent memory
        -python3 and pip (my working python version: 3.10.7)
        -kaggle account and API token

    clone the repository

    with python and pip:
    create a python virtual env in the main project directory:
    install the following packages to the virtual env:
    opendatasets, pandas, numpy, scikit-learn, 
    scipy, ordered-set, gensim, nltk, jupyter
    activate the virtual environment

    open the complete_02_08_2023.ipynb file and connect to the kernel of the above python virtual environment
    run the complete_02_08_2023.ipynb notebook

    kaggle requirments (same as above):
    [upon running the first cell for the first time, it will ask for credentials
    These credentials is a method of authentification to access the kaggle data
    You will need a kaggle account
    Once logged in to your account, you can generate an API token in your settings on the kaggle website
    Download the token and then enter the username and key from the API token one at a time for the two pop ups from the first cell]

    then wait for cells to finish and observe the results

    computation can take some time (estimation)



About the notebook:
-How to skip cells to save runtime:

results and custom inputs:


Question: should constructedData be included in git repo if it is small enough???
