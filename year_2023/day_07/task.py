#!/usr/bin/env python3
from collections import Counter
from functools import cmp_to_key

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_07/{fname}") as f:
        return [l.strip() for l in f]

def counter_to_hand(c: Counter, jokes=False):
    if jokes and "J" in c:
        mk = ""
        m = 0
        for k,v in c.items():
            if k != "J" and v > m:
                mk = k
                m = v

        c[mk] += c["J"]
        c.pop("J")

    v = sorted(list(c.values()), reverse=True)
    if v == [5]:
        return 6
    if v == [4,1]:
        return 5
    if v == [3,2]:
        return 4
    if v == [3,1,1]:
        return 3
    if v == [2,2,1]:
        return 2
    if v == [2,1,1,1]:
        return 1
    return 0

def card_strength(c,jokes=False):
    if c == "2": return 1
    if c == "3": return 2
    if c == "4": return 3
    if c == "5": return 4
    if c == "6": return 5
    if c == "7": return 6
    if c == "8": return 7
    if c == "9": return 8
    if c == "T": return 9
    if c == "J": return 0 if jokes else 10
    if c == "Q": return 11
    if c == "K": return 12
    if c == "A": return 13
    assert False

def cmp(a, b):
    return compare(a, b, False)

def jcmp(a, b):
    return compare(a, b, True)

def compare(ha, hb, jokes):
    ha = ha[0]
    hb = hb[0]
    handa = counter_to_hand(Counter(ha), jokes=jokes)
    handb = counter_to_hand(Counter(hb), jokes=jokes)
    if handa != handb:
        return 1 if handa > handb else -1
    for ca, cb in zip(ha,hb):
        if ca != cb:
            return 1 if card_strength(ca, jokes=jokes) > card_strength(cb, jokes=jokes) else -1
    assert False

def run(data, jokes):
    data = [d.split() for d in data]
    data.sort(key=cmp_to_key(jcmp if jokes else cmp))

    sum = 0
    for i, (_, v) in enumerate(data):
        sum += (i+1) * int(v)

    return sum

def main_a(data):
    return run(data, False)

def main_b(data):
    return run(data, True)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))