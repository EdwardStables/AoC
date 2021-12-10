#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_09/{fname}") as f:
        return [l.strip() for l in f]

def next(pos, width, height, step=1):
    if pos[0] == width-1:
        if pos[1] == height-1:
            return None
        else:
            return [0, pos[1]+1]
    else:
        return [pos[0]+1, pos[1]]

def is_low(data, pos, width, height):
    current = data[pos[0]][pos[1]]
    if pos[0] > 0:
        if current >= (cmp := data[pos[0]-1][pos[1]]):
            return False
    if pos[0] < width-1:
        if current >= (cmp := data[pos[0]+1][pos[1]]):
            return False
    if pos[1] > 0:
        if current >= (cmp := data[pos[0]][pos[1]-1]):
            return False
    if pos[1] < height-1:
        if current >= (cmp := data[pos[0]][pos[1]+1]):
            return False

    return True
        

def get_low_points(data):
    height = len(data[0])
    width = len(data)
    points = []
    current_pos = [0,0]
    while (next_pos := next(current_pos, width, height)) is not None:
        if is_low(data, current_pos, width, height):
            points.append(current_pos)
        current_pos = next_pos
    return points

def parse(data):
    return [list(map(int, d)) for d in data] 

def main_a(data):
    data = parse(data)
    risk = 0
    for p in get_low_points(data):
        risk += 1 + data[p[0]][p[1]]
    return risk

class Point:
    def __init__(self, x, y, depth):
        self.x = x
        self.y = y
        self.depth = depth

    def __repr__(self):
        return f"({self.x}, {self.y})"

class Basin:
    def __init__(self, lp: Point):
        self.lp = lp
        self.size = 1
        self.outer = [lp]
        self.points = []
    
    def expand(self, data):
        self.points.extend(self.outer)
        new_outer = []
        for p in self.outer:
            for trial in get_adjacent(p, data):
                if trial.depth != 9 and not list_contains_point(new_outer, trial) and not list_contains_point(self.points, trial):
                    new_outer.append(trial)
                    self.size += 1
        self.outer = new_outer
        return len(self.outer) > 0

def list_contains_point(lst, p):
    for l in lst:
        if l.x == p.x and l.y == p.y:
            return True
    return False

def get_adjacent(p: Point, data):
    ps = []
    if p.x > 0:
        ps.append(Point(p.x-1,p.y,data[p.x-1][p.y]))
    if p.x < len(data)-1:
        ps.append(Point(p.x+1,p.y,data[p.x+1][p.y]))
    if p.y > 0:
        ps.append(Point(p.x,p.y-1,data[p.x][p.y-1]))
    if p.y < len(data[0])-1:
        ps.append(Point(p.x,p.y+1,data[p.x][p.y+1]))
    return ps

def main_b(data):
    data = parse(data)
    low_points = get_low_points(data)
    basins = [Basin(Point(lp[0], lp[1], data[lp[0]][lp[1]])) for lp in low_points]


    for b in basins:
        while b.expand(data):
            continue

    sizes = [b.size for b in basins]
    sizes.sort()
    return sizes[-3] * sizes[-2] * sizes[-1]

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))