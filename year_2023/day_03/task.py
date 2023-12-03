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
        start = 0
        for x, item in enumerate(line):
            if item.isnumeric():
                if num == "": start = x
                num += item
            elif num != "":
                res = test_for_part(data, y, num, start)
                sum += res
                num = ""
    return sum

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))