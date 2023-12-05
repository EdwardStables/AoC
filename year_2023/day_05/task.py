#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_05/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    seeds = list(map(int,data[0].split(":")[1].split()))

    line = 3
    while line < len(data):
        if data[line] == "":
            line += 2
            continue

        dest, src, range = map(int,data[line].split())
        new_seeds = []
        for seed in seeds:
            if seed > src and seed < src+range:
                new_seeds.append(seed+dest-src)
            else:
                new_seeds.append(seed)

        seeds=new_seeds
        line += 1

    return min(seeds)

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))