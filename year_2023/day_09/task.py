#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_09/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    sum = 0
    for line in data:
        diffs = [list(map(int, line.split()))]
        descending = True 
        while descending:
            diff = []
            descending = False
            for i, n in enumerate(diffs[-1][:-1]):
                diff.append(diffs[-1][i+1]-n)
                if diff[-1]:
                    descending = True
            diffs.append(diff)

        offset = 0
        for i, d in enumerate(diffs[::-1][1:]):
            offset += d[-1]
        sum += offset

    return sum

def main_b(data):
    sum = 0
    for line in data:
        diffs = [list(map(int, line.split()))]
        descending = True 
        while descending:
            diff = []
            descending = False
            for i, n in enumerate(diffs[-1][:-1]):
                diff.append(diffs[-1][i+1]-n)
                if diff[-1]:
                    descending = True
            diffs.append(diff)

        offset = 0
        for i, d in enumerate(diffs[::-1][1:]):
            offset = d[0] - offset
        sum += offset

    return sum

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))