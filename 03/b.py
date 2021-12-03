#!/usr/bin/env python3


def get_most_common_bit(data, bit):
    data = [d[bit] for d in data]
    counter = 0
    for num in data:
        if num == "1":
            counter+=1
        else:
            counter-=1
    
    return "1" if counter > 0 else "0"

def run_filt(data, common):
    index = 1
    while True:
        l1 = []
        l2 = []
        for d in data:
            if d[index] == "1":
                l1.append(d)
            else:
                l2.append(d)
        if common:
            data = l1 if len(l1) >= len(l2) else l2
        else:
            data = l1 if len(l1) < len(l2) else l2
            

        index += 1
        if len(data) == 1:
            break

    return data[0]
from time import time

with open("03/data.txt") as f:
    data = [l.strip() for l in f.readlines()]

msb = get_most_common_bit(data, 0)
o2 = list(filter(lambda x: x[0] == msb, data))
co2 = list(filter(lambda x: not x[0] == msb, data))
o2_res = int(run_filt(o2, True), base=2)
co2_res = int(run_filt(co2, False), base=2)

print(o2_res * co2_res)