#!/usr/bin/env python3
import sys

bagof = []
candidates = {}
for line in sys.stdin:
    ingrs, allergens = line.strip()[0:-1].split(' (contains ')
    words = ingrs.split(' ')
    bagof += words
    for allergen in allergens.split(', '):
        if allergen in candidates:
            candidates[allergen] = candidates[allergen].intersection(set(words))
        else:
            candidates[allergen] = set(words)

adict = {}
while(len(adict) < len(candidates)):
    # find the allergen with only one candidate
    for k, v in candidates.items():
        if len(v) == 1:
            break

    word = list(v)[0]
    adict[k] = word
    for k, v in candidates.items():
        if word in v:
            v.remove(word)

for k, v in adict.items():
    bagof = [b for b in bagof if b != v]

print('one=', len(bagof))
print('two=', ','.join(adict[k] for k in sorted(adict)))
