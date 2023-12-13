#!/usr/bin/env python3.9

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_13/{fname}") as f:
        return [l.strip() for l in f]

def find_reflection(nums, pt2=False):
    ls = 0
    rs = 1
    while rs < len(nums):
        if nums[ls] == nums[rs]:
            _ls = ls - 1
            _rs = rs + 1
            smudged = False
            while _ls >= 0 and _rs < len(nums):
                if nums[_ls] != nums[_rs]:
                    if not pt2: break
                    if smudged: break
                    print(_ls, _rs, nums[_ls], nums[_rs])
                    diff = abs(nums[_ls] - nums[_rs])
                    diffs = [2**i for i in range(len(nums))]
                    print(diff, diffs)
                    if diff in diffs:
                        print(ls, rs, _ls, _rs, nums)
                        smudged = True
                    else:
                        break
                _ls -= 1
                _rs += 1
            else:
                return ls+1, len(nums)-rs
        ls += 1
        rs += 1
    return None

def run_pattern(data, pt2=False):
    v_nums = []
    for row in data:
        n = 0
        i = 0
        for char in row[::-1]:
            if char == ".":
                n += 2**i
            i+=1
        v_nums.append(n)
    ref = find_reflection(v_nums, pt2=pt2)
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
    return find_reflection(h_nums, pt2=pt2)[0]

def run(data, pt2):
    s = 0
    pattern = []
    for row in data:
        if row == "":
            s+= run_pattern(pattern, pt2=pt2)
            pattern = []
        else:
            pattern.append(row)
    s+=run_pattern(pattern, pt2=pt2)
    return s

def main_a(data):
    return run(data, False)

def main_b(data):
    return run(data, True)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))