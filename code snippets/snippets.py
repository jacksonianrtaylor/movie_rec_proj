# for key in user_to_inputs.keys():
#     if(int(len(user_to_inputs[key])*.25) != 0):
#         random.shuffle(user_to_inputs[key])
#         user_to_X_train[key] = user_to_inputs[key][int(len(user_to_inputs[key])*.25):]
#         user_to_y_train[key] = user_to_rand_ratings[key]
#         user_to_X_test[key] = user_to_inputs[key][:int(len(user_to_inputs[key])*.25)]
#         user_to_y_test[key] = user_to_rand_ratings[key]
#     else:
#         random.shuffle(user_to_inputs[key])
#         user_to_X_train[key] = user_to_inputs[key][1:]
#         user_to_y_train[key] = user_to_rand_ratings[key]
#         user_to_X_test[key] = user_to_inputs[key][:1]
#         user_to_y_test[key] = user_to_rand_ratings[key]