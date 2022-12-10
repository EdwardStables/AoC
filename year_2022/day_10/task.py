#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_10/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    strength_sum = 0    
    X = 1
    busy = False
    next_X = 0
    cycle = 1
    instr = 0

    while instr < len(data):
        if cycle in [20, 60, 100, 140, 180, 220]:
           strength_sum += X*cycle
        
        cycle += 1
        if busy:
            X = next_X
            busy = False
            continue
        
        if data[instr] == "noop":
            pass
        else:
            busy = True
            next_X = X + int(data[instr].split()[1])
        instr += 1
    return strength_sum

def main_b(data):
    rows = ["","","","","",""]
    X = 1
    busy = False
    next_X = 0
    cycle = 1
    instr = 0

    while instr < len(data):
        row = (cycle-1)//40
        pos = (cycle-1)%40
        if pos in [X-1, X, X+1]:
            rows[row] += "#"
        else:
            rows[row] += "."

        if cycle in [20, 60, 100, 140, 180, 220]:
           pass
        cycle += 1
        if busy:
            X = next_X
            busy = False
            continue
        
        if data[instr] == "noop":
            pass
        else:
            busy = True
            next_X = X + int(data[instr].split()[1])
        instr += 1

    return "\n" + "\n".join(rows)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))