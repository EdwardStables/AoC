#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2021/day_15/{fname}") as f:
        return [l.strip() for l in f]

def get_grid(data):
    return [list(map(int,l)) for l in data]

def filled_neighbour(grid, y, x):
    trials = []
    if y < len(grid)-1:
        trials.append((y+1, x))
    if y > 0:
        trials.append((y-1, x))
    if x < len(grid[0])-1:
        trials.append((y, x+1))
    if x > 0:
        trials.append((y, x-1))
    return [t for t in trials if grid[t[0]][t[1]] is not None]

def set_cost(data, costs, x, y):
    W = len(data[0])
    H = len(data)
    neighbours = filled_neighbour(costs, y, x)
    min_neighbour = min(costs[k][j] for k, j in neighbours)
    costs[y][x] = data[y][x] + min_neighbour
    for ny, nx in neighbours:
        if data[ny][nx] + costs[y][x] < costs[ny][nx]:
            set_cost(data, costs, nx, ny)

def main(data):
    W = len(data[0])
    H = len(data)

    costs = [[None for _ in range(W)] for _ in range(H)]

    costs[H-1][W-1] = data[H-1][W-1]
    #squares from bottom right corner
    for size in range(2, min(W,H)+1):
        for y in range(H-1, H-size-1, -1):
            set_cost(data, costs, y, W-size)
        for x in range(W-1, W-size-1, -1):
            set_cost(data, costs, H-size, x)
        set_cost(data,costs, H-size, W-size)

    return costs[0][0] - data[0][0]

def main_a(data):
    return(main(get_grid(data)))

def expand_data(data):
    new_data = []
    top = len(data)
    for row in data:
        new_row = []
        for _ in range(5):
            new_row.extend(row)
            row = [i+1 if i < 9 else 1 for i in row]
        new_data.append(new_row)

    for i in range(4):
        ext = []
        for r in new_data[-top:]:
            ext.append([i+1 if i<9 else 1 for i in r])
        new_data+=ext

    return new_data

def main_b(data):
    data = get_grid(data)
    data = expand_data(data)
    return(main(data))

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))