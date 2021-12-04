#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_02/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    data = [d.split() for d in data]
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
    
    return depth * horizontal

def main_b(data):
    data = [d.split() for d in data]
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

    return (depth*horizontal)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))