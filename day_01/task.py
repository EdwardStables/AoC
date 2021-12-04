#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_01/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    data = [int(d) for d in data]
    increase = 0
    for i, v in enumerate(data):
        if i == 0:
            continue
        if data[i-1] < v:
            increase += 1

    return increase

def main_b(data):
    data = [int(d) for d in data]
    increase = 0
    tri = lambda ind: sum(data[ind-2 : ind+1])
    last_tri = tri(2)
    for i, _ in enumerate(data):
        if i in range(0, 3):
            continue
        new_tri = tri(i)
        if  new_tri > last_tri:
            increase += 1
        last_tri = new_tri
    return increase

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))