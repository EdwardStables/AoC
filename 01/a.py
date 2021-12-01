#!/usr/bin/env python3

with open("a.txt") as f:
    data = [int(l) for l in f]

increase = 0
for i, v in enumerate(data):
    if i == 0:
        continue
    if data[i-1] < v:
        increase += 1

print(increase)
