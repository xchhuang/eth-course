import numpy as np
import random
# from sklearn.kernel_approximation import RBFSampler
# from sklearn.svm import LinearSVC

batch_size = 2000
features = 400
new_features = 8000
mini_batch = 128
w = np.random.randn(new_features)
x_train = np.zeros((batch_size, features))
y_train = np.zeros(batch_size)
data = np.zeros((batch_size, features+1))
iterations = 2000
lamda = 100
# rbf_feature = RBFSampler(gamma=1, random_state=1, n_components=new_features)
# omega_means = np.zeros(shape=new_features-1)
# omega_covariance = np.identity(new_features-1)
# omega = np.random.multivariate_normal(mean=omega_means, cov=omega_covariance, size=features)
# b = np.random.uniform(low=0.0, high=2.0*np.pi, size=new_features-1)


# samples = 2000 # Number of samples
# Creation of the omega and beta samples for Random Fourier Features with Laplacian kernel
# Drawing omega_samples from the Cauchy distribution
# omega = np.random.standard_cauchy((new_features-1, features))
# b = np.random.uniform(low=0.0, high=2.0*np.pi, size=new_features-1)
# gamma = 0.1
omega = np.random.normal(size=(new_features, features), scale=2.8)
b = 2*np.pi*np.random.rand(new_features)

def transform(X):
	# Make sure this function works for both 1D and 2D NumPy arrays.

	X_transformed = np.sqrt(2. / (new_features)) * np.cos((X.dot(omega.T) + b))
	
	return X_transformed
	# return X


def mapper(key, value):
	# key: None
	# value: one line of input file
	global w
	# w = np.zeros(new_features)
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
	# print y_train
	# print x_train.shape
	# print y_train.shape
	gt = np.zeros(new_features)
	v = 0
	mu = 0.9
	# learning_rate = 0.001
	l2 = 0.001
	moment_vector_1 = np.zeros(new_features)
	moment_vector_2 = np.zeros(new_features)
	beta1 = 0.9
	beta2 = 0.999

	epsilon = 10**(-8)

	# clf = LinearSVC(random_state=0)
	# clf.fit(x_train, y_train)
	# w = clf.coef_
	
	# v_prev_Wf = v_Wf
	# v_Wf = mu * v_Wf - learning_rate * Wf_grad
	# Wf += -mu * v_prev_Wf + (1 + mu) * v_Wf - 2*0.01*Wf
	# learning_rate = 0.001
	for t in xrange(iterations):
		sample_index = np.random.choice(batch_size, mini_batch)
	# # # 	# sample_index = random.sample(range(0, batch_size), 1)
	# # # 	# print sample_index
		x = x_train[sample_index]
		y = y_train[sample_index]
		# print x.shape
		# print y.shape
		learning_rate = 1. / ((t+1) ** 0.5)

		f = np.dot(x, w) * y
		x_temp = x[f<1]
		y_temp = y[f<1]
		# print x_temp.shape
		# print y_temp.shape
	# # # 	# print 
		grad = -np.dot(y_temp, x_temp)
		 
		# print grad
	# # 	# gt += grad**2
	# # 	# print yx.shape
	# # 	# print yx.shape
	# # 	# w += (learning_rate / (np.sqrt(gt)+0.01)) * grad
		# w -= learning_rate * grad

		# moment_vector_1 = beta1*moment_vector_1 + (1.0 - beta1)*grad # Update biased first moment estimate
		# moment_vector_2 = beta2*moment_vector_2 + (1.0 - beta2)*(grad**2) # Update biased second raw moment estimate
		# moment_vector_1_corr = moment_vector_1/(1.0 - beta1**t) # Compute biased-corrected first moment estimate
		# moment_vector_2_corr = moment_vector_2/(1.0 - beta2**t) # Compute bias-corrected second raw moment estimate
		# w = w - learning_rate*moment_vector_1_corr/(np.sqrt(moment_vector_2_corr) + epsilon) # Update weight vector

		v_prev = v
		v = mu * v - learning_rate * grad
		w += -mu * v_prev + (1 + mu) * v

		# w_norm = np.sum(w**2)**0.5
		# w *= np.minimum(1, 1. / (lamda**0.5 * w_norm))
		# print np.minimum(1, 1. / (lamda**0.5 * w_norm))
		# print w
	# print x_train.shape
	# print x_train[:, 1:].shape
	# print w
	yield 0, w
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
