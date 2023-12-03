#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_03/{fname}") as f:
        return [l.strip() for l in f]

def test_for_part(data, y, num, start):
    if y > 0:
        for x in range(max(0,start-1), min(start+len(num)+1, len(data[0]))):
            if data[y-1][x] != "." and not data[y-1][x].isnumeric():
                return int(num)
    if start > 0:
        if data[y][start-1] != "." and not data[y][start-1].isnumeric():
            return int(num)

    if start + len(num) < len(data[0]):
        if data[y][start+len(num)] != "." and not data[y][start+len(num)].isnumeric():
            return int(num)

    if y < len(data)-1:
        for x in range(max(0,start-1), min(start+len(num)+1, len(data[0]))):
            if data[y+1][x] != "." and not data[y+1][x].isnumeric():
                return int(num)
    return 0

def main_a(data):
    sum = 0
    for y, line in enumerate(data):
        nums = []
        num = ""
        for x, item in enumerate(line):
            if item.isnumeric():
                if num == "": start = x
                num += item
            elif num != "":
                res = test_for_part(data, y, num, start)
                sum += res
                num = ""

        if num != "":
            res = test_for_part(data, y, num, start)
            sum += res
    return sum

def getnum(data,x):
    num = data[x]
    _x = x-1
    while _x >= 0 and data[_x].isnumeric():
        num = data[_x] + num
        _x -= 1
    _x = x+1
    while _x < len(data) and data[_x].isnumeric():
        num = num + data[_x]
        _x += 1

    return int(num)


def get_ratio(data, y, x):
    n = []
    if x > 0:
        if data[y][x-1].isnumeric():
            res = getnum(data[y],x-1)
            n.append(res)
    if x < len(data[0])-1:
        if data[y][x+1].isnumeric():
            res = getnum(data[y],x+1)
            n.append(res)

    if y > 0:
        #check middle
        if not data[y-1][x].isnumeric():
            if data[y-1][x-1].isnumeric():
                res = getnum(data[y-1],x-1)
                n.append(res)
            if data[y-1][x+1].isnumeric():
                res = getnum(data[y-1],x+1)
                n.append(res)
        else:
            res = getnum(data[y-1],x)
            n.append(res)

    if y < len(data)-1:
        #check middle
        if not data[y+1][x].isnumeric():
            if data[y+1][x-1].isnumeric():
                res = getnum(data[y+1],x-1)
                n.append(res)
            if data[y+1][x+1].isnumeric():
                res = getnum(data[y+1],x+1)
                n.append(res)
        else:
            res = getnum(data[y+1],x)
            n.append(res)

    if len(n) == 2:
        return n[0] * n[1]
    return 0

def main_b(data):
    sum = 0
    for y, line in enumerate(data):
        for x, item in enumerate(line):
            if item == "*":
                sum += get_ratio(data,y,x)

    return sum

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))