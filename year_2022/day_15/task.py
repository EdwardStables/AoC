#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_15/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    target = 2000000 if len(data)==23 else 10

    sensors = []
    beacons = []
    for line in data:
        l = line.split()
        sensors.append((int(l[2][2:-1]), int(l[3][2:-1])))
        beacons.append((int(l[8][2:-1]), int(l[9][2:])))

        
    ranges = []
    for s,b in zip(sensors, beacons):
        x_diff = b[0] - s[0]
        y_diff = b[1] - s[1]
        diff = abs(x_diff) + abs(y_diff)
        x_width = diff - abs(s[1]-target)
        if x_width <= 0:
            continue
        ranges.append((s[0]-x_width, s[0]+x_width))

    ranges.sort()
    cur_ind = 0
    while cur_ind < len(ranges)-1:
        if ranges[cur_ind][1] >= ranges[cur_ind+1][0]:
            if ranges[cur_ind+1][1] > ranges[cur_ind][1]:
                ranges[cur_ind] = (ranges[cur_ind][0], ranges[cur_ind+1][1])
            ranges.pop(cur_ind+1)
        else:
            cur_ind += 1

    sensors_on_target = set(s for s in sensors if s[1] == target)
    beacons_on_target = set(b for b in beacons if b[1] == target)

    to_add = 0
    for b in beacons_on_target:
        for r in ranges:
            if r[0] <= b[0] <= r[1]:
                to_add -= 1

    return sum(u-l+1 for l,u in ranges)+to_add

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))