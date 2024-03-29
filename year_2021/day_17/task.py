#!/usr/bin/env python3
from math import sqrt, ceil, floor
from time import time

def get_data(fname = "data.txt"):
    with open(f"year_2021/day_17/{fname}") as f:
        return [l.strip() for l in f]

def step(px, py, vx, vy):
    return px+vx, py+vy, max(vx-1,0), vy-1

def get_target(inp):
    s = inp[0].split(", ")
    x = map(int, s[0].split(' ')[-1].split("=")[1].split(".."))
    y = map(int, s[-1].split("=")[1].split(".."))
    return [*x, *y]
    
def main_a(data):
    # vertical level up and down will always be the same
    # so difference between start and bottom of the target would be the
    # maximum velocity
    _, _, ylow, _ = get_target(data)
    offset = -ylow-1
    return offset*(offset+1)//2

def calc_x_range(xlow, xhigh):
    #low
    sq = sqrt(1+8*xlow)
    xmin =  ceil(max(-0.5 + sq/2, -0.5 - sq/2))
    return xmin, xhigh

def main_b(data):
    xlow, xhigh, ylow, yhigh = get_target(data)
    xmin, xmax = calc_x_range(xlow, xhigh)
    ymin, ymax = ylow, -ylow

    count = 0
    for x in range(xmin, xmax+1):
        for y in range(ymin, ymax):
            px, py, vx, vy = 0, 0, x, y
            while py > ylow and px < xhigh:
                px, py, vx, vy = step(px, py, vx, vy) 
                if xlow <= px <= xhigh and ylow <= py <= yhigh:
                    count += 1
                    break

    return count

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))