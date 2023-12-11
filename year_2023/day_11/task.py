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
    for y, row in enumerate(data):
        if row.count("#") == 0:
            rows.append(y)
    return rows

def expanded_cols(data):
    cols = []
    for c in range(len(data[0])):
        for row in data:
            if row[c] == "#":
                break
        else:
            cols.append(c)

    return cols
        
def get_positions(data, expand):
    positions = []
    rows = expanded_rows(data)
    cols = expanded_cols(data)
    row_index = 0
    row_offset = 0
    for y, row in enumerate(data):
        if row_index < len(rows) and  y == rows[row_index]:
            row_offset += expand-1
            row_index += 1
        col_index = 0
        col_offset = 0
        for x, char in enumerate(row):
            if col_index < len(cols) and x == cols[col_index]:
                col_offset += expand-1
                col_index += 1
            if char == "#":
                positions.append((y+row_offset,x+col_offset))
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