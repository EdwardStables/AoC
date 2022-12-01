#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_01/{fname}") as f:
        return [l.strip() for l in f]

def get_sums(data):
    sums = [0]

    for line in data:
        if line == "":
            sums.append(0)
        else:
            sums[-1] += int(line)
    return sums

def main_a(data):
    ma = 0 
    cur = 0
    for line in data:
        if line == "":
            if cur > ma:
                ma = cur 
            cur = 0 
        else:
            cur += int(line)
    return ma

def main_b(data):
    sums = sorted(get_sums(data))
    return sums[-1] + sums[-2] + sums[-3]

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))