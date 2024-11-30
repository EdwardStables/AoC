#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_21/{fname}") as f:
        return [l.strip() for l in f]

class Point:
    def __init__(self, data, y, x, taken, repeat):
        self.data = data
        self.y = y
        self.x = x
        self.taken = taken
        self.repeat = repeat
    def next(self, limit):
        if self.taken >= limit:
            return []
        points = []
        if self.sample(self.y-1, self.x) != "#":
            points.append(Point(self.data, self.y-1,self.x,self.taken+1, self.repeat))
        if self.sample(self.y+1, self.x) != "#":
            points.append(Point(self.data, self.y+1,self.x,self.taken+1, self.repeat))
        if self.sample(self.y, self.x-1) != "#":
            points.append(Point(self.data, self.y,self.x-1,self.taken+1, self.repeat))
        if self.sample(self.y, self.x+1) != "#":
            points.append(Point(self.data, self.y,self.x+1,self.taken+1, self.repeat))
        return points
    def sample(self, y, x):
        if self.repeat:
            y %= len(self.data)
            x %= len(self.data[0])
        if y < 0 or x < 0 or y == len(self.data) or x == len(self.data[0]):
            return "#"
        return self.data[y][x]
    def __repr__(self):
        return f"{self.y} {self.x} {self.taken}"
    def __hash__(self):
        return hash(
            (
                self.x % len(self.data[0]),
                self.y % len(self.data),
                self.taken
            )
        )


def reach(point: Point, seen: set, limit: int, repeat=False):
    if hash(point) in seen:
        return []

    seen.add(hash(point))

    next = point.next(limit)
    if point.taken == limit - 1:
        s = set((n.y,n.x) for n in next)
        return s
    ends = set()
    for n in next:
        r = reach(n, seen, limit, repeat=repeat)
        ends = ends.union(r)
    return ends

def main_a(data):
    limit = 64 if len(data) > 12 else 6

    for y, line in enumerate(data):
        for x, char in enumerate(line):
            if char == "S":
                p = Point(data, y, x, 0, False)
                break
        else:
            continue
        break

    s = set()
    ends = reach(p, s, limit)    

    return len(ends)

def main_b(data):
    limit = 26501365 if len(data) > 12 else 100

    for y, line in enumerate(data):
        for x, char in enumerate(line):
            if char == "S":
                p = Point(data, y, x, 0, True)
                break
        else:
            continue
        break

    s = set()
    ends = reach(p, s, limit)

    return len(ends)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))