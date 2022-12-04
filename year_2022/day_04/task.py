#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_04/{fname}") as f:
        return [l.strip() for l in f]

def get_range(r):
    l, h = r.split("-")
    return int(l), int(h)

def main_a(data: list[str]):
    contain = 0
    for line in data:
        fr0, fr1, sr0, sr1  = map(int, line.replace("-",",").split(","))
        if fr0 <= sr0 and fr1 >= sr1 or\
           fr0 >= sr0 and fr1 <= sr1:
           contain += 1

    return contain 

def main_b(data):
    overlap = 0
    for line in data:
        fr0, fr1, sr0, sr1  = map(int, line.replace("-",",").split(","))
        if fr1 < sr0 or fr0 > sr1:
            pass
        else:
            overlap += 1

    return overlap

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))