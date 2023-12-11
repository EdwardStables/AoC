#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_11/{fname}") as f:
        return [l.strip() for l in f]

def expand(data):
    new_data = []
    for row in data:
        new_data.append([i for i in row])
        if row.count("#") == 0:
            new_data.append([i for i in row])

    data = new_data

    new_data = [[] for _ in range(len(data))]
    for c in range(len(data[0])):
        for i,row in enumerate(data):
            new_data[i].append(row[c])

        for row in data:
            if row[c] == "#":
                break
        else:
            for i,row in enumerate(data):
                new_data[i].append(row[c])

    return new_data

def expanded_rows(data):
    rows = []
    last = 0
    for row in data:
        if row.count("#") == 0:
            last += 1
        rows.append(last)
    return rows

def expanded_cols(data):
    cols = []
    last = 0
    for c in range(len(data[0])):
        for row in data:
            if row[c] == "#":
                break
        else:
            last += 1
        cols.append(last)

    return cols
        
def get_positions(data, expand):
    positions = []
    rows = expanded_rows(data)
    cols = expanded_cols(data)
    for (y, row), row_offset in zip(enumerate(data), rows):
        for (x, char), col_offset in zip(enumerate(row), cols):
            if char == "#":
                positions.append((y+(expand-1)*row_offset,x+(expand-1)*col_offset))

    return positions

def run(data, expand):
    positions = get_positions(data, expand)
    
    s = 0
    for i, (y,x) in enumerate(positions):
        for j, (_y,_x) in enumerate(positions[i:]):
            j += i
            if i==j: continue

            dist = abs(_y - y) + abs(_x - x)
            s += dist
    
    return s

def main_a(data):
    return run(data, 2)

def main_b(data):
    #100 for test
    factor = 100 if len(data) == 10 else 1000000
    return run(data, factor)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))