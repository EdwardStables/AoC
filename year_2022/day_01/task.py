#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_01/{fname}") as f:
        return [None if l.strip() == "" else int(l.strip()) for l in f]

def main_a(data):
    ma = 0 
    cur = 0
    for line in data:
        if line is None:
            if cur > ma:
                ma = cur 
            cur = 0 
        else:
            cur += line
    return ma

def main_b(data):
    m1 = 0 
    m2 = 0 
    m3 = 0 
    cur = 0
    for line in data:
        if line is None:
            if cur > m3:
                m1 = m2
                m2 = m3
                m3 = cur 
            elif cur > m2:
                m1 = m2
                m2 = cur 
            elif cur > m1:
                m1 = cur
            cur = 0 
        else:
            cur += line
    return m1+m2+m3

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))