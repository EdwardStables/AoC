#!/usr/bin/env python3
from collections import defaultdict as ddict

def get_data(fname = "data.txt"):
    with open(f"day_12/{fname}") as f:
        return [l.strip() for l in f]

class Node:
    def __init__(self, name, isBig):
        self.name = name
        self.big = isBig
        self.connections = []

    def __repr__(self):
        return f"{self.name} -> {[n.name for n in self.connections]}"

def build(data):
    node_names = set()

    for line in data:
        fs = line.split("-")
        node_names.add(fs[0])
        node_names.add(fs[1])

    nodes = {node : Node(node, node.isupper()) for node in node_names}

    for line in data:
        fs = line.split("-")
        nodes[fs[0]].connections.append(nodes[fs[1]])
        nodes[fs[1]].connections.append(nodes[fs[0]])

    return nodes


def step_small_twice(paths,graph):
    new_paths = []
    for path in paths:
        lower_counts = set()
        for p in path:
            if p.islower():
                if p in lower_counts:
                    path_has_double_small = True
                    break
                else:
                    lower_counts.add(p)
        else:
            path_has_double_small = False
        
        cons = graph[path[-1]].connections
        for c in cons:
            if c.name != "start" and \
               (c.big or \
                not path_has_double_small or \
                c.name not in path): 
                new_path = [p for p in path]
                new_path.append(c.name)
                new_paths.append(new_path)
    return new_paths

def step_unique(paths,graph):
    new_paths = []
    for path in paths:
        cons = graph[path[-1]].connections
        for c in cons:
            if (c.big and c.name in path) or (c.name not in path):
                new_path = [p for p in path]
                new_path.append(c.name)
                new_paths.append(new_path)
    return new_paths

def main(data, step_func):
    graph = build(data)
    path_count = 0
    in_progress_paths = [["start"]]
    while True:
        next_paths = step_func(in_progress_paths, graph)
        if not next_paths:
            break
        in_progress_paths = []
        for p in next_paths:
            if p[-1] == "end":
                path_count += 1
            else:
                in_progress_paths.append(p)

    return path_count

def main_a(data):
    return main(data, step_unique)

def main_b(data):
    return main(data, step_small_twice)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))