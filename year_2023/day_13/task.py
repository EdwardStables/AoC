#!/usr/bin/env python3.9

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_13/{fname}") as f:
        return [l.strip() for l in f]

def find_reflection(nums, diffs, pt2=False):
    ls = 0
    rs = 1
    while rs < len(nums):
        _ls = ls
        _rs = rs
        smudged = False
        while _ls >= 0 and _rs < len(nums):
            if nums[_ls] != nums[_rs]:
                if not pt2: break
                if smudged: break
                diff = abs(nums[_ls] - nums[_rs])
                if diff in diffs:
                    print(ls, rs, _ls, _rs, nums)
                    smudged = True
                else:
                    break
            _ls -= 1
            _rs += 1
        else:
            if not pt2 or smudged:
                return ls+1, len(nums)-rs
        ls += 1
        rs += 1
    return None

def run_pattern(data, diffs, pt2=False):
    v_nums = []
    for row in data:
        n = 0
        i = 0
        for char in row[::-1]:
            if char == "#":
                n += 2**i
            i+=1
        v_nums.append(n)
    print("rows", v_nums)
    ref = find_reflection(v_nums, diffs, pt2=pt2)
    print(ref)
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
    print("cols")
    ref = find_reflection(h_nums, diffs, pt2=pt2)
    print(ref)
    return ref[0]

def run(data, pt2):
    s = 0
    pattern = []
    print("pat")
    diffs = [2**i for i in range(max(len(data), len(data[0])))]
    for row in data:
        if row == "":
            s+= run_pattern(pattern, diffs, pt2=pt2)
            print("pat")
            pattern = []
        else:
            pattern.append(row)
    s+=run_pattern(pattern, diffs, pt2=pt2)
    return s

def main_a(data):
    return 0
    return run(data, False)

def main_b(data):
    return run(data, True)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))