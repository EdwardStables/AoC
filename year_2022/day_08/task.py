#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_08/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    dim = len(data)
    mask = [[0 for _ in range(dim)] for _ in range(dim)]
    #y going down
    prev_tallest = [d for d in data[0]]
    for x in range(dim):
        for y in range(dim):
            if y == 0:
                mask[y][x] = 1
            else:
                #prev tree visible
                if data[y][x] > prev_tallest[x]:
                    mask[y][x] = 1
                    prev_tallest[x] = data[y][x]
    #y going up
    prev_tallest = [d for d in data[-1]]
    for x in range(dim):
        for y in range(dim-1, -1, -1):
            if y == dim-1:
                mask[y][x] = 1
            else:
                #prev tree visible
                if data[y][x] > prev_tallest[x]:
                    mask[y][x] = 1
                    prev_tallest[x] = data[y][x]


    #x going right 
    prev_tallest = [d[0] for d in data]
    for y in range(dim):
        for x in range(dim):
            if x == 0:
                mask[y][x] = 1
            else:
                #prev tree visible
                if data[y][x] > prev_tallest[y]:
                    mask[y][x] = 1
                    prev_tallest[y] = data[y][x]

    #x going left
    prev_tallest = [d[-1] for d in data]
    for y in range(dim):
        for x in range(dim-1, -1, -1):
            if x == dim-1:
                mask[y][x] = 1
            else:
                #prev tree visible
                if data[y][x] > prev_tallest[y]:
                    mask[y][x] = 1
                    prev_tallest[y] = data[y][x]
    

    return sum(sum(r) for r in mask)

def show(mask):
    for row in mask:
        print("".join(str(s) for s in row))

def show2(mask, data):
    for y, row in enumerate(mask):
        for x, have in enumerate(mask[y]):
            if have:
                print(data[y][x], end="")
            else:
                print("_", end="")
        print()


def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))