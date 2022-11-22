#!/usr/bin/env python3
from timeit import default_timer as dt

def get_data(fname = "data.txt"):
    with open(f"year_2021/day_05/{fname}") as f:
        return [l.strip() for l in f]

def get_points(data):
    s,e = data.split(" -> ")
    s = s.split(",")
    sx, sy = int(s[0]), int(s[1])
    e = e.split(",")
    ex, ey = int(e[0]), int(e[1])
    return sx,sy,ex,ey

def interpolate(sx,sy,ex,ey):
    if (sx == ex) or (sy == ey):
        return interpolate_hv(sx,sy,ex,ey)
    else:
        return interpolate_d(sx,sy,ex,ey)

def interpolate_d(sx,sy,ex,ey):
    x_dir = 1 if ex > sx else -1
    y_dir = 1 if ey > sy else -1
    return [p for p in zip(range(sx,ex+x_dir,x_dir),range(sy,ey+y_dir,y_dir))]

def interpolate_hv(sx,sy,ex,ey):
    if sx == ex: #vert
        y_dir = 1 if ey > sy else -1
        return [(sx,y) for y in range(sy, ey+y_dir,y_dir)]
    elif sy == ey:
        x_dir = 1 if ex > sx else -1
        return [(x,sy) for x in range(sx, ex+x_dir,x_dir)]
    else:
        return []

def main(data, interp_func):
    point_list = {}
    high_count = 0
    for d in data:
        start_end = get_points(d)
        actual_points = interp_func(*start_end)
        for p in actual_points:
            if p in point_list:
                if point_list[p] == 1:
                    point_list[p] = 2
                    high_count += 1

            else:
                point_list[p] = 1
    return high_count

def main_a(data):
    return main(data, interpolate_hv)

def main_b(data):
    return main(data, interpolate)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))