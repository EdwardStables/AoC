#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2020/day_02/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    valid = 0
    for line in data:
        l = line.split()
        lo, hi = l[0].split("-")
        c = l[1][0]
        pwd: str = l[2]

        c = pwd.count(c)
        if int(lo) <= c <= int(hi):
            valid += 1

    return valid

def main_b(data):
    valid = 0
    for line in data:
        l = line.split()
        lo, hi = l[0].split("-")
        c = l[1][0]
        pwd: str = l[2]

        c1 = pwd[int(lo)-1]
        c2 = pwd[int(hi)-1]
        if (c1 == c) ^ (c2 == c):
            valid+=1

    return valid

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))