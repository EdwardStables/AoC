#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2020/day_05/{fname}") as f:
        return [l.strip() for l in f]

def get_id(data):
    rmi = 0
    rma = 127
    cmi = 0
    cma = 7
    for i, v in enumerate(data):
        if i < 7:
            diff = ((rma - rmi) // 2) + 1
            if v == 'F':
                rma -= diff
            else:
                rmi += diff
        else:
            diff = ((cma - cmi) // 2) + 1
            if v == 'L':
                cma -= diff
            else:
                cmi += diff

    return rmi * 8 + cmi

def main_a(data):
    max_id = 0
    for row in data:
        if (id := get_id(row)) > max_id:
            max_id = id

    return max_id

def main_b(data):
    ids = sorted([get_id(r) for r in data])
    for i, v in enumerate(ids):
        if ids[i+1] != v+1:
            return v+1

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))