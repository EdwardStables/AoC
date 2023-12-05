#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_05/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    return 0

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
            print("\n", data[i+1])
            i+=2
            continue

        dest, src, range = map(int,line.split())
        start = src
        end = src + range - 1
        offset = dest - src
        #print(ranges)
        #input()
        #print(dest, src, range)
        print(start, end, offset)
        print(mapped_ranges)
        print(ranges)
        next_ranges = []
        for seed_start, seed_end in ranges:
            print(seed_start, seed_end, end=" ")
            if end < seed_start or seed_end < start:
                print("outside")
                next_ranges.append((seed_start, seed_end))
            elif start <= seed_start and end < seed_end:
                print("left")
                #left overlap
                mapped_ranges.append((seed_start+offset, end+offset))
                next_ranges.append((end+1, seed_end))
            elif start <= seed_start and end >= seed_end:
                print("full")
                #full overlap
                mapped_ranges.append((seed_start+offset, seed_end+offset))
            elif start > seed_start and end >= seed_end:
                print("right")
                #right overlap
                next_ranges.append((seed_start, start-1))
                mapped_ranges.append((start+offset, seed_end+offset))
            elif start > seed_start and end < seed_end:
                print("inside")
                #inner overlap
                next_ranges.append((seed_start, start-1))
                mapped_ranges.append((start+offset, end+offset))
                next_ranges.append((end+1, seed_end))
        ranges = next_ranges

        print(ranges)
        print(mapped_ranges)
        i+=1
    print(ranges)

    return min(s for s,e in ranges)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))