#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_11/{fname}") as f:
        return [l.strip() for l in f]

def expand(data: list[str]):
    new_data = []
    for row in data:
        new_data.append([i for i in row])
        if row.count("#") == 0:
            new_data.append([i for i in row])

    data = new_data

    new_data = [[] for _ in range(len(data))]
    for c in range(len(data[0])):
        col = []
        for i,row in enumerate(data):
            new_data[i].append(row[c])

        for row in data:
            if row[c] == "#":
                break
        else:
            for i,row in enumerate(data):
                new_data[i].append(row[c])

    return new_data
        
def get_positions(data):
    positions = []
    for y, row in enumerate(data):
        for x, char in enumerate(row):
            if char == "#":
                positions.append((y,x))
    return positions

def main_a(data):
    data = expand(data)
    positions = get_positions(data)
    
    s = 0
    for i, (y,x) in enumerate(positions):
        for j, (_y,_x) in enumerate(positions[i:]):
            j += i
            if i==j: continue

            dist = abs(_y - y) + abs(_x - x)
            s += dist
    
    return s

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))