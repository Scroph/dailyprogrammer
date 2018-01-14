#https://redd.it/7p5p2o
import itertools
import sys

def numerize(string, mapping):
	result = 0
	offset = len(string) - 1
	for i, letter in enumerate(string):
		result += 10 ** (offset - i) * mapping[letter]
	return result

def is_valid(left, right, mapping):
	expected = numerize(right, mapping)
	current = 0
	for word in left:
		current += numerize(word, mapping)
		if current > expected:
			return False
	return current == expected
#return sum(numerize(word, mapping) for word in left) == numerize(right, mapping)

def solve(left, right):
	letters = set(letter for letter in ''.join(left) + right)
	numbers = range(0, 10)

	for permutation in itertools.permutations(numbers, len(letters)):
		mapping = {}
		for letter, number in zip(letters, permutation):
			mapping[letter] = number
		if mapping[right[0]] == 0:
			continue
		if is_valid(left, right, mapping):
			return mapping
	return {}

for line in sys.stdin.readlines():
	data = [word for word in line.strip()[1:-1].split(' ') if word.isalpha()]
	left, right = data[0:-1], data[-1]
	print 'Solving for ' + line[:-1]
	print solve(left, right)
	print
