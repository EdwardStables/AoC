#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_06/{fname}") as f:
        return [l.strip() for l in f][0]

def main_a(data):
    for i in range(len(data)-3):
        s = set(data[i:i+4])
        if len(s) == 4:
            return i+4

def main_b(data):
    for i in range(len(data)-13):
        s = set(data[i:i+14])
        if len(s) == 14:
            return i+14
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))