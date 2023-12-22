#!/usr/bin/env python3
from typing import Generator, Iterator

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_22/{fname}") as f:
        return [l.strip() for l in f]

class Point:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

    def __add__(self, other):
        return Point(self.x + other.x, self.y + other.y, self.z+other.z)

    def __eq__(self, other):
        return self.x == other.x and \
                self.y == other.y and \
                self.z == other.z
    
    def __repr__(self):
        return f"{self.x},{self.y},{self.z}"

class Brick:
    def __init__(self, p1: Point, p2: Point):
        self.strong_support = set()
        self.support = set()
        self.xsame = p1.x == p2.x
        self.ysame = p1.y == p2.y
        self.zsame = p1.z == p2.z
        if not self.xsame:
            if p1.x <= p2.x:
                self.p1 = p1
                self.p2 = p2
            else:
                self.p1 = p2
                self.p2 = p1
        elif not self.ysame:
            if p1.y <= p2.y:
                self.p1 = p1
                self.p2 = p2
            else:
                self.p1 = p2
                self.p2 = p1
        else:
            if p1.z <= p2.z:
                self.p1 = p1
                self.p2 = p2
            else:
                self.p1 = p2
                self.p2 = p1

    def contains(self, p: Point):
        if self.xsame and p.x != self.p1.x:
            return False
        if self.ysame and p.y != self.p1.y:
            return False
        if self.zsame and p.z != self.p1.z:
            return False

        if not self.xsame and self.p1.x <= p.x <= self.p2.x:
            return True
        if not self.ysame and self.p1.y <= p.y <= self.p2.y:
            return True
        if not self.zsame and self.p1.z <= p.z <= self.p2.z:
            return True

        return False
    
    def zmin(self):
        return self.p1.z
    def zmax(self):
        return self.p2.z
    def drop(self, count):
        self.p1.z -= count
        self.p2.z -= count
        assert self.p1.z >= 0
        assert self.p2.z >= 0

    def __repr__(self):
        return f"{self.p1}~{self.p2}"

    def xypoints(self)->Iterator[Point]:
        if not self.xsame:
            inc = Point(1, 0, 0)
        if not self.ysame:
            inc = Point(0, 1, 0)
        if not self.zsame:
            return self.p1

        point = self.p1
        while True:
            yield point
            if point == self.p2:
                break
            point += inc


def main_a(data):
    bricks = []
    for line in data:
        p1, p2 = line.split("~")
        p1 = Point(*[int(i) for i in p1.split(",")])
        p2 = Point(*[int(i) for i in p2.split(",")])
        bricks.append(Brick(p1, p2))

    bricks: list[Brick]

    #determine what is directly below
    for b in bricks:
        for p in b.xypoints():
            while p.z > 1:
                p += Point(0,0,-1)
                for b2 in bricks:
                    if b2.contains(p) and b2 not in b.support:
                        b.support.add(b2)
                        break
                else:
                    continue
                break

    changed = True
    while changed:
        changed = False
        for b in bricks:
            zmove = b.zmin()-1
            if zmove == 0: continue

            for b2 in b.support:
                zmove = min(zmove, b.zmin()-b2.zmax()-1)

            if zmove:
                b.drop(zmove)
                changed = True

    
    for b in bricks:
        for b2 in b.support:
            if b2.zmax() == b.zmin()-1:
                b.strong_support.add(b2)

    critical = set() 
    for b in bricks:
        print()
        print(b)
        print(b.support)
        print(b.strong_support)

    for b in bricks:
        if len(b.strong_support) == 1:
            critical.add(b.strong_support.pop())
    
    print(critical)

    return len(bricks) - len(critical)

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))