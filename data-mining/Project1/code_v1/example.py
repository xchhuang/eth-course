import numpy as np
import random

num_word = 8193

def hash_func(x, a, b):
	hash_val = (a * x + b) % num_word
	return hash_val

def mapper(key, value):
    # key: None
    # value: one line of input file
	doc = value.strip().split()
	doc_id = int(doc[0][5:-1])
	# print doc

	num_hash_func = 12
	M = np.ones(num_hash_func) * 10000
	a = random.sample(range(1, num_hash_func+1), num_hash_func);
	b = random.sample(range(1, num_hash_func+1), num_hash_func);

	for i in xrange(1, len(doc)):
		s = int(doc[i])
		for j in xrange(num_hash_func):
			h = hash_func(s, a[j], b[j])
			M[j] = min(M[j], h)
	# print M

	Bands = 3
	rows = num_hash_func / Bands
	for band in xrange(Bands):
		ax = random.sample(range(1, rows+1), rows);
		bx = random.sample(range(1, rows+1), rows);	
		band_hash = np.sum((ax * M[band*rows:band*rows+rows] + bx) % num_word)
		# print band_hash
		yield band, [band_hash, doc_id]
	if False:
		yield "key", "value"  # this is how you yield a key, value pair


def reducer(key, values):
    # key: key from mapper used to aggregate
    # values: list of all value for that key
	# print values
	n = len(values)
	# print values
	# print n
	for i in xrange(n-1):
		for j in xrange(i+1, n):
			if values[i][0] == values[j][0]:
				minn = min(values[i][1], values[j][1])
				maxn = max(values[i][1], values[j][1])
				yield minn, maxn
	if False:
		yield "key", "value"  # this is how you yield a key, value pair








