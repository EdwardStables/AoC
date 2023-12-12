#!/usr/bin/env python3
from copy import copy

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_12/{fname}") as f:
        return [l.strip() for l in f]

def run(data):
    final_count = 0

    class entry:
        def __init__(self, pattern, index=0):
            self.pattern = pattern
            self.index = index 
        def s(self): return self.pattern[self.index]
        def r(self, replace): self.pattern = self.pattern[:self.index] + replace + self.pattern[self.index+1:]
        def l(self): return len(self.pattern)
        def c(self): return self.index
        def i(self): self.index += 1
        def __repr__(self): return self.pattern + " " + str(self.index)

    for lineno, (pattern, widths) in enumerate(data):
        count = 0
        options = [entry(pattern)]

        while len(options) > 0:
            #input()
            op = options.pop(-1)            
            ops = []

            #it's valid, leave it out and increment count
            if op.c() == op.l():
                count += 1
                continue

            #if it starts with a ? then push back both options
            if op.s() == "?":
                dot = entry(op.pattern, op.index)
                hash = entry(op.pattern, op.index)
                dot.r(".")
                hash.r("#")
                dot.i()
                hash.i()
                ops.append(dot)
                ops.append(hash)
            #if it starts with a . or # then just inc
            if op.s() in "#.":
                op.i()
                ops.append(op)

            #validate ops
            for op in ops:
                lw = copy(widths)
                last = "."
                for i in range(op.c()):
                    if op.pattern[i] == "." and last == "#":
                        if lw[0] != 0:
                            break
                        lw.pop(0)
                    elif op.pattern[i] == "#":
                        if len(lw) <= 0:
                            break
                        if lw[0] <= 0:
                            break
                        lw[0] -= 1
                    if (len(op.pattern) - (i+1)) < (sum(lw) + len(lw) - 1):
                        break
                    
                    last = op.pattern[i]
                    assert op.pattern[i] != "?"
                else:
                    options.append(op)
                


        final_count += count    

    return final_count

def main_a(data):
    new_data = []
    for line in data:
        pattern, widths = line.split()
        widths = [int(i) for i in widths.split(",")]
        new_data.append((pattern, widths))
    return run(new_data)

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))