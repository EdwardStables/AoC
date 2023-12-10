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
    bot = data[Sy+1][Sx] in "|JL" and Sy > 0
    top = data[Sy-1][Sx] in "|F7" and Sy < len(data)-1
    right = data[Sy][Sx+1] in "-J7" and Sx < len(data[0])-1
    left = data[Sy][Sx-1] in "-FL" and Sx > 0
    if bot and top:
        data[Sy] = data[Sy].replace("S", "|")
    if bot and right:
        data[Sy] = data[Sy].replace("S", "F")
    if bot and left:
        data[Sy] = data[Sy].replace("S", "7")
    if top and right:
        data[Sy] = data[Sy].replace("S", "L")
    if top and left:
        data[Sy] = data[Sy].replace("S", "J")
    if left and right:
        data[Sy] = data[Sy].replace("S", "-")

    inside = set()
    not_inside = set()
    for y, line in enumerate(data):
        for x, char in enumerate(line):
            if (y,x) in positions: continue
            if (y,x) in inside: continue
            if (y,x) in not_inside: continue
            dir = -1 if x<len(data)/2 else 1
            crosses = 0
            xn = x+dir
            skip = False
            h_entry = ""
            considered = set()
            considered.add((y,x))
            while xn >= 0 and xn < len(data[0]):

                #already hit this point and not crossed outside
                if data[y][xn] in inside and crosses%2 == 0:
                    inside = inside.union(considered)
                    skip = True
                    break

                if data[y][xn] in not_inside and crosses%2 == 1:
                    not_inside = not_inside.union(considered)
                    skip = True
                    break

                #standard line cross
                if (y,xn) in positions:
                    c = data[y][xn]
                    if c == "|":
                        assert h_entry == "", (h_entry, (y,x), (y,xn))
                        crosses += 1
                    elif c == "-":
                        assert h_entry != ""
                    elif c in "JLF7":
                        if h_entry == "":
                            h_entry = c
                        else:
                            #crosses still
                            if h_entry in "JL" and c in "F7" or\
                               h_entry in "F7" and c in "JL":
                               crosses += 1
                            h_entry = ""
                else:
                    assert h_entry == ""
                    #only add to considered if it is on the same side of the line
                    if crosses % 2 == 0:
                        considered.add((y,xn))

                xn += dir

            if skip:
                continue

            assert h_entry == ""
            #at least 1 cross means inside
            if crosses % 2 == 1:
                inside = inside.union(considered)
            else:
                not_inside = not_inside.union(considered)

            
    return len(inside)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))