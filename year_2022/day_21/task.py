#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_21/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    vals = {}
    maths = {}
    for line in data:
        k, v = line.split(": ")
        if v.isdigit():
            vals[k] = int(v)
            continue
        v1, op, v2 = v.split()
        v1 = vals.get(v1, v1)
        v2 = vals.get(v2, v2)
        if type(v1) == int and type(v2) == int:
            if op == "+":
                vals[k] = v1 + v2
            if op == "-":
                vals[k] = v1 - v2
            if op == "*":
                vals[k] = v1 * v2
            if op == "/":
                vals[k] = v1 // v2
        else:
            maths[k] = [v1, op, v2]

    
    while len(maths) > 0:
        keys_to_rm = []
        for k, (v1, op, v2) in maths.items():
            v1 = vals.get(v1, v1)
            v2 = vals.get(v2, v2)
            if type(v1) == int and type(v2) == int:
                if op == "+":
                    vals[k] = v1 + v2
                if op == "-":
                    vals[k] = v1 - v2
                if op == "*":
                    vals[k] = v1 * v2
                if op == "/":
                    vals[k] = v1 // v2
                keys_to_rm.append(k)
        for k in keys_to_rm:
            maths.pop(k)

    return vals["root"]

def main_b(data):
    vals = {}
    maths = {}
    for line in data:
        k, v = line.split(": ")
        if v.isdigit():
            vals[k] = int(v)
            continue
        v1, op, v2 = v.split()
        v1 = vals.get(v1, v1)
        v2 = vals.get(v2, v2)
        if type(v1) == int and type(v2) == int:
            if op == "+":
                vals[k] = v1 + v2
            if op == "-":
                vals[k] = v1 - v2
            if op == "*":
                vals[k] = v1 * v2
            if op == "/":
                vals[k] = v1 // v2
        else:
            maths[k] = [v1, op, v2]


    left = parse(maths["root"][0], maths, vals)
    right = parse(maths["root"][2], maths, vals)

    while type(left) == list or type(right) == list:
        left, right = solve(left, right)

    return left if right == "humn" else right

def solve(left, right):
    if type(left) == int:
        compound = right
        main = left
    else:
        compound = left
        main = right

    v1, op, v2 = compound
    if type(v1) == int:
        if op == "+":
            main -= v1
        if op == "-":
            main = v1 - main
        if op == "*":
            main //= v1
        if op == "/":
            main = v1 // main
        compound = v2
    else:
        assert type(v2) == int
        if op == "+":
            main -= v2
        if op == "-":
            main += v2
        if op == "*":
            main //= v2
        if op == "/":
            main *= v2
        compound = v1

    return main, compound

def parse(node, maths, vals):
    if node == "humn":
        return "humn"    

    if node in vals:
        return vals[node]

    v1, op, v2 = maths[node]
    if type(v1) != int:
        v1 = parse(v1, maths, vals)
    if type(v2) != int:
        v2 = parse(v2, maths, vals)

    if type(v1) == type(v2) == int:
        if op == "+":
            vals[node] = v1 + v2
        if op == "-":
            vals[node] = v1 - v2
        if op == "*":
            vals[node] = v1 * v2
        if op == "/":
            vals[node] = v1 // v2
        return vals[node]
    else:
        maths[node] = [v1, op, v2]
        return maths[node]

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))