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

Quick Way (with docker):

requirements:
-Git
-Dockerdesktop
-Sufficent memory

clone the repository
navigate to the main project directory
build docker image using the provided Dockerfile:
run the created docker image:

browser method: 
open localhost:8888 in browser window
open the complete_02_08_2023.ipynb file in the browser notebook and run

vscode method: 
open the complete_02_08_2023.ipynb file in the main project directory
select kernel in top right/select another kernel/existing jupyter server
copt and paste the jupyter server access token that is found in the console
after "Jupyter Server 2.7.3 is running at:"

note: there are other methods for other editors and IDE's to connect to a remote ipython kernel...
https://medium.com/@halmubarak/connecting-spyder-ide-to-a-remote-ipython-kernel-25a322f2b2be

then run the notebook 
computation can take some time (estimation)


Explicit Way (no docker):

requirements:
-Git
-Sufficent memory
-python3 and pip (working python version: 3.10.7)

with python and pip
create a python virtual env in the main project directory:
install the following packages to the virtual env:
scipy, scikit-learn, pandas, nltk, ordered_set
activate the virtual environment
use python to run the transform.py (and observe results in console)
after completion of transform.py run analysis.py (and observe results in console)
computation can take some time (estimation)

