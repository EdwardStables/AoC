#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_13/{fname}") as f:
        return [l.strip() for l in f]

class Point:
    def __init__(self, x, y):
        self.x = int(x)
        self.y = int(y)
    def __repr__(self):
        return f"({self.x}, {self.y})"
    def set(self, dim, val):
        if dim == 0:
            self.x = val
        elif dim == 1:
            self.y = val
    def modify(self, dim, val):
        if dim == 0:
            self.x += val
        elif dim == 1:
            self.y += val
    def __getitem__(self, item):
        if item == 0:
            return self.x
        elif item == 1:
            return self.y
        else:
            return None
    def __eq__(self, other):
        return self.x == other.x and self.y == other.y
    def __hash__(self):
        return hash((self.x, self.y))
    
def get_size(points):
    max_x = 0
    max_y = 0

    for p in points:
        if p.x > max_x:
            max_x = p.x
        if p.y > max_y:
            max_y = p.y

    return max_x, max_y

def parse_data(data):
    points = []
    folds = []

    for line in data:
        if ',' in line:
            points.append(Point(*line.split(",")))
        if "x=" in line:
            folds.append((0, int(line.split("=")[-1])))
        if "y=" in line:
            folds.append((1, int(line.split("=")[-1])))

    return points, folds

def fold(points, fold_dim, fold_line):
    for p in points:
        diff = fold_line - p[fold_dim]
        if diff < 0:
            p.modify(fold_dim, 2*diff)

    return points

def main_a(data):
    points, folds = parse_data(data)
    return len(set(fold(points, *folds[0])))

def main_b(data):
    points, folds = parse_data(data)
    for f in folds:
        points = fold(points, *f)

    mx,my = get_size(points)
    points = set(points)
    out = "\n"
    for y in range(my+1):
        for x in range(mx+1):
            if Point(x, y) in points:
                out += "#"
            else: 
                out += "."
        out += "\n"
    return out

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))