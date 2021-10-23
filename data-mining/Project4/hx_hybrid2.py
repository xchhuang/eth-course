import numpy as np

# params of LinUCB: alpha
# delta = 0.05
# alpha = 1 + np.sqrt(np.log(2.0 / delta) / 2)

alpha = 0.2
# print alpha

# size of user features
d = 6
k = 6*6

A0 = np.identity(k)
b0 = np.ones((k,1))

Aa = {}
Ba = {}
inverse_Aa = {}
inverse_A0 = np.identity(k)
ba = {}
theta = {}
beta = inverse_A0.dot(b0)
# most time consuming term, needed to be updated in update function
sta = {}
at = {}
# global variable for used in update
recommended_article = 0
zt = np.zeros((k,1))
xt = np.zeros((d,1))
# reward of 0 and 1
r0 = -1
r1 = 100

first = 0


def sta_term(a, zt, xt):
	return zt.T.dot(inverse_A0).dot(zt) - 2*zt.T.dot(inverse_A0).dot(Ba[a].T).dot(inverse_Aa[a]).dot(xt) + xt.T.dot(inverse_Aa[a]).dot(xt) + xt.T.dot(inverse_Aa[a]).dot(Ba[a]).dot(inverse_A0).dot(Ba[a].T).dot(inverse_Aa[a]).dot(xt)

def sta_inter_part(a, zt):
	return zt.T.dot(inverse_A0).dot(zt) - 2*zt.T.dot(inverse_A0).dot(Ba[a].T).dot(inverse_Aa[a]).dot(xt)

def sta_user_part(a, xt)
	return xt.T.dot(inverse_Aa[a]).dot(xt) + xt.T.dot(inverse_Aa[a]).dot(Ba[a]).dot(inverse_A0).dot(Ba[a].T).dot(inverse_Aa[a]).dot(xt)

def set_articles(articles):
    for a in articles:
    	at[a] = np.array(articles[a])
    	at[a] = at[a].reshape((6,1))
    	Aa[a] = np.identity(d)
    	inverse_Aa[a] = np.identity(d)
    	Ba[a] = np.zeros((d,k))
    	ba[a] = np.zeros((d,1))
    	# compute those time consuming tern first and in update function
    	# sta[a] = xt[a].T.dot(inverse_Aa[a]).dot(xt[a]) + xt[a].T.dot(inverse_Aa[a]).dot(Ba[a]).dot(inverse_A0).dot(Ba[a].T).dot(inverse_Aa[a]).dot(xt[a])
    	
    	# sta[a] = sta_term(a)
    	# print sta[a]
    	theta[a] = inverse_Aa[a].dot(ba[a] - Ba[a].dot(beta))

def update(reward):
	# recommended article not the displayed one

   	if reward == -1:
   		return 
   	# otherwise reward = 0 or 1
   	reward = r0 if reward == 0 else r1
   	# print reward
   	global A0, inverse_A0, beta, b0
   	# avoid repeated computation
   	temp1 = Ba[recommended_article].T.dot(inverse_Aa[recommended_article])
	A0 += temp1.dot(Ba[recommended_article])
	b0 += temp1.dot(ba[recommended_article])
	Aa[recommended_article] += xt.dot(xt.T)
	Ba[recommended_article] += xt.dot(zt.T)
	ba[recommended_article] += reward * xt

	inverse_Aa[recommended_article] = np.linalg.inv(Aa[recommended_article])

	temp2 = Ba[recommended_article].T.dot(inverse_Aa[recommended_article])
	A0 += zt.dot(zt.T) - temp2.dot(Ba[recommended_article])
	b0 += reward * zt - temp2.dot(ba[recommended_article])

	inverse_A0 = np.linalg.inv(A0)
	beta = inverse_A0.dot(b0)
	theta[recommended_article] = inverse_Aa[recommended_article].dot(ba[recommended_article] - Ba[recommended_article].dot(beta))

	# sta[recommended_article] = sta_term(recommended_article)

def recommend(time, user_features, choices):
	# print choices
	
	global zt, xt, first
	global recommended_article
	# max_idx = -1
	max_ucb = -np.inf

	user = np.array(user_features)
	user = user.reshape((d,1))
	
	# sta_user = sta_user_part(user)

	for a in choices:
		z_t = at[a].dot(user.T)
		z_t = z_t.reshape((k,1))

		sta[a] = sta_term(a, z_t, user)
		st_a = sta[a]
		UCBx = z_t.T.dot(beta) + user.T.dot(theta[a]) + alpha * np.sqrt(st_a)

		if max_ucb < UCBx:
			max_ucb = UCBx
			recommended_article = a
			zt = z_t
			xt = user
	first += 1
	# zt = z_t
	# recommended_article = max_idx
	return recommended_article
	# return np.random.choice(choices)
