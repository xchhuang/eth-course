import numpy as np

# params of LinUCB: alpha
delta = 0.05
alpha = 1 + np.sqrt(np.log(2.0 / delta) / 2)

# alpha = 0.2
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
xt = {}
# global variable for used in update
recommended_article = 0
zt = np.zeros((k,1))

# reward of 0 and 1
r0 = 0
r1 = 1

# print alpha, r0, r1

def sta_term(a):
	return xt[a].T.dot(inverse_Aa[a]).dot(xt[a]) + xt[a].T.dot(inverse_Aa[a]).dot(Ba[a]).dot(inverse_A0).dot(Ba[a].T).dot(inverse_Aa[a]).dot(xt[a])

def set_articles(articles):
    for a in articles:
    	xt[a] = np.array(articles[a])
    	xt[a] = xt[a].reshape((6,1))
    	Aa[a] = np.identity(d)
    	inverse_Aa[a] = np.identity(d)
    	Ba[a] = np.zeros((d,k))
    	ba[a] = np.zeros((d,1))
    	# compute those time consuming tern first and in update function
    	# sta[a] = xt[a].T.dot(inverse_Aa[a]).dot(xt[a]) + xt[a].T.dot(inverse_Aa[a]).dot(Ba[a]).dot(inverse_A0).dot(Ba[a].T).dot(inverse_Aa[a]).dot(xt[a])
    	sta[a] = sta_term(a)
    	# print sta[a]
    	theta[a] = inverse_Aa[a].dot(ba[a] - Ba[a].dot(beta))

def update(reward):
	# recommended article not the displayed one

   	if reward == -1:
   		return 
   	# otherwise reward = 0 or 1
   	reward = r0 if reward == 0 else r1
   	global A0, inverse_A0, beta, b0
	A0 += Ba[recommended_article].T.dot(inverse_Aa[recommended_article]).dot(Ba[recommended_article])
	b0 += Ba[recommended_article].T.dot(inverse_Aa[recommended_article]).dot(ba[recommended_article])
	Aa[recommended_article] += xt[recommended_article].dot(xt[recommended_article].T)
	Ba[recommended_article] += xt[recommended_article].dot(zt.T)
	ba[recommended_article] += reward * xt[recommended_article]

	inverse_Aa[recommended_article] = np.linalg.inv(Aa[recommended_article])

	A0 += zt.dot(zt.T) - Ba[recommended_article].T.dot(inverse_Aa[recommended_article]).dot(Ba[recommended_article])
	b0 += reward * zt - Ba[recommended_article].T.dot(inverse_Aa[recommended_article]).dot(ba[recommended_article])

	inverse_A0 = np.linalg.inv(A0)
	beta = inverse_A0.dot(b0)
	theta[recommended_article] = inverse_Aa[recommended_article].dot(ba[recommended_article] - Ba[recommended_article].dot(beta))

	sta[recommended_article] = sta_term(recommended_article)

def recommend(time, user_features, choices):
	# print choices
	global zt
	global recommended_article
	max_idx = -1
	max_ucb = -np.inf

	at = np.array(user_features)
	at = at.reshape((d,1))
	
	for a in choices:
		z_t = at.dot(xt[a].T)
		z_t = zt.reshape((k,1))

		st_a = zt.T.dot(inverse_A0).dot(zt) - 2*zt.T.dot(inverse_A0).dot(Ba[a].T).dot(inverse_Aa[a]).dot(xt[a]) + sta_term(a)
		UCBx = zt.T.dot(beta) + xt[a].T.dot(theta[a]) + alpha * np.sqrt(st_a)

		if max_ucb < UCBx:
			max_ucb = UCBx
			max_idx = a
	
	zt = z_t
	recommended_article = max_idx
	return recommended_article
	# return np.random.choice(choices)
