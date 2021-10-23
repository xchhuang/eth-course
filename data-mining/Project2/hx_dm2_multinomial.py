import numpy as np
import random


batch_size = 2000
features = 400
new_features = 20000

x_train = np.zeros((batch_size, features))
y_train = np.zeros(batch_size)
data = np.zeros((batch_size, features+1))
iterations = 180
lamda = 1e-6
mini_batch = 50

# W = np.random.randn(new_features)
W = np.zeros(new_features)
omega = np.random.normal(size=(new_features, features), scale=5)
b = 2*np.pi*np.random.rand(new_features)

shuffled = np.zeros((new_features/features-1, features), dtype=np.int)

for i in range(new_features/features - 1):
	s = np.arange(features)
	# print (s)
	# print (s.shape)
	shuffled[i] = np.random.permutation(s)
	# print shuffled[i]


# def transform(X):
# 	# Make sure this function works for both 1D and 2D NumPy arrays.
# 	n, m = X.shape
# 	# X -= X.mean(axis=0)
# 	X_transformed = np.sqrt(2. / (new_features)) * np.cos((X.dot(omega.T) + b))
# 	# X_transformed = (X_transformed - X_transformed.mean(axis=0))
# 	# X_transformed = np.concatenate((np.ones((n,1)), X_transformed), axis=1)
# 	return X_transformed
# 	# return X

def transform(X):
	# Make sure this function works for both 1D and 2D NumPy arrays.

	# X_transformed = np.sqrt(2. / (new_features)) * np.cos((X.dot(omega.T) + b))
	X_transformed = np.multiply(X, X)
	# shuffled = np.arange(features)
	for i in range(new_features/features - 1):
		# shuffled = np.random.permutation(shuffled)
		# print (shuffled[i].shape)
		X_transformed = np.concatenate((X_transformed, np.multiply(X,X[:,shuffled[i]])),axis=1)

	return X_transformed


def mapper(key, value):
	# key: None
	# value: one line of input file
	global W
	
	# W = np.zeros(new_features)
	i = 0
	for lines in value:
		line = lines.strip().split()
		# print line
		v = [float(x) for x in line]
		v = np.array(v)
		# print np.sum(v)
		data[i,:] = v

		# print x_train[i,:]
		i += 1

	x_train = data[:,1:]
	y_train = data[:,0]
	x_train = transform(x_train)
	print x_train.shape
	
	# print x_train.shape
	# print y_train.shape
	
	v = 0
	mu = 0.9
	learning_rate = 0.02
	l2 = 0.001
	m_t = np.zeros(new_features)
	v_t = np.zeros(new_features)
	beta1 = 0.9
	beta2 = 0.99
	epsilon = 1e-8

	for t in xrange(1,iterations+1):
		sample_index = np.random.choice(batch_size, mini_batch)
		x = x_train[sample_index]
		y = y_train[sample_index]
		# print x.shape
		# print y.shape
		# learning_rate = 1. / (t ** 0.5)

		f = np.dot(x, W) * y
		x_temp = x[f<1]
		y_temp = y[f<1]
		grad = -np.dot(y_temp, x_temp)
		# W -= learning_rate * grad
		# adam optimizer
		# lr_t = learning_rate * np.sqrt(1 - beta2**t) / (1 - beta1**t)
		m_t = beta1 * m_t + (1 - beta1) * grad
		v_t = beta2 * v_t + (1 - beta2) * grad * grad
		W -= learning_rate * m_t / (np.sqrt(v_t) + epsilon)

		# momemtum optimizer
		# v_prev = v
		# v = mu * v - learning_rate * grad
		# W += -mu * v_prev + (1 + mu) * v

		# projection of W
		# w_norm = np.sum(W**2)**0.5
		# W = W * np.minimum(1, 1. / (lamda**0.5 * w_norm))

	yield 0, W
	# yield "key", "value"  # This is how you yield a key, value pair
	


def reducer(key, values):
    # key: key from mapper used to aggregate
    # values: list of all value for that key
    # Note that we do *not* output a (key, value) pair here.
    w = np.zeros(new_features)
    n = len(values)
    for i in values:
    	w += i
    w /= n
    yield w
