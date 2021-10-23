import numpy as np
import random
import sys

num_word = 8193
num_hash_func = 1000
Bands = 50
rows = num_hash_func / Bands
bucket_num = np.sqrt(num_word)

# np.random.seed(0)

a = np.random.randint(0, sys.maxint, num_hash_func)
b = np.random.randint(0, sys.maxint, num_hash_func)
# np.save('a.npy',a)
# np.save('b.npy',b)
# a = np.load('a.npy')
# b = np.load('b.npy')


ax = []
bx = []

for i in xrange(Bands):
	ax.append(np.random.randint(0, sys.maxint, rows))
	bx.append(np.random.randint(0, sys.maxint, rows))
# np.save('ax.npy',ax)
# np.save('bx.npy',bx)
# ax = np.load('ax.npy')
# bx = np.load('bx.npy')

def hash_func(x, a, b):
	hash_val = (a * x + b) % num_word
	return hash_val

def mapper(key, value):
    # key: None
    # value: one line of input file
	doc = value.strip().split()
	# print doc[0],doc[0][5:]
	doc_id = int(doc[0][5:])
	
	M = np.ones(num_hash_func) * sys.maxint
	
	for i in xrange(1, len(doc)):
		s = int(doc[i])
		h = ((s * a + b) % num_word)
		M = np.minimum(M, h)
		

	for band in xrange(Bands):
		
		band_hash = np.sum(ax[band] * M[band*rows:band*rows+rows] + bx[band]) 
		
		yield band, [band_hash, doc[1:], doc_id]


def reducer(key, values):
    # key: key from mapper used to aggregate
    # values: list of all value for that key
	# print values
	n = len(values)

	for i in xrange(n-1):
		for j in xrange(i+1, n):
			if values[i][0] == values[j][0]:
				sigi = values[i][1]
				sigj = values[j][1]
				union = list(set(sigi).intersection(set(sigj)))
				jaccard = float(len(union)) / (len(sigi) + len(sigj) - len(union))
				if jaccard >= 0.85:
					if values[i][2] < values[j][2]:
						yield values[i][2], values[j][2]
					else:
						yield values[j][2], values[i][2]








