import numpy as np

# params of LinUCB: alpha
delta = 0.05
alpha = 1 + np.sqrt(np.log(2.0 / delta) / 2)

# alpha = 0.2
# print alpha
# each x in action At should have a weights
Mx = {}
bx = {}
inverse_Mx = {}
wx = {}
# size of user features
num_features = 6
# global variable for used in update
recommended_article = 0
zt = np.zeros((num_features,1))

# reward of 0 and 1
r0 = -1
r1 = 20

print alpha, r0, r1

def set_articles(articles):
    pass 


def update(reward):
	# recommended article not the displayed one
   	if reward == -1:
   		return 
   	# otherwise reward = 0 or 1
   	reward = r0 if reward == 0 else r1
   	
	Mx[recommended_article] += zt.dot(zt.T)
	bx[recommended_article] += reward * zt
	inverse_Mx[recommended_article] = np.linalg.inv(Mx[recommended_article])
	wx[recommended_article] = (inverse_Mx[recommended_article].dot(bx[recommended_article]))

def recommend(time, user_features, choices):
	# print choices
	global zt
	global recommended_article
	zt = np.array(user_features)
	zt = zt.reshape((num_features,1))
	# print zt.shape
	UCB = []
	for x in choices:
		if x not in Mx:
			Mx[x] = np.identity(num_features)
			bx[x] = np.zeros((num_features,1))
			inverse_Mx[x] = np.linalg.inv(Mx[x])
			wx[x] = inverse_Mx[x].dot(bx[x])

		UCBx = wx[x].T.dot(zt) + alpha * np.sqrt(zt.T.dot(inverse_Mx[x]).dot(zt))
			# print UCBx.shape
		UCB.append(UCBx)
			# print wx.shape
	# print len(UCB)
	# choose one article to recommend from articles of that user
	# UCB[np.random.choice(len(UCB))] += 1e-6
	max_idx = np.argmax(UCB)

	# max_val = max(UCB)
	# max_indices = [i for i,v in enumerate(UCB) if v == max_val]
	# # # if len(max_indices) > 1:
	# # # 	print 'yes'

	# max_idx = np.random.choice(max_indices)
	recommended_article = choices[max_idx]
	return recommended_article
	# return np.random.choice(choices)
