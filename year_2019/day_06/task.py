#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2019/day_06/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    return 0

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))