#!/usr/bin/env python3
from math import lcm

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_08/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    instr = data[0]
    nodes = {}
    for s in data[2:]:
        name, next = s.split(" = ")
        l, r = next[1:-1].split(", ")
        nodes[name] = (l, r)

    steps = 0
    node = "AAA"
    instr_index = 0
    while node != "ZZZ":
        node = nodes[node][0 if instr[instr_index]== "L" else 1]
        steps += 1
        instr_index += 1
        if instr_index == len(instr): instr_index = 0
    return steps

def main_b(data):
    instr = data[0]
    nodes = {}
    for s in data[2:]:
        name, next = s.split(" = ")
        l, r = next[1:-1].split(", ")
        nodes[name] = (l, r)

    current_nodes = {n:0 for n in nodes if n[-1] == "A"}
    for start_node in current_nodes:
        steps = 0
        instr_index = 0
        node = start_node
        while node[-1] != "Z":
            node = nodes[node][0 if instr[instr_index]== "L" else 1]
            steps += 1
            instr_index += 1
            if instr_index == len(instr): instr_index = 0
        current_nodes[start_node] = steps

    
    return lcm(*current_nodes.values())

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))