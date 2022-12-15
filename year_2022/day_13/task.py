#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_13/{fname}") as f:
        return [l.strip() for l in f]

def test(a, b):
    if type(a) == int and type(b) == int:
        if a == b:
            return 0
        return -1 if a < b else 1

    if type(a) == list and type(b) == int:
        b_ = [b]
        return test(a, b_)
    if type(a) == int and type(b) == list:
        a_ = [a]
        return test(a_, b)
    
    #both must be lists
    
    #empty case
    if len(a) == 0 and len(b) == 0:
        return 0
    if len(a) == 0 and len(b) > 0:
        return -1
    elif len(a) > 0 and len(b) == 0:
        return 1

    for i in range(min(len(a), len(b))):
        cmp = test(a[i],b[i])
        if cmp == 0:
            continue
        return cmp

    if len(a) == len(b):
        return 0
    return -1 if len(a) < len(b) else 1


def main_a(data):
    line_ind = 0
    ind = 1
    ordered = 0

    while line_ind < len(data):
        pa = eval(data[line_ind])
        pb = eval(data[line_ind+1])
        line_ind += 3

        if test(pa, pb) == -1:
            ordered += ind
        ind += 1

    return ordered

def main_b(data):
    from functools import cmp_to_key
    packets = [eval(l) for l in data + ["[[2]]","[[6]]"] if l != ""]
    packets.sort(key=cmp_to_key(test))
    v = 1
    for i, pac in enumerate(packets):
        if pac == [[2]]:
            v *= i+1
        
        if pac == [[6]]:
            v *= i+1
            break

    return v

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))