#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_02/{fname}") as f:
        return [l.strip() for l in f]

def parse(line):
    inp = line.split(": ")[1]
    for game in inp.split("; "):
        draws = game.split(", ")
        for draw in draws:
            num, col = draw.split()
            if col == "red": 
                if int(num) > 12: return False
            if col == "green": 
                if int(num) > 13: return False
            if col == "blue": 
                if int(num) > 14: return False

    return True

def main_a(data):
    sum = 0
    for i, line in enumerate(data):
        if parse(line):
            sum += i+1
    return sum

def main_b(data):
    sum = 0
    for line in data:
        rmin = 0
        gmin = 0
        bmin = 0
        inp = line.split(": ")[1]
        for game in inp.split("; "):
            draws = game.split(", ")
            for draw in draws:
                num, col = draw.split()
                if col == "red": 
                    rmin = max(rmin, int(num))
                if col == "green": 
                    gmin = max(gmin, int(num))
                if col == "blue": 
                    bmin = max(bmin, int(num))
        sum += rmin * gmin * bmin

    return sum
        

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))