#!/usr/bin/env python3.9

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_13/{fname}") as f:
        return [l.strip() for l in f]

def find_reflection(nums, pt2=False):
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
                
                error = False
                for a,b in zip(nums[_ls], nums[_rs]):
                    if a!=b:
                        if not smudged:
                            smudged = True
                        else:
                            error = True
                            break
                if error:
                    break
            _ls -= 1
            _rs += 1
        else:
            if not pt2 or smudged:
                return ls+1, len(nums)-rs
        ls += 1
        rs += 1
    return None

def run_pattern(data, pt2=False):
    ref = find_reflection(data, pt2=pt2)
    if ref is not None:
        return 100 * ref[0]

    new_data = []
    for c in range(len(data[0])):
        nd = ""
        for row in data:
            char = row[c]
            nd += char
        new_data.append(nd)
    ref = find_reflection(new_data, pt2=pt2)
    return ref[0]

def run(data, pt2):
    data.append("")
    s = 0
    pattern = []
    c = 0
    for row in data:
        if row == "":
            s += run_pattern(pattern, pt2=pt2)
            pattern = []
            c += 1
        else:
            pattern.append(row)
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