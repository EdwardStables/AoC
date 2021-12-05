#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_05/{fname}") as f:
        return [l.strip() for l in f]

def get_points(data):
    s,e = data.split(" -> ")
    s = s.split(",")
    sx = int(s[0])
    sy = int(s[1])
    e = e.split(",")
    ex = int(e[0])
    ey = int(e[1])
    return sx,sy,ex,ey

def interpolate(sx,sy,ex,ey):
    if (sx == ex) or (sy == ey):
        return interpolate_hv(sx,sy,ex,ey)
    else:
        return interpolate_d(sx,sy,ex,ey)

def interpolate_d(sx,sy,ex,ey):
    x_dir = 1 if ex > sx else -1
    y_dir = 1 if ey > sy else -1
    x = sx
    y = sy
    points = []
    for _ in range(abs(ey-sy) + 1):
        points.append((x,y))
        x += x_dir
        y += y_dir

    return points

def interpolate_hv(sx,sy,ex,ey):
    points = []
    if sx == ex: #vert
        y1 = min(sy, ey)
        y2 = max(sy, ey)
        for y in range(y1, y2+1):
            points.append((sx,y))
    elif sy == ey:
        x1 = min(sx, ex)
        x2 = max(sx, ex)
        for x in range(x1, x2+1):
            points.append((x,sy))

    return points

def main_a(data):
    point_list = {}
    high_count = 0
    for d in data:
        start_end = get_points(d)
        actual_points = interpolate_hv(*start_end)
        for p in actual_points:
            if p in point_list:
                if point_list[p] == 1:
                    point_list[p] = 2
                    high_count += 1

            else:
                point_list[p] = 1
    return high_count

def main_b(data):
    point_list = {}
    high_count = 0
    for d in data:
        start_end = get_points(d)
        actual_points = interpolate(*start_end)
        for p in actual_points:
            if p in point_list:
                if point_list[p] == 1:
                    point_list[p] = 2
                    high_count += 1

            else:
                point_list[p] = 1

    return high_count

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))