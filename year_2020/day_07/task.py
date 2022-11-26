#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2020/day_07/{fname}") as f:
        return [l.strip() for l in f]

def get_parents(bags, target):
    parents = []
    for k, v in bags.items():
        if target in v:
            parents.append(k)
    return parents

def main_a(data):
    bags = {}
    for line in data:
        outer, inner = line[:-1].split(" bags contain ")
        inner = [" ".join(i.split()[1:3]) for i in inner.split(", ")]

        bags[outer] = inner
    
    containers = set()
    top = set()
    to_find = set(["shiny gold"])
    while len(to_find) > 0:
        parents = set()
        new_top = set()
        for tf in to_find:
            ps = get_parents(bags, tf)
            if ps == []:
                new_top.add(tf)
            else:
                parents.update(set(ps))
        containers.update(parents)
        top.update(new_top)
        to_find = parents
        to_find.difference_update(top)

    return len(containers)

def get_count(bags, counts, target, indent = ""):
    if target in counts:
        return counts[target]
    
    if bags[target] is None:
        counts[target] = 0
        return 0

    cost = 0
    for count, sub in bags[target]:
        cost += count * (1+get_count(bags, counts, sub, indent=indent+"  "))

    counts[target] = cost
    return cost

def main_b(data):
    bags = {}
    for line in data:
        outer, inner = line[:-1].split(" bags contain ")
        if inner[:2] == "no":
            bags[outer] = None
        else:
            subs = []
            for i in inner.split(", "):
                subs.append((int(i.split()[0]), " ".join(i.split()[1:3])))
            bags[outer] = subs

    costs = {}
    get_count(bags, costs, "shiny gold")
    return costs["shiny gold"]

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))