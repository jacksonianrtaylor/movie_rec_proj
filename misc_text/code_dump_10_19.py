# #old code:
# #removes users that dont fit the bounds for the acceptable number of users
# # for _ in range(len(gaps)):
# #     if gaps[index] < min_number_of_ratings:
# #         temp = gaps[index]
# #         del gaps[index]
# #         del list_of_user_ids[index]
# #         del complete_list_no_dups[complete_list_index:complete_list_index+temp]
# #     else:
# #         complete_list_index+=gaps[index]
# #         index+=1



# #this is a list for all users to rows of transformed data for each movie they rated
# user_to_data = []

# #this is the total number of users in the whole dataset
# #total number of users for min number of ratings 100: (17378)???
# #lOOK: What is the total number of users in the dataset and with at least 100 ratings
# total_nof_users = len(list_of_user_ids)
# print("Total number of users:", total_nof_users)


# #this is the number of desired users out of the total_nof_users:
# #note: this number is not exact to the number of users because it is applied in a random operation...
# #note: extra 250 is used to account for error with a target of 5000 users
# nof_users_aproximation =  5250

# #index of the current movie row 
# index  = 0

# #this is collected for insight
# avg = 0.0
# cnt = 0.0


# #LOOK: alternate method:
# #1. randomly choose 5000 unqiue indices from the indices below the length of total_nof_users and make a list of them
# #2. iterate through the list of 5000 unqiue indices
# #3. when an indice is reached need to move index to the corerpsodnign movie row
# #this seems more complicated thanth method below!!!


# #populate user_to_data from complete_array
# for i in range(0, total_nof_users):
#     #generate a random float to determine a pass for the user
#     if((train_or_test[i]) and (random.random()<float(5200/total_nof_users))
#        or (not train_or_test[i]) and (random.random()<float(1200/total_nof_users))):
#         user_to_data.append([])
#         last_index = len(user_to_data) -1
#         for j in range(index, len(complete_list_no_dups)):
#             if complete_list_no_dups[j][0] == list_of_user_ids[i]:
#                 #orginally: the condition function checked if the movie row had missing values for certain columns and...
#                 #omitted the movie if it had missing values   
#                 #a more efficient method is used instead in the second cell  
#                 # if(condition(complete_array[j])):
#                     #transform data...
#                 transformed = provide_data(complete_list_no_dups[j])
#                 user_to_data[last_index].append(transformed)    
#             else:
#                 avg += len(user_to_data[last_index])
#                 cnt+=1
#                 index = j
#                 break           
#     else:
#         index += gaps[i]



# #Go through user_to_data and re-index the users in list order since certain users were omitted
# #this is for simplicity and readability 
# for i in range(len(user_to_data)):
#     for j in range(len(user_to_data[i])):
#         user_to_data[i][j][0] = i


# #How many users are in the final user_to_data 
# print("Number of users chosen:", len(user_to_data))

# #average number of ratings per users
# #note: omits the very last user but this makes little difference
# print("Average number of ratings for the number of users chosen:", float(avg/cnt))


# print("Minutes taken: ", float((time.time()-start_time)/60))


#LOOK: should there be trials with train users with a high number of ratings
#and test users with a low number of ratings???

#LOOK: suppose there are two type of users:
#users with 5-10 ratings and users with 100 or more ratings
#both of these users can be accepted here, but there will be no markings for whether they are a test or train user 
#the first group of users is the test users and the second group of users is the train users
#problem: there will be alot more users with 5-10 ratings than more than 100 ratings
#when then 5th cell chooses different users the test users need to be seperate from the train users
#and then a certain amount of test users and a certain amount of train users can be selected
#there can be train and test pool created in the first loop
#another issue is the condition below: 
#it takes an aproximate amount of users but it doesn't deliniate between test and train users
#suppose there was an overlapping for number of allowed ratings for train and test users types
#then whether it belongs to the train and test pool would have to be determined randomly or semi randomly
#what if there was a bit for all the accepted users that deliniated between test and train users???
#then there could be a seperate condition in the last loop in this cell that passed test users
#and passed train users 
#in cell 5 the users can be sorted by number of movies they watched to be put in train and test pools
#that then will be picked from by the random chooser

