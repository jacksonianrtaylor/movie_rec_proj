Goal:

The goal of the program is building a model to predict what a new user would rate a particular movie based on their rating to other movies and the movie ratings of similiar users.

In other words, the model attempts to predict what the target user would score movies as though they had already been watched.

In practice this is valuable because it gives a precise value to unwatched movies so the user has a reasonable idea about how satisfied they will be with the movie.




There are alot of challenges with this task, including:
- Many times the users ratings are not accuracte to their preference (there is weird unexplained error).
- What is the definition of similair movies? (what concrete data can we use to test simlairity).
- Predictions to a movie rating for a user can be worse if the user only inputs a small number of rated movies but...

- It is best to train and test a model where test users have a small number of ratings because it is more feasible...
  in a front-end implementation of this model. 
  (Think about being a user who is prompted to enter some ratings for movies they saw to predict how much they would like a movie they didn;t watch) (they wouldn't want to feel like they are watsing time entering an excessive number of movie ratings)

- predictions to a movies rating can be worse when there are a small number of users who rated that same movie


clarifications:

The process should not be confused with predicting something of the nature of a critics score or some metascore from a review website
It is based on user preference rather than a prediction based on pure production value that is generally applied to make good movies
The data used is based off random users and the movie rating predictions are for random users (not necessarily critics)

Additionally, The process should not be confused with simply picking movies that are good fit compared to the users movie preference. Instead it seeks to produce useful rating predictions for every user-movie combination even movies that the user would hate.


functionality notes:
- this program has the ability to choose users with a specific number of ratings for test and train users
- the default program focuses on test users with 5-10 ratings and train users with 30-50 ratings
- the point with keeping the number of test users low is to test how accurate predictions can be made...
- for a potential app that could use this model to guess users ratings to movies 
- in this case, the user would be more content to enter a small number of their own ratings than a large number of their own ratings
- but ease of use comes at a high cost to model performance


- For the case of the number of train users, many tests of the notebook have shown that there is some happy medium for the number of train users...
  when the number of test users stays constant at 5-10 users
- the best perfoming number of train user that was chosen tobe tested was the current value in the program (30-50)
- this performed better than 11-31 and 50-70 users 
- It is likley that this means that the accuracy scores of the current configuration are not the highest that this system can perform




Process: 

Content based filtering:

feature_1:
    The first feature, feature_1 is simply a non-weighted average of all the ratings for a user besides the target movie.
    This is an effective feature because it reveals how high a user rates movies on average.
    This feature alone will not be the most precise since it does not value anything about the movie in question...
    and is independent of what other users think about the movie.
    The feature works because target movie rating is inevitably linked to how high a user rates movies on average

feature_2:

In this notebook the answer to the question, how are movies similair? is answered with the notion of similair text based metadata.
This is the process behind feature_2, another content based predictor.

How is this data used to define the notion of similair movies and how can it be a potential asset?:

The constructed_data.csv is built from the source data.

Every line in constructed_data.csv has a user, a movie id, a rating, as well as all the relevant movie data columns...
for the correponding movie, from every csv in the entire movie data set that might produce helpful text data.
(in the current program, genres is the only column used)
(Note: see the notebook (cell 7) for changing the current corpus from genres to all columns)
(This will increase runtime)


For each movie the user rated, certain columns of text data (currently only genres) are selected from the movie and combined...
to create an ordered set of words.

Also, for the current user, a random movie is chosen to be the target movies rating

If the user is a train user, this movies rating is used as the actual to train the model
If the user is a test user, this movies rating is used as the actual to evaluate the model
If this is real world application of the model, then the rating is unknown.


After the ordered set of words is created for a user, the words found in the corpus of the relavent columns for that movie are...
count vectorized in the order of the ordered set of words. 
The value at the corresponding index of the count vector is equal to the number of times the words comes up in the particular movies corpus.

Once a word count vector is created for each movie the user watched (including the target movie),
the rating of the target movie can be predicted using a function of the cossine similarity between the transformed word count vectors of...
the target movie and the other movies the user watched as well as the non-target movies ratings.

This function creates a single entry of feature_2.

What are the transformed word count vectors?
The transformed word count vectors are normalized tf-idf vectors.
This places value on terms that are un-common in alot of documents,...
While still placing value on how common they are in the document at hand.
This leads to a more powerful quantifier for cossine similairity between documents.

Like feature_1, feature_2 is also independent of what other users think of the movie.



Collaborative filtering:

Train operation:
    -Data is organized into a ((user) x (movies ratings of corresponding user)) list
    -The users that are included are train_users
    -The movies ratings that are part of (movies ratings of corresponding user) are all movies that are present in the train set
    
    -movies that are not rated by the user are given an average rating for that movie equal to...
    [mean rating for the correspnding movie for every other user who rated it in the train data] (loosely speaking)
    -Then the data is normalized by subtracting the mean for each entry which is again...
    [mean rating for the correspnding movie for other every user who rated it in the train data] (loosely speaking)


    svd:
        The matrix factorization is created with the svd function on the normalized ratings.
        Then each factor is truncated to n (currently 10) "components".
        Then the factors are multiplied together to make a new array with the same dimesion as the (normalized ratings)...
        but where the target ratings once were normalized to 0, new normalized predictions takes its place.
        Then this array is scaled back into an array of ratings from (1-5)...
        giving a real and more reasonable rating prediction of the target movie than the movies averge rating.


    The predicted rating for the target movies for every user is found by acessing the
    corresponding index location of the target movie for each user

    These predicted ratings fed into feature_3 are used to train the model 


Test operation (similair to train operation):
    -Data is organized into a ((user) x (movies ratings of corresponding user)) list
    -The users that are included are train_users and test users (note: the test users come after the train users in the list)
    -The movies ratings that are part of (movies ratings of corresponding user) are all movies that are present in the train set or the test set

    -movies that are not rated by the user are given an average rating for that movie equal to...
    [mean rating for the corresponding movie for every other user who rated it in the train data and test data] (loosely speaking)
    -Then the data is normalized by subtracting the mean for each entry which is again...
    [mean rating for the corresponding movie for every other user who rated it in the train data and test data] (loosely speaking)

    same svd idea:
        The matrix factorization is created with the svd function on the normalized ratings.
        Then each factor is truncated to n (currently 15) "components".
        Then the factors are multiplied together to make a new array with the same dimesion as the (normalized ratings)...
        but where the target ratings once were normalized to 0, new normalized predictions takes its place.
        Then this array is scaled back into an array of ratings from (1-5)...
        giving a real and more reasonable rating prediction of the target movie than the movies averge rating.


    The predicted rating for the target movies for every user is found by acessing the
    corresponding index location of the target movie for each user

    These predicted ratings fed into feature_3 are used to validate the model that was trained in the train operation


Note: There are alot more details to this left out for a simpler overview.
For more details see the notebook (complete_11_03_2023.ipynb) and follow the comments.



Regarding cell 8 of the notebook where features are combined into the final model:
    After features (1, 2, and 3) for the test and train users are collected in cell 7, then they are used to build a model.

    It is important to note that each feature can function as a predictor to the target movies rating on their own.
    The purpose of the model is loosley speaking, how much weight to give to each feature for the optimal prediction.

    Using more than one predictor can fill in the short comings of a single model.

    From testing it was shown that the best combination of features are feature_1 and feature_3.
    Question: Isn't it optimal to user all three features??
    Answer: NO. Since feature 1 and feature 2 are so similair in nature, using both, only seems to complicate the optimization algorithm,
    when acknowledging the decrease in performance when tested.

    Feature_1 is more predicting than feature_2 so it should replace it. 
    This logic doesn't follow for the combination of feature_1 and feature_3, since they are completley different angles of prediciton.

    Feature_1 being a stronger feature than feature 2 is a suprising hearistic.

    This could mean that movies that have similair word counts in the metadata don't necessarily mean that the user will rate them similairly.

    There could be other combinations of text sources or more explicit categories and datatypes besides text that could make up the short comings..
    of feature_2.






Stats: 
what were the scores for different inputs???



How to install/run:

Automated Way (with docker):

    requirements:
        -Git
        -Dockerdesktop
        -Sufficent memory
        -kaggle account and API token

    1. Clone the repository with git.
    2. Navigate to the main project directory.
    3. Build docker image using the provided Dockerfile using this cli command: "docker build -t movie_rec_image ."
    4. Using the same cli, create a contianer from the image...
       while binding the port of the listening jupyter server to port 8888 of the host machine: "docker run -p 8888:8888 movie_rec_image"

    5. Choose one of the following methods to use the kernel of the jupyter server (there are other methods online):

        Browser ethod: 
            Follow the url that is found in the console ouput where you created the container.
            It is the second url after "Jupyter Server *.*.* is running at:" and starts with "http://127.0.0.1:8888".
            This should open a page with the current working directory set in the dockerfile.
            Open the complete_11_03_2023.ipynb file in the browser notebook and run all the cells.

        Vscode method: 
            Open the complete_11_03_2023.ipynb file in the main project directory in vscode.
            Follow these step to connect to the servers python kernel:
                1. Select kernel in top right
                2. Select another kernel 
                3. Select existing jupyter server
                4. Copy and paste the jupyter server access token that is found in the console. 
                It is the second url after "Jupyter Server *.*.* is running at:" and starts with "http://127.0.0.1:8888".
                5. Create a server display name
                6. Select the Python 3 (ipykernel) 
            Then run all the cells in the notebook.

    7. kaggle requirments:
        Upon running the first cell for the first time in the containers lifetime,...
        the user will be asked for their username and key which can be found in a fresh api token from kaggle.

        Instructions to get api token to authenticate the data request (Note: kaggle account required):
        1. Sign into kaggle.
        2. Go to the 'Account' tab of your user profile and select 'Create New Token'. 
        3. This will trigger the download of kaggle.json, a file containing your API credentials.

        If the folder has been created in the containers lifetime and the files are already in that folder,...
        than this cell does nothing and requires no credentials.


    8. Lastly, wait for the rest of the cells to finish and observe the results printed for each cell.




Manual Way (no docker):

    requirements:
        -Git
        -python3 and pip (my working python version: 3.10.7)
        -Sufficent memory
        -kaggle account and API token

    1. Clone the repository with git.

    2. With python and pip:
        1. Create a python virtual env in the main project directory. (my working python version: 3.10.7)
        2. Install the following packages to the virtual env: opendatasets, pandas, numpy, scikit-learn, scipy, ordered-set, gensim, nltk, jupyter
        5. Activate the virtual environment

    3. Open the complete_11_03_2023.ipynb file and connect to the kernel of the above python virtual environment

    4. Run the complete_11_03_2023.ipynb notebook

    kaggle requirments (same as above):
        Upon running the first cell for the first time in the containers lifetime,...
        the user will be asked for their username and key which can be found in a fresh api token from kaggle.

        Instructions to get api token to authenticate the data request (Note: kaggle account required):
        1. Sign into kaggle.
        2. Go to the 'Account' tab of your user profile and select 'Create New Token'. 
        3. This will trigger the download of kaggle.json, a file containing your API credentials.

        If the folder has been created in the containers lifetime and the files are already in that folder,...
        than this cell does nothing and requires no credentials.

    5. Lastly, wait for the rest of the cells to finish and observe the results printed for each cell.



#LOOK: How should teh requirement sufficent memory be explained????
LOOK: need to make sure that it is known that the version of python is 3.10.7



Notes about the notebook:

For testing it is important to note that there are two major sections of the notebook.

(cell 1 - cell 4) is for formatting and cleaning data before building the model.
It saves the data in the form of a csv file called "constructed_data.csv".

(cell 5 - cell 8) is for transforming the data in "constructed_data.csv" to build a model.
If the kernel were restarted than the data in the form of "constructed_data.csv" persisits so that only (cell 5 - cell 8) 
needs to be rerun. 

This is especially critical if even more train and test data was tested with this program, since cell 3 is a relatively expensive cell and can be ignored
after running once when testing parameters in (cell 5 - cell 8).

#important note:
#Effectively, the only parameter set in (cell 1 - cell 4) is the bounds for the number of ratings for a user to be a train user or test user
#this is an important paramter to be set in the early cells (cell 1 - cell 4) becasue it reduces processing time and reduces the size of "constructed_data.csv"








