#!/usr/bin/env python3

with open("03/data.txt") as f:
    data = f.readlines()

data = [d.strip() for d in data]
WIDTH=len(data[0])

counters = [0 for _ in range(WIDTH)]

for num in data:
    for i, v in enumerate(num):
        if v == "1":
            counters[i]+=1
        else:
            counters[i]-=1

gamma = int(''.join(["1" if c > 0 else "0" for c in counters]), base=2)
epsilon = int(''.join(["0" if c > 0 else "1" for c in counters]), base=2)

print(gamma * epsilon)




