#!/usr/bin/env python3
from collections import Counter

def get_data(fname = "data.txt"):
    with open(f"year_2021/day_06/{fname}") as f:
        return [l.strip() for l in f]

from timeit import default_timer as time
def main(data, day_limit):
    data = Counter(data[0].split(","))
    days = [data.get(d,0) for d in "012345678"]

    for end_day in range(day_limit):
        edm = end_day%9
        days[edm-2] += days[edm]

    return sum(days)

def main_a(data):
    return main(data, 80)

def main_b(data):
    return main(data, 256)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))