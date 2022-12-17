#!/usr/bin/env python3
from itertools import permutations
from copy import copy

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_16/{fname}") as f:
        return [l.strip() for l in f]

class Node:
    def __init__(self, name, flow):
        self.name = name
        self.flow = flow
        self.connections = {}
        self.connections_tmp = {}
    
    def __repr__(self):
        return f"{self.name} {self.flow} : {self.connections}"


def traverse(nodes: dict[str,Node], cur: str, budget:int , switched:set[str], val:int, depth=0, current_max=0):
    if depth==4:
        print(current_max, depth, budget)
    #input()
    #print(cur, budget, switched, current_max)
    if budget <= 0 or len(switched) == len(nodes):
        return val

    max_val = 0
    local_switched = copy(switched)
    local_switched.add(cur)

    for key, cost in nodes[cur].connections.items():
        if budget == 0:
            break

        #If current isn't switched
        #max_val = max(max_val, traverse(nodes, key, budget-cost, switched, val, depth=depth+1, current_max=max(current_max, max_val)))
        #If current is switched
        if cur not in switched:
            max_val = max(max_val, traverse(nodes, key, budget-1-cost, local_switched, val + (budget-1)*nodes[cur].flow, depth=depth+1, current_max=max(current_max, max_val)))
        else:
            max_val = max(max_val, traverse(nodes, key, budget-cost, switched, val, depth=depth+1, current_max=max(current_max, max_val)))

    return max_val

def main_a(data):
    nodes = {}
    nodes: dict[str, Node]
    for line in data:
        line = line.split()
        nodes[line[1]] = Node(line[1], int(line[4].split("=")[1][:-1]))

    for line in data:
        line = line.split()
        links = [l[:2] for l in line[9:]]
        for link in links:
            nodes[line[1]].connections[link] = 1
        
    starters = simplify(nodes)

    max_val = 0
    for start, budget in starters.items():
        v = traverse(nodes, start, budget, set(), 0, current_max=max_val)
        print("start" , start, v)
        max_val = max(max_val, v)
    return max_val

def simplify(nodes: dict[str,Node]):
    to_rm = []
    for name, node in nodes.items():
        if node.flow > 0 or len(node.connections) != 2:
            continue
        link_cost = sum(node.connections.values())
        a_node = list(node.connections.keys())[0]
        b_node = list(node.connections.keys())[1]
        nodes[a_node].connections.pop(name)
        nodes[b_node].connections.pop(name)

        if b_node not in nodes[a_node].connections or link_cost < nodes[a_node].connections:
                nodes[a_node].connections[b_node] = link_cost
        if a_node not in nodes[b_node].connections or link_cost < nodes[b_node].connections:
                nodes[b_node].connections[a_node] = link_cost
            
        to_rm.append(name) 

    for n in to_rm:
        nodes.pop(n)

    starters = {}
    for k, cost in nodes["AA"].connections.items():
        starters[k] = 30-cost

    print(starters)

    for k1, v1 in nodes["AA"].connections.items():
        for k2, v2 in nodes["AA"].connections.items():
            if k1 == k2:
                continue
            new_cost = v1+v2
            if k2 not in nodes[k1].connections or new_cost < nodes[k1].connections[k2]:
                nodes[k1].connections[k2] = new_cost
        nodes[k1].connections.pop("AA")
    
    nodes.pop("AA")

    for n, v in nodes.items():
        print(v)
    for k, c in starters.items():
        print(k, c)

    return starters

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))