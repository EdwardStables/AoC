#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_12/{fname}") as f:
        return [l.strip() for l in f]

def find_E_S(data):
    for y, row in enumerate(data):
        for x, element in enumerate(row):
            if element == "E":
                e = (x,y)
            if element == "S":
                s = (x,y)
    return e, s

def next(cur, data):
    cur, cost = cur
    cur_h = data[cur[1]][cur[0]]
    if cur_h == "S":
        cur_h = "a"
    if cur_h == "E":
        cur_h = "z"
    cur_h = ord(cur_h)

    adjacent = []    

    if cur[0] > 0:
        adjacent.append((cur[0]-1, cur[1]))
    if cur[0] < len(data[0])-1:
        adjacent.append((cur[0]+1, cur[1]))
    if cur[1] > 0:
        adjacent.append((cur[0], cur[1]-1))
    if cur[1] < len(data)-1:
        adjacent.append((cur[0], cur[1]+1))

    to_ret = []
    for a in adjacent:
        val = data[a[1]][a[0]]
        if val == "S":
           val = "a"
        if val == "E":
            val = "z"
        if ord(val)-1 <= cur_h:
            to_ret.append((a, cost+1))
    return to_ret

def start_to_end(start, end, data):
    done = {start:0}

    start = (start, 0)
    to_search = [start]

    while to_search:
        next_points = []
        for ts in to_search:
            new_point_list = next(ts, data)
            for point, cost in new_point_list:
                if point not in done:
                    next_points.append((point,cost))                

                if point in done and cost > done[point]:
                    continue
                done[point] = cost
        to_search = next_points
            
    return done.get(end, 1000)

def main_a(data):
    end, start = find_E_S(data)
    return start_to_end(start, end, data)

def main_b(data):
    end, start = find_E_S(data)

    min_dist = start_to_end(start, end, data)

    for y, row in enumerate(data):
        for x, col in enumerate(row):
            if col == "a":
                min_dist = min(start_to_end((x,y), end, data), min_dist)

    return min_dist

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))