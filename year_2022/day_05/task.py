#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_05/{fname}") as f:
        return [l for l in f]

def parse(data):
    stack_str = []
    insts = []
    section = False
    for line in data:
        if line == "\n":
            section = True
            continue
        if section:
            i = line.strip().split()
            insts.append((int(i[1]), int(i[3])-1, int(i[5])-1))
        else:
            stack_str.append(line[:-1])

    stacks = [[] for i in stack_str[-1].split()]
    for si in range(len(stacks)):
        for s in stack_str[:-1]:
            ind = 1 + (si*4)
            c = s[ind]
            if c != " ":
                stacks[si].append(c)
    for i in range(len(stacks)):
        stacks[i] = stacks[i][::-1]

    return insts, stacks


def main_a(data):
    insts, stacks = parse(data)

    for count, source, dest in insts:
        for _ in range(count):
            v = stacks[source].pop()
            stacks[dest].append(v)

    res = "".join(s[-1] for s in stacks)

    return res

def main_b(data):
    insts, stacks = parse(data)

    for count, source, dest in insts:
        v = stacks[source][-count:]
        stacks[source] = stacks[source][:-count]
        stacks[dest] += v

    res = "".join(s[-1] for s in stacks)
    return res

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))