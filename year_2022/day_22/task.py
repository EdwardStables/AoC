#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_22/{fname}") as f:
        return [l.strip("\n") for l in f]

def main_a(data):
    direction = 0
    row = 1
    col = 0
    max_row = 0
    max_col = 0
    for c in range(len(data[0])):
        if data[0][c] == ".":
            col = c + 1
            break
    for i, r in enumerate(data):
        if r == "":
            max_row = i
            break

    max_col = max(len(r) for r in data[0:max_row])

    dirs_linked = data[max_row+1]
    dirs = []
    cur = ""
    for c in dirs_linked:
        c: str
        if c.isdigit():
            cur += c
        else:
            dirs.append(int(cur))
            cur = ""
            dirs.append(c)
    if c != "":
        dirs.append(int(cur))

    print(max_col, max_row)

    for d in dirs:
        if d == "L":
            direction = (direction - 1) % 4
        if d == "R":
            direction = (direction + 1) % 4
        if type(d) == str and d in "RL":
            continue
        
        while d > 0:
            if direction == 0:
                next_pos = [col+1, row]
            if direction == 1:
                next_pos = [col, row+1]
            if direction == 2:
                next_pos = [col-1, row]
            if direction == 3:
                next_pos = [col, row-1]

            if next_pos[0] > max_col:
                next_pos[0] = 1
            if next_pos[0] < 1:
                next_pos[0] = max_col
            if next_pos[1] > max_row:
                next_pos[1] = 1
            if next_pos[1] < 1:
                next_pos[1] = max_row

            ni = data[next_pos[1]-1][next_pos[0]-1]
            while ni == " ":
                if direction == 0:
                    next_pos = [next_pos[0]+1, next_pos[1]]
                if direction == 1:
                    next_pos = [next_pos[0], next_pos[1]+1]
                if direction == 2:
                    next_pos = [next_pos[0]-1, next_pos[1]]
                if direction == 3:
                    next_pos = [next_pos[0], next_pos[1]-1]
                if next_pos[0] > max_col:
                    next_pos[0] = 1
                if next_pos[0] < 1:
                    next_pos[0] = max_col
                if next_pos[1] > max_row:
                    next_pos[1] = 1
                if next_pos[1] < 1:
                    next_pos[1] = max_row
                ni = data[next_pos[1]-1][next_pos[0]-1]

            if ni == ".":
                d -= 1
                row = next_pos[1]
                col = next_pos[0]
                continue
            if ni == "#":
                d = 0
                continue
    return (row*1000) + (col*4) + direction

def board(data, pos):
    for y, row in enumerate(data):
        for x, cell in enumerate(row):
            if pos == Pos(x+1,y+1):
                print("X",end="")
            else:
                print(cell,end="")
        
        print()
        if row == "":
            break

from dataclasses import dataclass

@dataclass
class Pos:
    x:int
    y:int

def main_b(data):
    #pos = Pos(9,1)
    pos = Pos(51,1)
    direction = 0

    max_row = 0
    max_col = 0
    for c in range(len(data[0])):
        if data[0][c] == ".":
            col = c + 1
            break
    for i, r in enumerate(data):
        if r == "":
            max_row = i
            break

    max_col = max(len(r) for r in data[0:max_row])
    dirs_linked = data[max_row+1]
    dirs = []
    cur = ""
    for c in dirs_linked:
        c: str
        if c.isdigit():
            cur += c
        else:
            dirs.append(int(cur))
            cur = ""
            dirs.append(c)
    if c != "":
        dirs.append(int(cur))
    for d in dirs:
        board(data, pos)
        print(d)
        input()
        if d == "L":
            direction = (direction - 1) % 4
        if d == "R":
            direction = (direction + 1) % 4
        if type(d) == str and d in "RL":
            continue
        
        while d > 0:
            np, nd = next_pos_real(pos, direction)
            if np.x > max_col:
                np.x = 1
            if np.x < 1:
                np.x = max_col
            if np.y > max_row:
                np.y = 1
            if np.y < 1:
                np.y = max_row
            print(np, nd)
            if data[np.y-1][np.x-1] == "#":
                d = 0
            else:
                pos = np
                direction = nd
                d -= 1

    return (pos.y*1000) + (pos.x*4) + direction
def next_pos_real(pos, d):
#_12
#_3_
#45_
#6__
    #1 left -> #4 left
    if pos.x == 51 and 0<pos.y<51 and d == 2:
        d = 0
        new_pos = Pos(1,150-pos.y)
    #1 up -> #6 left
    elif 50<pos.x<101 and pos.y==1 and d == 3:
        d = 0
        new_pos = Pos(1,51+pos.y-150)
    #2 up -> #6 down
    elif 100<pos.x<151 and pos.y==1 and d == 3:
        d = 3
        new_pos = Pos(pos.x-100,200)
    #2 right -> #5 right
    elif pos.x==150 and 0<pos.y<51 and d == 0:
        d = 2
        new_pos = Pos(100,150-pos.y)
    #2 down -> #3 right
    elif 100<pos.x<151 and pos.y==50 and d == 1:
        d = 2
        new_pos = Pos(100-(150-pos.x),150)
    #3 left -> #4 up
    elif pos.x==51 and 50<pos.y<101 and d == 2:
        d = 1
        new_pos = Pos(50-(100-pos.y),101)
    #3 right -> #2 down
    elif pos.x==100 and 50<pos.y<101 and d == 0:
        d = 3
        new_pos = Pos(pos.y-50,50)
    #4 left -> #1 left
    elif pos.x==1 and 99<pos.y<151 and d == 2:
        d = 0
        new_pos = Pos(51,50-(101-pos.y))
    #4 up -> #3 left
    elif 0<pos.x<51 and pos.y==101 and d == 3:
        d = 0
        new_pos = Pos(51,100-(50-pos.x))
    #5 right -> #2 right
    elif pos.x==100 and 100<pos.y<151 and d == 0:
        d = 2
        new_pos = Pos(150,50-(101-pos.y))
    #5 down -> #6 right
    elif 50<pos.x<101 and pos.y==150 and d == 1:
        d = 2
        new_pos = Pos(50,100+pos.x)
    #6 left -> #1 up
    elif pos.x==1 and 150<pos.y<201 and d == 2:
        d = 1
        new_pos = Pos(pos.y,1)
    #6 down -> #2 up
    elif 0<pos.x<51 and pos.y==200 and d == 1:
        d = 1
        new_pos = Pos(pos.x+100,1)
    #6 right -> #5 down
    elif pos.x==50 and 150<pos.y<201 and d == 0:
        d = 3
        new_pos = Pos(pos.y-100,150)
    elif d == 0:
        new_pos = Pos(pos.x+1, pos.y)
    elif d == 1:
        new_pos = Pos(pos.x, pos.y+1)
    elif d == 2:
        new_pos = Pos(pos.x-1, pos.y)
    elif d == 3:
        new_pos = Pos(pos.x, pos.y-1)
    
    return new_pos, d

def next_pos_test(pos, dir):
#__1_
#234_
#__56
    #1 up -> #2 up
    if 8<pos.x<13 and pos.y == 1 and dir == 3:
        dir = 1
        new_pos = Pos(4-pos.x+9,5)
    #1 left -> #3 up
    elif pos.x==9 and 0<pos.y<5 and dir == 2:
        dir = 1
        new_pos = Pos(4+pos.y,5)
    #1 right -> #6 right
    elif pos.x==12 and 0<pos.y<5 and dir == 0:
        dir = 1
        new_pos = Pos(4+pos.y,5)
    #2 left  -> #6 down
    elif pos.x == 1 and 4 < pos.y < 9 and dir == 2:
        dir = 4
        new_pos = Pos(16-pos.y+4,12)
    #2 up -> #1 down
    elif 0<pos.x<5 and pos.y == 5 and dir == 3:
        dir = 1
        new_pos = Pos(9+(4-pos.x),1)
    #2 down -> #5 down
    elif 0<pos.x<5 and pos.y == 8 and dir == 1:
        dir = 3
        new_pos = Pos(9+(4-pos.x),12)
    #3 up -> #1 left
    elif 4<pos.x<9 and pos.y == 5 and dir == 3:
        dir = 0
        new_pos = Pos(9,pos.x-4)
    #3 down -> #5 left
    elif 4<pos.x<9 and pos.y == 8 and dir == 1:
        dir = 0
        new_pos = Pos(9,16-pos.x)
    #4 right -> #6 up
    elif pos.x == 12 and 4<pos.y<9 and dir == 0:
        dir = 1
        new_pos = Pos(16-(pos.y-5),9)
    #5 left -> #3 down
    elif pos.x == 9 and 8<pos.y<13 and dir == 2:
        dir = 3
        new_pos = Pos(8-(pos.y-9),8)
    #5 down -> #2 down
    elif 8<pos.x<13 and pos.y == 12 and dir == 1:
        dir = 3
        new_pos = Pos(4-(pos.x-9),8)
    #6 up -> #4 right
    elif 12<pos.x<17 and pos.y == 9 and dir == 3:
        dir = 2
        new_pos = Pos(12,8-(pos.x-13))
    #6 right -> #1 right
    elif pos.x == 16 and 8<pos.y<13 and dir == 0:
        dir = 2
        new_pos = Pos(12,4-(pos.y-9))
    #6 down -> #2 left
    elif 12<pos.x<17 and pos.y == 12 and dir == 1:
        dir = 0
        new_pos = Pos(1,8-(pos.x-13))
    elif dir == 0:
        new_pos = Pos(pos.x+1, pos.y)
    elif dir == 1:
        new_pos = Pos(pos.x, pos.y+1)
    elif dir == 2:
        new_pos = Pos(pos.x-1, pos.y)
    elif dir == 3:
        new_pos = Pos(pos.x, pos.y-1)
    return new_pos, dir
if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))