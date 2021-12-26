#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_24/{fname}") as f:
        return [l.strip() for l in f]

class ALU:
    def __init__(self, input):
        self.w = 0
        self.x = 0
        self.y = 0
        self.z = 0
        self.input = f"{input:014}"

    def next_input_char(self):
        v = int(self.input[0])
        self.input = self.input[1:]
        return v

    def get(self, reg):
        if reg == "w":
            return self.w
        elif reg == "x":
            return self.x
        elif reg == "y":
            return self.y
        elif reg == "z":
            return self.z
        else:
            return reg

    def set(self, reg, val):
        if reg == "w":
            self.w = val
        elif reg == "x":
            self.x = val
        elif reg == "y":
            self.y = val
        elif reg == "z":
            self.z = val

    def run(self, instr, a, b):
        if instr == "inp":
            self.set(a, self.next_input_char())
        elif instr == "add":
            self.set(a, self.get(a) + self.get(b))
        elif instr == "mul":
            self.set(a, self.get(a) * self.get(b))
        elif instr == "div":
            self.set(a, self.get(a) / self.get(b))
        elif instr == "mod":
            self.set(a, self.get(a) % self.get(b))
        elif instr == "eql":
            self.set(a, int(self.get(a) == self.get(b)))

def interp(line):
    line = line.split()
    if line[0] == "inp":
        return ["inp", line[1], ""]
    else:
        if line[2] not in ['w', 'x','y','z']:
            line[2] = int(line[2])
        return line
        
def main_a(data):
    i = 11111111111111
    pc = 0
    while i <= 99999999999999:
        i+= 1
        if '0' in str(i):
            continue
        alu = ALU(i)
        for line in data:
            alu.run(*interp(line))
        if alu.z == 0:
            break
        pc += 1
        if pc > 100:
            print(i)
            pc = 0

    return i

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    