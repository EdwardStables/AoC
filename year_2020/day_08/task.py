#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2020/day_08/{fname}") as f:
        return [l.strip() for l in f]

def terminates(data, swap=None):
    ind = 0
    acc = 0
    while True:
        if ind >= len(data):
            return (True, acc)
        line = data[ind][1]
        op, val = line.split()
        next_ind = ind + 1

        if swap is not None and ind == swap:
            if op == "nop":
                op = "jmp"
            elif op == "jmp":
                op = "nop"
            else:
                return False,0

        if op == "acc":
            acc += int(val)
        if op == "jmp":
            next_ind = ind + int(val)
        data[ind][0] = True
        

        if next_ind >= len(data):
            return (True, acc)
        if data[next_ind][0]:
            return False, acc

        ind = next_ind

def prep(data):
    return [[False, d if type(d)==str else d[1]] for d in data]

def main_a(data):
    data = prep(data)
    return terminates(data)[1]

def main_b(data):
    for i in range(len(data)):
        data = prep(data)
        correct, acc = terminates(data, i)
        if correct:
            return acc

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))