
#cell 1:

import pandas as pd

#This cell is for combining certain data from the necessary csv files into a single dataframe (complete)

#On the topic of row iteration and removal:
#iteration through rows of a dataframe at this level is usually inefficient 
#however, it is done before multiple copies of same movie data becomes present in multple rows
#thoeretically, this should save time because it removes rows before they are copied for multple users
#suppose the dataframes were conveted to a list to omit certain rows with faster iteration...
#than the fastest option is to replace the old list with a list with certain rows removed rather than using the datafram drop function 
#and the lists would have to be converted back into a dataframe to make use of the merge function

#LOOK: can a merge function be created for lists??? does one exist


pd.set_option('display.max_colwidth', None)

movies = pd.read_csv('./the-movies-dataset/movies_metadata.csv',usecols=("genres","id" ,"title","tagline", "overview","production_companies"),
                          dtype={"tagline": "string", "id":"string", 'genres':"string", "title": "string", "tagline": "string","overview":"string", "production_companies" :"string"})
movies = movies.dropna()
movies = movies.reset_index()



#filter rows of empty data from movies on the columns: "genres", "production_companies"
drop_indices = []
for i in range(len(movies)):
    len_1 = len(movies.iloc[i].loc["genres"])                   
    if(movies.iloc[i].loc["genres"][len_1 -2:] == "[]"):
        drop_indices.append(i)
        continue
    len_2 = len(movies.iloc[i].loc["production_companies"])
    if(movies.iloc[i].loc["production_companies"][len_2 -2:] == "[]"):
        drop_indices.append(i)    
        continue   

movies = movies.drop(labels=drop_indices, axis = 0)
movies = movies.reset_index(names = "index_1")


ratings = pd.read_csv('./the-movies-dataset/ratings.csv', usecols = ("userId", "movieId", "rating"), dtype={"userId": "string","movieId": "string","rating": "string"})
ratings = ratings.rename(columns={"movieId": "id"})
ratings.dropna()
ratings = ratings.reset_index(names = "index_2")


keywords = pd.read_csv('./the-movies-dataset/keywords.csv', usecols = ("id", "keywords"), dtype={"id": "string","keywords":"string"})
keywords.dropna()
keywords = keywords.reset_index()

#filter rows of empty data from keyword on the keywords column
drop_indices = []
for i in range(len(keywords)):
    len_1 = len(keywords.iloc[i].loc["keywords"])                   
    if(keywords.iloc[i].loc["keywords"][len_1 -2:] == "[]"):
        drop_indices.append(i)

keywords = keywords.drop(labels=drop_indices, axis = 0)
keywords = keywords.reset_index(names = "index_3")


credits = pd.read_csv("./the-movies-dataset/credits.csv", usecols = ("cast", "id"), dtype={"cast": "string", "id": "string"})
credits.dropna()
credits = credits.reset_index()

#filter rows of empty data from credits on the cast column 
drop_indices = []
for i in range(len(credits)):
    len_1 = len(credits.iloc[i].loc["cast"])                   
    if(credits.iloc[i].loc["cast"][len_1 -2:] == "[]"):
        drop_indices.append(i)

credits = credits.drop(labels=drop_indices, axis = 0)
credits = credits.reset_index(names = "index_4")


#default merge is inner: this only keeps movies that have the id existing in both dataframes
complete =  pd.merge(movies, ratings, on ="id")
complete =  pd.merge(complete,keywords, on ="id")
complete  = pd.merge(complete,credits, on ="id")


complete = complete.sort_values(by = 'userId')


#use only certain types of columns
complete  = complete.loc[:,['userId','id','rating',"title", "genres","production_companies","keywords", "cast", "tagline", "overview" ]]


del movies
del ratings
del keywords
del credits

#for testing
print(complete.head())



#orginal run: 1m 5.7

#new run: 
