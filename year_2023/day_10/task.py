#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_10/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    for y, line in enumerate(data):
        for x, char in enumerate(line):
            if char == "S":
                S = (y, x)

    def next(y, x, src):
        if y > 0 and data[y][x] in "S|LJ" and data[y-1][x] in "SF7|":
            if (y-1,x) != src: return (y-1, x)
        if y < len(data)-1 and data[y][x] in "S|7F" and data[y+1][x] in "SLJ|":
            if (y+1,x) != src: return (y+1, x)
        if x > 0 and data[y][x] in "S-J7" and data[y][x-1] in "SFL-":
            if (y,x-1) != src: return (y, x-1)
        if x < len(data[0])-1 and data[y][x] in "S-FL" and data[y][x+1] in "SJ7-":
            if (y,x+1) != src: return (y, x+1)

        assert False, (y, x, src)

    positions = [S]
    next_pos = next(S[0], S[1], (S[0]-1, S[1]))
    while data[next_pos[0]][next_pos[1]] != "S":
        positions.append(next_pos)
        next_pos = next(next_pos[0], next_pos[1], positions[-2])

    return int(len(positions) / 2)

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))