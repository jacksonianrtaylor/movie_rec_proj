Goal:

The main idea of the program is to predict what a user rating to a movies for a particular movie would be based on thier rating to other movies.

This is not to be confused with picking movies that are good fit compared to the users movie preference. Instead it seeks to be useful for every user-movie combination even movies that the user would hate.




process:
Certain target features are picked to feed into a MLP model...




the model might need to be reworked...

A similarity score and movie rating combo between the chosen movie and all other movies the user rated could be helpful

rather than simply providing the agregate sim score between the chosen movie and all other movies teh user rated

this also makes the overall spread variables like variance, skew, and kutosis redundant 

The z-score of ratings and similarity scores can also be included 
