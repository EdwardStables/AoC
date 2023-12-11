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
    #100 for test
    factor = 100 if len(data) == 10 else 1000000
    factor -= 1 #stop extra row/col counting after expansion
    rows = expanded_rows(data)
    cols = expanded_cols(data)
    positions = get_positions(data)
    s = 0
    for i, (y,x) in enumerate(positions):
        for j, (_y,_x) in enumerate(positions[i:]):
            j += i
            if i==j: continue
            y_hi = max(y,_y)
            y_lo = min(y,_y)
            x_hi = max(x,_x)
            x_lo = min(x,_x)

            y_off_count = 0
            for r in rows:
                if r > y_lo and r < y_hi:
                    y_off_count += 1
            x_off_count = 0
            for c in cols:
                if c > x_lo and c < x_hi:
                    x_off_count += 1

            disty =  (y_hi + (factor*y_off_count) - y_lo)
            distx = (x_hi + (factor*x_off_count) - x_lo)

            s += disty + distx

    return s

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))