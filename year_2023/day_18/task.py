#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_18/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    current = (0,0)
    edges = set([current])
    minx = 0
    miny = 0
    maxx = 0
    maxy = 0
    for line in data:
        d, l, _ = line.split()
        l = int(l)
        for _ in range(l):
            if d == "R":
                current = (current[0]+1,current[1])
            if d == "L":
                current = (current[0]-1,current[1])
            if d == "U":
                current = (current[0],current[1]+1)
            if d == "D":
                current = (current[0],current[1]-1)
            if current[0] < minx:
                minx = current[0]
            if current[0] > maxx:
                maxx = current[0]
            if current[1] < miny:
                miny = current[1]
            if current[1] > maxy:
                maxy = current[1]

            edges.add(current)

    for y in range(maxy, miny-1, -1):
        for x in range(minx, maxx-1):
            if (x, y) not in edges and \
               (x+1, y) in edges and \
               (x+2, y) not in edges:
                ff_start = (x+2, y)
                break
        else:
            continue
        break

    inside = set([ff_start])
    ff_queue = [ff_start]

    while len(ff_queue):
        f = ff_queue.pop(0)

        next = [
            (f[0]+1,f[1]),
            (f[0]-1,f[1]),
            (f[0],f[1]+1),
            (f[0],f[1]-1)
        ]

        for n in next:
            if n in inside or n in edges:
                continue
            inside.add(n)
            ff_queue.append(n)

    return len(edges) + len(inside)

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))