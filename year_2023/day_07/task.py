#!/usr/bin/env python3
from collections import Counter
from functools import cmp_to_key

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_07/{fname}") as f:
        return [l.strip() for l in f]

def counter_to_hand(c: str, jokes=False):
    c = Counter(c)
    if jokes and "J" in c:
        mk = ""
        m = 0
        for k,v in c.items():
            if k != "J" and v > m:
                mk = k
                m = v

        c[mk] += c["J"]
        c.pop("J")

    v = c.values()
    l = len(v)
    if l == 1:
        return 6
    if l == 2:
        return max(v)+1
    if l == 3:
        return max(v)
    if l == 4:
        return 1
    return 0

def card_strength(hand: str,jokes=False):
    hand = hand.replace("A","E")
    hand = hand.replace("K","D")
    hand = hand.replace("Q","C")
    hand = hand.replace("J","0" if jokes else "B")
    hand = hand.replace("T","A")
    return hand

def run(data, jokes):
    data = [d.split() for d in data]
    for d in data:
        d.append(counter_to_hand(d[0],jokes=jokes))
        d.append(card_strength(d[0],jokes=jokes))

    data.sort(key=lambda d: (d[2], d[3]))

    sum = 0
    for i, (_, v, _, _) in enumerate(data):
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