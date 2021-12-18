#!/usr/bin/env python3
from math import floor, ceil
from copy import deepcopy

def get_data(fname = "data.txt"):
    with open(f"day_18/{fname}") as f:
        return [l.strip() for l in f]

def parse(data):
    return [eval(d) for d in data]

def explode(num):
    return False if explode_rec(num, 1) == False else True

def add_next(num, to_add):
    if type(num[0]) == int:
        num[0] += to_add
    else:
        add_next(num[0], to_add)

def add_prev(num, to_add):
    if type(num[-1]) == int:
        num[-1] += to_add
    else:
        add_prev(num[-1], to_add)

def explode_rec(num, depth):
    if depth == 5:
        a, b = num
        return a, b, True
    else:
        for i, n in enumerate(num):
            if type(n) == list:
                res = explode_rec(n, depth+1)
                if res == False:
                    continue
                a = res[0]
                b = res[1]
                set_0 = res[2]
                if i > 0:
                    if type(num[i-1]) == int:
                        num[i-1] += a
                    else:
                        add_prev(num[i-1], a)
                    a = 0
                if i < len(num) - 1:
                    if type(num[i+1]) == int:
                        num[i+1] += b
                    else:
                        add_next(num[i+1], b)
                    b = 0
                if set_0:
                    num[i] = 0
                return a, b, False
    return False

def split(num):
    for i, n in enumerate(num):
        if type(n) == list:
            if split(n):
                return True
        else:
            if n > 9:
                num[i] = [floor(n/2), ceil(n/2)]
                return True
    return False

def magnitude(num):
    a = num[0]
    b = num[1]
    if type(a) != int:
        a = magnitude(a)
    if type(b) != int:
        b = magnitude(b)
    return 3*a + 2*b

def reduce(num):
    while True:
        if explode(num):
            continue
        if split(num):
            continue
        break
    return num

def main_a(data):
    data = parse(data)
    active = data[0]
    next = 1
    
    while next < len(data):
        active = reduce([active, data[next]])
        next += 1

    return magnitude(active)

def main_b(data):
    data = parse(data)
    max_mag = 0

    for i in range(len(data)):
        for j in range(len(data)):
            if i == j:
                continue
            max_mag = max(max_mag, magnitude(reduce([deepcopy(data[i]), deepcopy(data[j])])))
        

    return max_mag 

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))