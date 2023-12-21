#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_21/{fname}") as f:
        return [l.strip() for l in f]

class Point:
    def __init__(self, y, x, taken):
        self.y = y
        self.x = x
        self.taken = taken
    def next(self, data, limit):
        if self.taken >= limit:
            return []
        points = []
        if self.y > 0 and data[self.y-1][self.x] != "#":
            points.append(Point(self.y-1,self.x,self.taken+1))
        if self.y < len(data)-1 and data[self.y+1][self.x] != "#":
            points.append(Point(self.y+1,self.x,self.taken+1))
        if self.x > 0 and data[self.y][self.x-1] != "#":
            points.append(Point(self.y,self.x-1,self.taken+1))
        if self.x < len(data[0])-1 and data[self.y][self.x+1] != "#":
            points.append(Point(self.y,self.x+1,self.taken+1))
        return points
    def __repr__(self):
        return f"{self.y} {self.x} {self.taken}"
    def __hash__(self):
        return hash((self.x,self.y,self.taken))


def reach(data, point: Point, seen: set, limit: int):
    if hash(point) in seen:
        return []

    seen.add(hash(point))

    next = point.next(data, limit)
    if point.taken == limit - 1:
        s = set((n.y,n.x) for n in next)
        return s
    ends = set()
    for n in next:
        r = reach(data, n, seen, limit)
        ends = ends.union(r)
    return ends

def main_a(data):
    limit = 64 if len(data) > 12 else 6

    for y, line in enumerate(data):
        for x, char in enumerate(line):
            if char == "S":
                p = Point(y, x, 0)
                break
        else:
            continue
        break

    s = set()
    ends = reach(data, p, s, limit)    

    return len(ends)

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))