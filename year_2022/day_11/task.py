#!/usr/bin/env python3
from dataclasses import dataclass
from typing import Callable, Union
from math import floor

def get_data(fname = "data.txt"):
    monkeys = get_real() if fname=="data.txt" else get_test()
    return monkeys

@dataclass
class Monkey:
    items: list[int]
    op: Callable[[int],int]
    test_fac: int
    target_true: int
    target_false: int
    inspect: int = 0

def get_test():
    return [
        Monkey([79, 98],            lambda x: x*19, 23, 2, 3),
        Monkey([54, 65, 75, 74],    lambda x: x+6,  19, 2, 0),
        Monkey([79, 60, 97],        lambda x: x*x,  13, 1, 3),
        Monkey([74],                lambda x: x+3,  17, 0, 1)
  ]
def get_real():
    return [
        Monkey([66,59,64,51],               lambda x: x*3, 2, 1, 4),
        Monkey([67,61],                     lambda x: x*19,7, 3, 5),
        Monkey([86,93,80,70,71,81,56],      lambda x: x+2, 11, 4, 0),
        Monkey([94],                        lambda x: x*x, 19, 7, 6),
        Monkey([71,92,64],                  lambda x: x+8, 3, 5, 1),
        Monkey([58,81,92,75,56],            lambda x: x+6, 5, 3, 6),
        Monkey([82,98,77,94,86,81],         lambda x: x+7, 17, 7, 2),
        Monkey([54,95,70,93,88,93,63,50],   lambda x: x+4, 13, 2, 0),
    ]

def main_a(data: list[Monkey]):
    for i in range(20):
        for m, monkey in enumerate(data):
            for item in monkey.items:
                monkey.inspect += 1
                item = monkey.op(item)
                item = item//3
                target = monkey.target_true if item % monkey.test_fac == 0 else monkey.target_false
                data[target].items.append(item)
            monkey.items = []

    ic = sorted(m.inspect for m in data)
    return ic[-1] * ic[-2]

def main_b(data):
    red_const = 1
    for m in data:
        red_const *= m.test_fac
    for i in range(10000):
        for m, monkey in enumerate(data):
            for item in monkey.items:
                monkey.inspect += 1
                item = monkey.op(item)
                item %= red_const
                target = monkey.target_true if item % monkey.test_fac == 0 else monkey.target_false
                data[target].items.append(item)
            monkey.items = []
    ic = sorted(m.inspect for m in data)

    return ic[-1] * ic[-2]

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))