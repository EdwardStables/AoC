#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_14/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    lines = []
    for l in data:
        l = l.split(" -> ")
        l = [tuple(map(int, k.split(","))) for k in l]
        for i, a in enumerate(l[:-1]):
            b = l[i+1] 
            lines.append((a[0], b[0], a[1], b[1]))

    taken_points = set()
    for line in lines:
        if line[0] == line[1]:
            mi = min(line[2], line[3])
            ma = max(line[2], line[3])
            for k in range(mi, ma+1):
                taken_points.add((line[0], k))
        if line[2] == line[3]:
            mi = min(line[0], line[1])
            ma = max(line[0], line[1])
            for k in range(mi, ma+1):
                taken_points.add((k, line[2]))
    
    max_y = max(k[1] for k in taken_points)    
    min_x = min(k[0] for k in taken_points)    
    max_x = max(k[0] for k in taken_points)    

    count = 0
    active_sand = (500,0)
    while True:
        next_point = (active_sand[0], active_sand[1]+1)
        if next_point in taken_points:
            next_point = (active_sand[0]-1, active_sand[1]+1)
        if next_point in taken_points:
            next_point = (active_sand[0]+1, active_sand[1]+1)

        if next_point[0] < min_x or next_point[0] > max_x or next_point[1] > max_y:
            break

        if next_point in taken_points:
            count += 1
            taken_points.add(active_sand)
            active_sand = (500,0)
        else:
            active_sand = next_point
    
    return count

def main_b(data):
    lines = []
    for l in data:
        l = l.split(" -> ")
        l = [tuple(map(int, k.split(","))) for k in l]
        for i, a in enumerate(l[:-1]):
            b = l[i+1] 
            lines.append((a[0], b[0], a[1], b[1]))

    taken_points = set()
    for line in lines:
        if line[0] == line[1]:
            mi = min(line[2], line[3])
            ma = max(line[2], line[3])
            for k in range(mi, ma+1):
                taken_points.add((line[0], k))
        if line[2] == line[3]:
            mi = min(line[0], line[1])
            ma = max(line[0], line[1])
            for k in range(mi, ma+1):
                taken_points.add((k, line[2]))
    
    floor = max(k[1] for k in taken_points) + 2

    count = 0
    active_sand = (500,0)
    while True:
        next_point = (active_sand[0], active_sand[1]+1)
        if next_point in taken_points or next_point[1] == floor:
            next_point = (active_sand[0]-1, active_sand[1]+1)
        if next_point in taken_points or next_point[1] == floor:
            next_point = (active_sand[0]+1, active_sand[1]+1)

        if next_point in taken_points and active_sand == (500, 0):
            count += 1
            break

        if next_point in taken_points or next_point[1] == floor:
            count += 1
            taken_points.add(active_sand)
            active_sand = (500,0)
        else:
            active_sand = next_point
    
    return count


if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))