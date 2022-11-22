#!/usr/bin/env python3
from math import floor, ceil
from copy import deepcopy

def get_data(fname = "data.txt"):
    with open(f"year_2021/day_18/{fname}") as f:
        return [l.strip() for l in f]

class Node:
    def __init__(self, left, right):
        self.l = left
        self.r = right

def treeify(arr):
    if type(arr[0]) == type(arr[1]) == int:
        return Node(arr[0], arr[1])
    if type(arr[0]) == int:
        return Node(arr[0], treeify(arr[1]))
    if type(arr[1]) == int:
        return Node(treeify(arr[0]), arr[1])
    return Node(treeify(arr[0]), treeify(arr[1]))

def parse(data):
    return [treeify(eval(d)) for d in data]

def explode(n, depth):
    if depth == 4:
        cl = None
        cr = None
        exp = False
        if type(n.l) != int:
            add_to_left_of_right(n, n.l.r)
            cl = n.l.l
            n.l = 0
            exp = True
        elif type(n.r) != int:
            add_to_right_of_left(n, n.r.l)
            cr = n.r.r
            n.r = 0
            exp = True
        return cl, cr, exp

    fcl = None
    fcr = None
    fexp = False 
    if type(n.l) != int:
        cl, cr, exp = explode(n.l, depth+1)
        if cr:
            add_to_left_of_right(n, cr)
        fcl = cl
        fexp |= exp
    if not fexp and type(n.r) != int:
        cl, cr, exp = explode(n.r, depth+1)
        if cl:
            add_to_right_of_left(n, cl)
        fcr = cr 
        fexp |= exp

    return fcl, fcr, fexp

def add_to_left_of_right(n, ta):
    if type(n.r) == int:
        n.r += ta
    else:
        add_to_left(n.r, ta)

def add_to_right_of_left(n, ta):
    if type(n.l) == int:
        n.l += ta
    else:
        add_to_right(n.l, ta)

def add_to_right(n, ta):
    if type(n.r) == int:
        n.r += ta
    else:
        add_to_right(n.r, ta)
    
def add_to_left(n, ta):
    if type(n.l) == int:
        n.l += ta
    else:
        add_to_left(n.l, ta)

def split(n):
    if type(n.l) == int:
        if n.l > 9:
            n.l = Node(floor(n.l/2), ceil(n.l/2)) 
            return True
    else:
        if split(n.l):
            return True
    if type(n.r) == int:
        if n.r > 9:
            n.r = Node(floor(n.r/2), ceil(n.r/2)) 
            return True
    else:
        if split(n.r):
            return True
    

def magnitude(n):
    if type(n) == int:
        return n
    return 3*magnitude(n.l) + 2*magnitude(n.r)

def reduce(num):
    while True:
        _, _, exp = explode(num, 1)
        if exp:
            continue        
        if split(num):
            continue
        break
    return num

def leafs(n, end=True):
    if type(n.l) == int:
        print(n.l, end=" ")
    else:
        leafs(n.l, end=False)
    if type(n.r) == int:
        print(n.r, end=" ")
    else:
        leafs(n.r, end=False)

    if end:
        print()
    
def main_a(data):
    data = parse(data)
    active = data[0]
    next = 1
    while next < len(data):
        active = Node(active, data[next])
        active = reduce(active)
        next += 1

    return magnitude(active)

def main_b(data):
    arrs = [eval(d) for d in data]
    max_mag = 0

    for i in range(len(data)):
        for j in range(len(data)):
            if i == j:
                continue
            max_mag = max(max_mag, magnitude(reduce(Node(treeify(arrs[i]), treeify(arrs[j])))))

    return max_mag 

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))




