#!/usr/bin/env python3

with open("02/a.txt") as f:
    data = [l.split() for l in f]

depth = 0
horizontal = 0
aim = 0
for (dir, amount) in data:
    amount = int(amount)
    if dir == "forward":
        horizontal += amount
        depth += amount * aim
    elif dir == "up":
        aim -= amount
    elif dir == "down":
        aim += amount

print(depth*horizontal)