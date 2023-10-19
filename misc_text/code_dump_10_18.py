# #no scaling (best performance):
# def analysis_1(layers, train_inputs, test_inputs):
#     # build and train model
#     # nn model (worse performance)
#     # reg = MLPRegressor(hidden_layer_sizes = layers, solver = "adam",  max_iter = 1000)
#     # linear regression (better performance)
#     reg = LinearRegression()
#     reg.fit(train_inputs, train_users.user_to_target_rating)

#     #show importance of different inputs features to the model
#     results = permutation_importance(reg, train_inputs, train_users.user_to_target_rating)
#     print("Feature Importances: ", results["importances_mean"])

#     #make predictions
#     predictions = reg.predict(test_inputs)

#     #test with and without roundings...
#     #in a sense this is logical sense becasue the actual ratings a user makes must be divisable by .5 
#     rounded_predictions = []
#     for item in predictions:
#         rounded_predictions.append(float(round(item*2)/2.0))

#     #evaluation metric 1:
#     return(r2_score(test_users.user_to_target_rating, predictions), 
#         r2_score(test_users.user_to_target_rating, rounded_predictions))

#     #evaluation metric 2:
#     # return(mean_squared_error(test_users.user_to_target_rating, predictions), 
#     #         mean_squared_error(test_users.user_to_target_rating, rounded_predictions))

# #scale inputs and targets:
# def analysis_2(layers, train_inputs, test_inputs):
#     #scale input features
#     train_inputs_scaled = StandardScaler().fit_transform(train_inputs)

#     #scale target values
#     target_scalar = StandardScaler()
#     true_rating_train_scaled = target_scalar.fit_transform(np.reshape(train_users.user_to_target_rating, (-1, 1)))
#     true_rating_train_scaled = np.reshape(true_rating_train_scaled, len(true_rating_train_scaled))

#     #build and train model
#     reg = MLPRegressor(hidden_layer_sizes = layers, solver = "adam",  max_iter = 1000)
#     reg.fit(train_inputs_scaled, true_rating_train_scaled)

#     #show importance of different inputs features...
#     results = permutation_importance(reg, train_inputs_scaled,true_rating_train_scaled)
#     print(results["importances_mean"])

#     #scale inputs features
#     test_inputs_scaled = StandardScaler().fit_transform(test_inputs)

#     #predict the scaled verison of ouptuts
#     scaled_predictions = reg.predict(test_inputs_scaled)

#     #get actual predictions from scaled predictions...
#     predictions = target_scalar.inverse_transform(scaled_predictions.reshape(-1, 1))
#     predictions = list(predictions.reshape(len(predictions)))

#     #test with and without roundings...
#     #in a sense this is logical sense becasue the actual ratings a user makes must be divisable by .5 
#     rounded_predictions = []
#     for item in predictions:
#         rounded_predictions.append(float(round(item*2)/2.0))

#     #evaluation metric 1:
#     return(r2_score(test_users.user_to_target_rating, predictions), 
#         r2_score(test_users.user_to_target_rating, rounded_predictions))

#     #evaluation metric 2:
#     # return(mean_squared_error(test_users.user_to_target_rating, predictions), 
#     #         mean_squared_error(test_users.user_to_target_rating, rounded_predictions))

# #only scale inputs:
# def analysis_3(layers, train_inputs, test_inputs):
#     #scale input features
#     train_inputs_scaled = StandardScaler().fit_transform(train_inputs)

#     #build and train model
#     reg = MLPRegressor(hidden_layer_sizes = layers, solver = "adam",  max_iter = 1000)
#     reg.fit(train_inputs_scaled, train_users.user_to_target_rating)

#     #show importance of different inputs features...
#     results = permutation_importance(reg, train_inputs_scaled, train_users.user_to_target_rating)
#     print(results["importances_mean"])

#     #scale inputs features
#     test_inputs_scaled = StandardScaler().fit_transform(test_inputs)

#     #predict the scaled verison of ouptuts
#     predictions = reg.predict(test_inputs_scaled)

#     #test with and without roundings...
#     #in a sense this is logical sense becasue the actual ratings a user makes must be divisable by .5 
#     rounded_predictions = []
#     for item in predictions:
#         rounded_predictions.append(float(round(item*2)/2.0))

#     #evaluation metric 1:
#     return(r2_score(test_users.user_to_target_rating, predictions), 
#         r2_score(test_users.user_to_target_rating, rounded_predictions))

#     #evaluation metric 2:
#     # return(mean_squared_error(test_users.user_to_target_rating, predictions), 
#     #         mean_squared_error(test_users.user_to_target_rating, rounded_predictions))


#LOOK: need to cover the information below
#this is valuable information that should probably be somewhere

#note: before passing to this function the data is normalized about the average movie ratings (not average user ratings)
#each user train and test users have a single rating that needs to be trained against in the train case
#and predicted in the test case

#the svd can be applied to the combined data of the train and test sets
#both movies that the user didn't watch and movies that should be guesses are...
#transformed to have a value of zero before svd

#the movie columns are taken from the train dataset...
#senario: suppose a test user has a rating of a movie not part of the train set and it is not the target movie (ignore it)
#senario: suppose a test user has a rating of a movie not part of the train set and it is the target movie (guess the rating instead of using svd)

#LOOK this does not seem correct!!! verify if this is true !!!

#...Once the UsV is created...
#take the rating from the new UsV for the user row and movie column for the target movie