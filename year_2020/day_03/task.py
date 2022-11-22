#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2020/day_03/{fname}") as f:
        return [l.strip() for l in f]

def result_from_pat(pat, data):
    w = len(data[0])
    h = len(data)
    ind = [0,0]
    count = 0
    
    while ind[1] < h:
        if data[ind[1]][ind[0]] == "#":
            count += 1
        ind[0] = (ind[0] + pat[0])%w
        ind[1] += pat[1]

    return count

def main_a(data):
    return result_from_pat([3,1], data)

def main_b(data):
    return result_from_pat([1,1], data) *\
           result_from_pat([3,1], data) *\
           result_from_pat([5,1], data) *\
           result_from_pat([7,1], data) *\
           result_from_pat([1,2], data)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))