#!/usr/bin/env python3.9

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_13/{fname}") as f:
        return [l.strip() for l in f]

def find_reflection(nums):
    ls = 0
    rs = 1
    while rs < len(nums):
        if nums[ls] == nums[rs]:
            _ls = ls - 1
            _rs = rs + 1
            while _ls >= 0 and _rs < len(nums):
                if nums[_ls] != nums[_rs]:
                    break
                _ls -= 1
                _rs += 1
            else:
                return ls+1, len(nums)-rs
        ls += 1
        rs += 1
    return None

def run_pattern(data):
    v_nums = []
    for row in data:
        n = 0
        i = 0
        for char in row[::-1]:
            if char == ".":
                n += 2**i
            i+=1
        v_nums.append(n)
    ref = find_reflection(v_nums)
    if ref is not None:
        return 100 * ref[0]

    h_nums = []
    for c in range(len(data[0])):
        n = 0
        i = 0
        for row in data:
            char = row[c]
            if char == "#":
                n += 2**i
            i+=1
        h_nums.append(n)
    return find_reflection(h_nums)[0]

def main_a(data):
    s = 0
    pattern = []
    for row in data:
        if row == "":
            s+= run_pattern(pattern)
            pattern = []
        else:
            pattern.append(row)
    s+=run_pattern(pattern)
    return s

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))