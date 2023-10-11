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


results and custom inputs:
