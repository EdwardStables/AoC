#!/usr/bin/env python3.9
from copy import copy
from functools import cache

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_12/{fname}") as f:
        return [l.strip() for l in f]

@cache
def run_pattern(pattern: str, remaining: tuple[int], in_pattern):
    if len(pattern) == 0:
        return int(len(remaining) == 0 or len(remaining) == 1 and remaining[0] == 0)

    if in_pattern:
        if len(remaining) > 0 and remaining[0] != 0:
            if pattern[0] == ".":
                return 0

    if pattern[0] == ".":
        if len(remaining) > 0 and remaining[0] == 0:
            remaining = remaining[1:]
        return run_pattern(pattern[1:], remaining, False)
    
    if pattern[0] == "#":
        if len(remaining) == 0 or remaining[0] == 0: return 0
        return run_pattern(pattern[1:], (remaining[0]-1,) + remaining[1:], True)

    if pattern[0] == "?":
        return run_pattern("#" + pattern[1:], remaining, in_pattern) +\
               run_pattern("." + pattern[1:], remaining, in_pattern)

    assert False


def run(data):
    s = 0
    for lineno, (pattern, widths) in enumerate(data):
        r = run_pattern(pattern, widths, False)
        s += r
    return s

def main_a(data):
    new_data = []
    for line in data:
        pattern, widths = line.split()
        widths = tuple(int(i) for i in widths.split(","))
        new_data.append((pattern, widths))
    return run(new_data)

def main_b(data):
    new_data = []
    for line in data:
        pattern, widths = line.split()
        pattern = "?".join([pattern]*5)
        widths = tuple([int(i) for i in widths.split(",")]*5)
        new_data.append((pattern, widths))
    return run(new_data)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))