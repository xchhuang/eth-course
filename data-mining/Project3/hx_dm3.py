import numpy as np
import numpy.linalg as la

# k-means parameters
K = 200
k = 200
dim = 250
alpha = 16*(np.log(k) + 2)
csize = 2500   # the size of coreset for one mapper

def kmeanspp(value,k):
    X = value
    n = X.shape[0]
    # D2 sampling 
    center = []
    B = X[np.random.choice(n),:]
    center.append(B)
    temp = la.norm(X - B, axis=1)
    distances = np.empty((0, n))
    for i in range(1, k):
        distances = np.vstack((distances, la.norm(X - B, axis=1) ** 2))  # dim = 199 x 3000
        # print distances.shape
        min_dist = np.amin(distances, axis=0)   # shape = (3000,)
        # print min_dist.shape
        Px = np.divide(min_dist, np.sum(min_dist))
        B = X[np.random.choice(n, p=Px), :]
        center.append(B)

    center = np.array(center)
    print center.shape
    return center

def coreset_gen(value,k):
    X = value
    n = X.shape[0]
    # D2 sampling 
    center = []
    B = X[np.random.choice(n),:]
    center.append(B)
    temp = la.norm(X - B, axis=1)
    distances = np.empty((0, n))
    for i in range(1, k):
        distances = np.vstack((distances, la.norm(X - B, axis=1) ** 2))  # dim = 199 x 3000
        # print distances.shape
        min_dist = np.amin(distances, axis=0)   # shape = (3000,)
        # print min_dist.shape
        Px = np.divide(min_dist, np.sum(min_dist))
        B = X[np.random.choice(n, p=Px), :]
        center.append(B)

    center = np.array(center)
    # print center.shape
    c_phi = np.sum(min_dist) / n
    group_num = np.argmin(distances, axis=0)  # map the sample into its group number 
    Bi = [[]for i in range(k)]
    for i in range(n):
        Bi[group_num[i]].append(i)            # Bi: store samples in the subgroup i (with center mu_i)

    # to compute the second and third term of S(x)
    bound = np.zeros(n)
    for i in range(n):
        dist_sum = 0
        for j in Bi[group_num[i]]:
            dist_sum += min_dist[j]
        group_size = len(Bi[group_num[i]])
        bound[i] = 2 * alpha * dist_sum / (group_size * c_phi) + 4 * n / group_size
    bound = np.asarray(bound)
    # print bound.shape
    Sx = alpha * min_dist / c_phi + bound
    qx = np.divide(Sx, np.sum(Sx))
    w = 1.0 / (csize * qx)
    samples = np.random.choice(n, size=csize, p=qx)
    wx = np.reshape(w[samples], (-1, 1))
    coreset = np.concatenate((X[samples, :], wx), axis=1)

    print (coreset.shape)
    # yield 0, coreset
    return coreset

def mapper(key, value):  # subset of images: 3000 x 250
    # key: None
    # value: one line of input file
    center = coreset_gen(value,k)
    
    yield 0, center  


def reducer(key, values):  # dim := 9000 x 251 
    # key: key from mapper used to aggregate
    # values: list of all value for that key
    # Note that we do *not* output a (key, value) pair here.

    # merge coresets 
    X = values[:,0:250]
    w = values[:,-1]
    # w = np.ones(X.shape[0])
    # print w.shape
    center = kmeanspp(X, K)
    # index = np.random.choice(values.shape[0], K)
    # center = X[index]
    print center.shape
    # center = d2sampling(values,K)
    n = center.shape[0]
    for j in range(50):
        x_w = np.zeros_like(center)
        nor = np.zeros_like(center)
        for i in range(len(X)):
            diff = np.sum((center - X[i])**2,axis=1)
            idx = diff.argmin()
            x_w[idx] += w[i] * X[i]
            # print (w*x).shape
            nor[idx] += w[i]
            # c = norm(centers - x, axis=2).argmin(axis=1)
        for i in range(n):
            if 0 not in nor[i]:
                center[i] = x_w[i] / nor[i]
    # compress the coreset 

    yield center
