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

disclaimers:

The process should not be confused with predicting something of the nature of a critics score or some metascore from a review website
It is based on user preference rather than a prediction based on pure production value that is generally applied to make good movies
The data used is based off random users and the movie rating predictions are for random users (not necessarily critics)

Additionally, The process should not be confused with simply picking movies that are good fit compared to the users movie preference. Instead it seeks to produce useful rating predictions for every user-movie combination even movies that the user would hate.



Process: 

Content based filtering:

In this notebook the answer to the question, how are movies similair? is answered with the notion of similair text based metadata

How is this data used to pair similair movies:
- the constrcutedData.csv is built 
- this includes all the relevant data columns from every .csv in the entire movies data set tah might produce helpful text data
- every line in the constrcutedData.csv has a user id and a movie id and a number of columns that hold valuable text data that represent the movie the user watched

- for each movie the user watched certain columns of text data are selected



- a bag of words is formed from every user by combining the words from
- 

LOOK: what happens if a user made two ratings for the same movie???


Collaborative filtering:


Combination of methods with linear model:


Similarity scores are collected between a randomly selected movie the user has watched and rated to the rest of the movies the user has watched and rated. 

An list of input features to the model includes statsticss about the movie to guess the rating rating for (not including rating), sataistics for a single other movie that the user has watched (including rating) and the simialirty score between the movie whose rating is known and the movie whose movie is to be predicted by the model. Then each prediction is agrergated  and summed for all the other movies the used has watched

The similarity score is calculated by comparing the unrated movie and a movies the user has watched by count vectorizing...
the words/terms formed by combining textual data from metadata, keywords, ratings, and credits for both of the movies in question.
cossine similarity is used to compute the similairty between the the count vectorized versions of both combined texts.


feeding the model both the similarities of movies that the user has watched to the movie to be rated and the user ratings of the movies seen by the user it is expected that the model would be able to derive some idea of the the unwatched movies rating. 

For instance, if a movie is given a high rating and is simlair to the un-watched movie though (cosine similarity) it should be expected that the unwatched movie in question should also be similair in rating.

The model used is the mlp regresssor model...





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

How to skip cells to save runtime:

results and custom inputs:
