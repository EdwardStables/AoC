#!/usr/bin/env python3
from dataclasses import dataclass
from copy import copy

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_09/{fname}") as f:
        return [l.strip() for l in f]

@dataclass
class Pos:
    x: int
    y: int

    def __add__(self, other):
        self.x += other.x
        self.y += other.y
        return self

    def __repr__(self):
        return f"[{self.x},{self.y}]"

    def __sub__(self, other):
        self.x += other.x
        self.y += other.y
        return self

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

    def dist(self, other):
        return Pos(self.x-other.x, self.y-other.y)

def main_a(data):
    visited = [(0,0)]
    tpos = Pos(0,0)
    hpos = Pos(0,0)

    for i, line in enumerate(data):
        dir, dist = line.split()
        for _ in range(int(dist)):
            hpos += Pos(1,0) if dir=="R" else \
                    Pos(-1,0) if dir=="L" else \
                    Pos(0,1) if dir=="U" else Pos(0,-1)
            d = hpos.dist(tpos)
            if d.x > 1 or (d.x == 1 and abs(d.y) > 1):
                tpos.x += 1
            elif d.x < -1 or (d.x == -1 and abs(d.y) > 1):
                tpos.x -= 1
            if d.y > 1 or (d.y == 1 and abs(d.x) > 1):
                tpos.y += 1
            elif d.y < -1 or (d.y == -1 and abs(d.x) > 1):
                tpos.y -= 1
            visited.append((tpos.x, tpos.y))

    return len(set(visited))

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))