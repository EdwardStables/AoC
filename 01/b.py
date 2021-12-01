#!/usr/bin/env python3

with open("a.txt") as f:
    data = [int(l) for l in f]

increase = 0
tri = lambda ind: sum(data[ind-2 : ind+1])
last_tri = tri(2)
for i, _ in enumerate(data):
    if i in range(0, 3):
        continue
    new_tri = tri(i)
    if  new_tri > last_tri:
        increase += 1
    last_tri = new_tri

print(increase)
