#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_16/{fname}") as f:
        return [l.strip() for l in f]

class Point:
    def __init__(self, y, x, dir=0):
        self.y = y
        self.x = x
        #0 right
        #1 up
        #2 left
        #3 down
        self.dir = dir
    def next(self, data):
        if self.at(data) == ".":
            if self.dir == 0:
                return Point(self.y, self.x+1, self.dir)
            if self.dir == 1:
                return Point(self.y-1, self.x, self.dir)
            if self.dir == 2:
                return Point(self.y, self.x-1, self.dir)
            if self.dir == 3:
                return Point(self.y+1, self.x, self.dir)
        if self.at(data) == "\\":
            if self.dir == 0:
                return Point(self.y+1, self.x, 3)
            if self.dir == 1:
                return Point(self.y, self.x-1, 2)
            if self.dir == 2:
                return Point(self.y-1, self.x, 1)
            if self.dir == 3:
                return Point(self.y, self.x+1, 0)
        if self.at(data) == "/":
            if self.dir == 0:
                return Point(self.y-1, self.x, 1)
            if self.dir == 1:
                return Point(self.y, self.x+1, 0)
            if self.dir == 2:
                return Point(self.y+1, self.x, 3)
            if self.dir == 3:
                return Point(self.y, self.x-1, 2)
        if self.at(data) == "-":
            if self.dir == 0:
                return Point(self.y, self.x+1, self.dir)
            if self.dir in [1,3]:
                return [Point(self.y, self.x-1, 2),Point(self.y, self.x+1, 0)]
            if self.dir == 2:
                return Point(self.y, self.x-1, self.dir)
        if self.at(data) == "|":
            if self.dir in [0,2]:
                return [Point(self.y-1, self.x, 1),Point(self.y+1, self.x, 3)]
            if self.dir == 1:
                return Point(self.y-1, self.x, self.dir)
            if self.dir == 3:
                return Point(self.y+1, self.x, self.dir)
    def at(self, data):
        return data[self.y][self.x]
    def __repr__(self):
        s = f"{self.y} {self.x} "
        if self.dir == 0:
            return s + ">"
        if self.dir == 1:
            return s + "^"
        if self.dir == 2:
            return s + "<"
        if self.dir == 3:
            return s + "v"

def energised(data, start_point):
    s = 1
    points = [start_point]
    p0 = points[0]
    seen = {p0.x : {p0.y : set([p0.dir])}}
    while len(points):
        p = points.pop(0)
        np = p.next(data)
        np = np if type(np) == list else [np]

        for npp in np:
            if npp.x >= len(data[0]) or npp.x < 0 or\
               npp.y >= len(data) or npp.y < 0:
                continue
            if npp.x in seen and npp.y in seen[npp.x] and npp.dir in seen[npp.x][npp.y]:
                continue
            if npp.x not in seen:
                seen[npp.x] = {}
            if npp.y not in seen[npp.x]:
                seen[npp.x][npp.y] = set()
                s += 1
            
            seen[npp.x][npp.y].add(npp.dir)
            points.append(npp)

    return s
def main_a(data):
    s = energised(data, Point(0,0,0))
    #for y, row in enumerate(data):
    #    r = ""
    #    for x, _ in enumerate(row):
    #        if x in seen and y in seen[x]:
    #            r += "#"
    #        else:
    #            r += "."
    #    print(r)
    return s

def main_b(data):
    max_val = 0

    for x in range(len(data[0])):
        max_val = max(max_val, energised(data, Point(0, x, 3)))
    for x in range(len(data[0])):
        max_val = max(max_val, energised(data, Point(len(data)-1, x, 1)))
    for y in range(len(data)):
        max_val = max(max_val, energised(data, Point(y, 0, 0)))
    for y in range(len(data)):
        max_val = max(max_val, energised(data, Point(y, len(data[0])-1, 2)))

    return max_val

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))