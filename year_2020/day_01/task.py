#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2020/day_01/{fname}") as f:
        d = [l.strip() for l in f]
        return d

def get_target(target, data):
    #data must be sorted
    #return a and b if they sum to target
    #else return None
    i = 0
    j = len(data)-1

    while i <= j:
        r = data[i] + data[j] 
        if r == target:
            return data[i], data[j]
        if r < target:
            i += 1
        else:
            j -= 1

    return None


def main_a(data):
    d = sorted([int(i) for i in data])
    a, b = get_target(2020, d)
    return a*b

def main_b(data):
    d = sorted([int(i) for i in data])
    for i, t in enumerate(d):
        res = get_target(2020-t, d[:i] + d[i+1:])
        if res is not None:
            return res[0] * res[1] * t
    return -1

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))