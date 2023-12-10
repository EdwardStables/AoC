#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_10/{fname}") as f:
        return [l.strip() for l in f]

def loop(data):
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

    return S, positions


def main_a(data):
    _, positions = loop(data)
    return int(len(positions) / 2)

def main_b(data):
    (Sy,Sx), positions = loop(data)

    #replace S to simplify later code
    bot = data[Sy+1][Sx] in "|JL" and Sy < len(data)-1
    top = data[Sy-1][Sx] in "|F7" and Sy > 0
    right = data[Sy][Sx+1] in "-J7" and Sx < len(data[0])-1
    left = data[Sy][Sx-1] in "-FL" and Sx > 0

    ddata = [["." for _ in data[0]] for _ in data]
    for y, x in positions:
        ddata[y][x] = data[y][x]
    data = ddata

    if bot and top:
        data[Sy][Sx] = "|"
    if bot and right:
        data[Sy][Sx] = "F"
    if bot and left:
        data[Sy][Sx] = "7"
    if top and right:
        data[Sy][Sx] = "L"
    if top and left:
        data[Sy][Sx] = "J"
    if left and right:
        data[Sy][Sx] = "-"

    count = 0
    for y, line in enumerate(data):
        cross = False
        h_entry = ""
        for x, c in enumerate(line):
            #standard line cross
            if c != ".":
                if c == "|":
                    assert h_entry == "", (h_entry, (y,x))
                    cross = not cross
                elif c == "-":
                    assert h_entry != "",  (h_entry, (y,x))
                elif c in "JLF7":
                    if h_entry == "":
                        h_entry = c
                    else:
                        #crosses still
                        if h_entry in "JL" and c in "F7" or\
                           h_entry in "F7" and c in "JL":
                           cross = not cross
                        h_entry = ""
            else:
                assert h_entry == ""
                #only add to considered if it is on the same side of the line
                if cross:
                    count += 1

            
    return count

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))