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
    ranges = []
    seeds = list(map(int,data[0].split(":")[1].split()))
    i = 0
    while i < len(seeds):
        ranges.append((seeds[i], seeds[i]+seeds[i+1]-1))
        i += 2

    i = 1
    mapped_ranges = []
    while i < len(data):
        line = data[i]
        if line == "":
            ranges += mapped_ranges
            mapped_ranges = []
            i+=2
            continue

        dest, src, range = map(int,line.split())
        start = src
        end = src + range - 1
        offset = dest - src
        next_ranges = []
        for seed_start, seed_end in ranges:
            if end < seed_start or seed_end < start:
                next_ranges.append((seed_start, seed_end))
            elif start <= seed_start and end < seed_end:
                #left overlap
                mapped_ranges.append((seed_start+offset, end+offset))
                next_ranges.append((end+1, seed_end))
            elif start <= seed_start and end >= seed_end:
                #full overlap
                mapped_ranges.append((seed_start+offset, seed_end+offset))
            elif start > seed_start and end >= seed_end:
                #right overlap
                next_ranges.append((seed_start, start-1))
                mapped_ranges.append((start+offset, seed_end+offset))
            elif start > seed_start and end < seed_end:
                #inner overlap
                next_ranges.append((seed_start, start-1))
                mapped_ranges.append((start+offset, end+offset))
                next_ranges.append((end+1, seed_end))
        ranges = next_ranges

        i+=1
    ranges += mapped_ranges
    return min(s for s,e in ranges)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))
