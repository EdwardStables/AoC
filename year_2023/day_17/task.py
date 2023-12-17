#!/usr/bin/env python3
from collections import defaultdict

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_17/{fname}") as f:
        return [l.strip() for l in f]

class Point:
    def __init__(self, y, x, dir, dist, cost):
        self.y = y
        self.x = x
        #0 right
        #1 up
        #2 left
        #3 down
        self.dir = dir
        #0th, 1st, 2nd in a given direction
        self.dist = dist
        self.cost = cost
        self.parent = None
    def next(self, data):
        ps = [] 
        if self.y > 0 and not (self.dir==1 and self.dist == 2) and self.dir != 3:
            ps.append(Point(self.y-1, self.x, 1, 0 if self.dir != 1 else self.dist+1, 0))

        if self.y < len(data)-1 and not (self.dir==3 and self.dist == 2) and self.dir != 1:
            ps.append(Point(self.y+1, self.x, 3, 0 if self.dir != 3 else self.dist+1, 0))

        if self.x > 0 and not (self.dir==2 and self.dist == 2) and self.dir != 0:
            ps.append(Point(self.y, self.x-1, 2, 0 if self.dir != 2 else self.dist+1, 0))

        if self.x < len(data[0])-1 and not (self.dir==0 and self.dist == 2) and self.dir != 2:
            ps.append(Point(self.y, self.x+1, 0, 0 if self.dir != 0 else self.dist+1, 0))

        for p in ps:
            p.cost = self.cost + int(data[p.y][p.x])
            p.parent = self

        return ps
    def at(self, data):
        return data[self.y][self.x]
    def pos(self):
        return (self.y, self.x)
    def __hash__(self):
        return hash((self.y, self.x, self.dir, self.dist))
    def __repr__(self):
        s = f"{self.y} {self.x} "
        if self.dir == 0:
            s += ">"
        if self.dir == 1:
            s += "^"
        if self.dir == 2:
            s += "<"
        if self.dir == 3:
            s += "v"
        s += " " + str(self.dist)
        s += " " + str(self.cost)
        return s
        

def main_a(data):
    points = {}
    to_check = [
        Point(0,0,0,0,0),
        Point(0,0,3,0,0),
    ]
    for tc in to_check:
        points[hash(tc)] = tc

    last = None
    while len(to_check):
        l = len(to_check)
        point = to_check.pop(0)
        next = point.next(data)
        if point.y == len(data)-1 and point.x == len(data[0])-1 and \
            (last is None or point.cost < last.cost):
            last = point
        for p in next:
            if hash(p) not in points or\
                 p.cost < points[hash(p)].cost:
                points[hash(p)] = p
                to_check.append(p)

    path = set()
    next = last
    while next is not None:
        path.add(next.pos())
        next = next.parent

    for y in range(len(data)):
        s = ""
        for x in range(len(data[0])):
            if (y,x) in path:
                s += "#"
            else:
                s += data[y][x]


    #for y in range(len(data)):
    #    s = []
    #    for x in range(len(data[0])):
    #        s.append(points[(y,x)].cost)
    #    print(s)

    return last.cost

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))