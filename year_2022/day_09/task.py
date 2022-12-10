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
    tpos = [0,0]
    hpos = [0,0]

    for i, line in enumerate(data):
        dir, dist = line.split()
        for _ in range(int(dist)):
            if dir == "L":
                hpos[0] += 1
            if dir == "R":
                hpos[0] -= 1
            if dir == "U":
                hpos[1] += 1
            if dir == "D":
                hpos[1] -= 1

            dx = hpos[0]-tpos[0]
            dy = hpos[1]-tpos[1]

            if dx > 1 or (dx == 1 and abs(dy) > 1):
                tpos[0] += 1
            elif dx < -1 or (dx == -1 and abs(dy) > 1):
                tpos[0] -= 1
            if dy > 1 or (dy == 1 and abs(dx) > 1):
                tpos[1] += 1
            elif dy < -1 or (dy == -1 and abs(dx) > 1):
                tpos[1] -= 1
            visited.append((tpos[0], tpos[1]))

    return len(set(visited))

def main_b(data):
    visited = [(0,0)]
    pos = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
    
    for i, line in enumerate(data):
        dir, dist = line.split()
        for _ in range(int(dist)):
            local_dir = dir
            if local_dir == "L":
                pos[0][0] += 1
            if local_dir == "R":
                pos[0][0] -= 1
            if local_dir == "U":
                pos[0][1] += 1
            if local_dir == "D":
                pos[0][1] -= 1
            for i, seg in enumerate(pos[:-1]): 
                dx = seg[0]-pos[i+1][0]
                dy = seg[1]-pos[i+1][1]

                move = False
                if dx > 1 or (dx == 1 and abs(dy) > 1):
                    move = True
                    local_dir = "L"
                    pos[i+1][0] += 1
                elif dx < -1 or (dx == -1 and abs(dy) > 1):
                    move = True
                    local_dir = "R"
                    pos[i+1][0] -= 1
                if dy > 1 or (dy == 1 and abs(dx) > 1):
                    move = True
                    local_dir = "U"
                    pos[i+1][1] += 1
                elif dy < -1 or (dy == -1 and abs(dx) > 1):
                    move = True
                    local_dir = "D"
                    pos[i+1][1] -= 1

                if not move:
                    break

                if i == len(pos) - 2:
                    visited.append((pos[i+1][0], pos[i+1][1]))

    return len(set(visited))

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))