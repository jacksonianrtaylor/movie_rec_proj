### Goal:

The goal of the program is to build a model to predict what a new user would rate a particular movie...
based on their ratings to other movies and the relationship between other users rated movies and their own raetd movie.

In other words, the model attempts to predict what the user would score a movie they have not yet given a rating for.

This is valuable goal, because the model can give users an idea about how satisfied they will be with any movie.

This is why it is a more challenging task than only recommending movies the users would like.


### Clarification:

The process should not be confused with predicting something of the nature of a critics score or some metascore from a review website.

It does not use the text data in "the-movies-dataset" as direct features for the model.

It only uses them to calculate similairty between movies which is part of a function that makes a movie prediction.

It is based on user preference and realtionship between users rather than a prediction based on pure signs of production value...
that can be applied to predict good movies.

The data used is based off random users and the movie rating predictions are for random users



### Challenges:

* Many times the users ratings are not accuracte to their preference (there is wierd unexplained error).

* How can you measure how similair movies are? (Similarity score can be used in a method described in the content based filering section below.
    What data can we use to test simlairity?).

    3. How can the similairties between users help predict rating? (This is the point of svd function below in collaborative filtering)

    4. Predictions to a movie rating for a user can be worse if the user only inputs a small number of rated movies but...
    It is best to train and test a model where test users have a small number of ratings because it is more feasible...
    in a front-end implementation of this model.(Think about being a user who is prompted to enter some ratings for movies they saw to predict how much they would like a movie they didn't watch. They wouldn't want to feel like they are wasting time entering an excessive number of movie ratings)
    
    5. predictions to a movies rating can be worse when there are a small number of users who rated that same movie



Functionality notes:

- this program has the ability to choose users with a specific number of ratings for test and train users
- the default program focuses on test users with 5-10 ratings and train users with 30-50 ratings
- the point with keeping the number of test users low is to test how accurate predictions can be made...
- for a potential app that could use this model to guess users ratings to movies 
- in this case, the user would be more content to enter a small number of their own ratings than a large number of their own ratings
- but ease of use comes at a high cost to model performance


- For the case of the number of train users, many tests of the notebook have shown that there is some happy medium for the number of train users...
   when the number of test users stays constant at 5-10 users
- the best perfoming number of train user that was chosen to be tested was the current value in the program (30-50)
- this performed better than 11-31 and 50-70 users 
- It is likley that this means that the accuracy scores of the current configuration are not...
  the highest that this system can perform
- When training and testing bounds are specified in the context of training and evaluating this model...
  in this notebook the real bounds for ratings are shifted down to omit the target rating that is chosen amoung the users ratings.
  For exmaple if the ratings bounds are stated to be 30-50 train users the real bounds for the number of
  ratings they provide is 29-49.
  As for the testing bounds which are stated 5-10, the model is really being optimized to predict a rating...
  for 4-9 ratings given by the user
 


LOOK: What if in training for feature 3 the prediction included only users with ratings of 5-10???
In the same manor as testing for feature 3 ???

Remember: all training is, is figuring out the weight to give to feature 3 when making predicitons

Rows in the svd output that originally had more non-zero ratings are likely to have better output predictions.
meaning feature 3 could be improperly weighted from the train step.

However, the current configuration does not need a another group of train users that are within 5-10
becasue it uses the train users that are within 30-50 to train.

this is a flaw in the model...

should test in a new notebook






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
    The purpose of the model (loosley speaking) is how much weight to give to each feature for the optimal prediction.

    Using more than one predictor can fill in the short comings of a single model.

    From testing it was shown that the best combination of features are feature_1 and feature_3.
    Question: Isn't it optimal to use all three features??
    Answer: NO. Since feature 1 and feature 2 are so similair in nature, using both, only seems to complicate the optimization algorithm.
    This conclusion was gathered when acknowledging the decrease in performance when tested.

    This logic doesn't follow for the combination of feature_1 and feature_3, since they are completley different angles of prediciton.

    This is also the best combiabtion of features since Feature_1 is more predicting than feature_2 and the combination of them...
    produce worse results.

    Feature_1 being a stronger feature than feature 2 is a suprising hearistic.


    This could mean that movies that have similair word counts in the metadata don't necessarily mean that the user will rate them similairly...
    and perhaps the opposite behavior is more common.

    There could be other combinations of text sources or more explicit categories and datatypes besides text that could replace feature_2...
    and make up the shortcomings of the predictor.



Results:
All the relevant tests can be observed in the results.txt file.

The variables that stay the same for every test are:
- (number of train users): 5000, (number of test users): 1000
- test user bounds: 5-10 
- 100 models tested with the same input. The acuraccy scores are an average for each test (this is to reduce error)

LOOK: state th ever bound is -1...


The best feature combination (feature 1 and feature 3) are tested with different train user bounds.

There are three train rating bounds for the train users that are tested:
11-31, 30-50, and 50-70.

For each of these rating bounds, different combinations of n used with the svd_full functions were tested with linear regression.

Once the n values leading to the aproximate best accuracy for linear rergession were found for each of the train bounds,
the results were recorded. 

Linear regression was not the only model tested.

Standard sklearn mlp models were also tested with the only extra parameter being layers.

The approximate best mlp models for the corresponding train rating bounds were...
found by using the best combination of n values for the best linear rergession model...
with matching rating bounds.

For each of the three (rating bounds and corresponding best n values) three mlp models are tested to show the aproximate best mlp model parameters.

This is the number of layer combinations that is neither two small or too large.


Three layer combinations are used to show that the approximate best layer combiantion is in the middle grounds for number of layer combination betwen the 2 other models. 

For 30-50, and 50-70 train user bounds, the best performing model happened to be the best (middle range layered)...
mlp model and for 11-31 train user bounds the best performing model was linear regression.


When comparing the linear regression model and the three other mlp models for each 
(rating bounds and corresposning best n values) the observations show that the accuracy results are similair,
often a difference in the thousandths place


However, there is more noticable differences in performance when comparing tests with different (rating bounds and corresponding best n values). These differences are often in the hundredths place. 

The test above account for 12 tests shown in results. 
There are 4 unique models for each of 3 (rating bounds and corresposning best n values).

There is a slight shortcut used here to reduce the testing for mlp models for different values of n.

One could potentially state that the optimal n values for linear regression are not the optimal values...
for mlp modles with the same (rating bounds and corresposning best n values).


However, judging the small difference between models with the same...
(rating bounds and corresposning best n values), if there were mlp models with different optmal values of n...
than the linear regression model with the same (rating bounds and corresposning best n values)...
it would be counterintutive and likely lead to very little perfromance gain.


#The other combination of featues worth exploring in results were feature 2 and feature 3.

#Since it was clear that the performance of (feature 2 and feature 3) was worse than (feature 1 and feature 3)...
after a few tests, only the best perfroming (rating bounds and corresposning best n values) for feature 1 and feature 3 were used knowing that even the most optimaize tweaks to the paramters would not lead to feature 2 and feature 3 outperforming feature 1 and feature 3. 


The reason feature 2 and feature 3 are part of the results is to show the difference betwen using
only the genre column and all the relevant columns.

Linear regression was tested with the variables forced above for (feature 2 and feature 3), for only the genres column and then again for all the columns saved in the constructed_data.csv.

From this test, it was clear that utilizing all the columns was superior to only using genres.

The full corpus was also tested with mlp models using the same technique when testing for
feature 1 and feature 3. 

The number of layer combinations that is neither two small nor too large is shown to have higher performance compared to two other sets of mlp layers.

This medium layer combiantion was the highest perfrkoing parameters for feature 2 and feature 3.




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








