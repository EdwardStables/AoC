#!/usr/bin/env python3

with open("a.txt") as f:
    data = [l.split() for l in f]

depth = 0
horizontal = 0
for (dir, amount) in data:
    amount = int(amount)
    if dir == "forward":
        horizontal += amount
    elif dir == "up":
        depth -= amount
    elif dir == "down":
        depth += amount

print(depth*horizontal)