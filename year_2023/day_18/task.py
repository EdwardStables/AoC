#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_18/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    edges = []
    last_pos = (0,0)
    h_lines = []    

    for i, line in enumerate(data):
        d, l, _ = line.split()
        l = int(l)
        if d == "R":
            h_lines.append(i)
            endpos = (last_pos[0]+l,last_pos[1])
        elif d == "L":
            h_lines.append(i)
            endpos = (last_pos[0]-l,last_pos[1])
        elif d == "U":
            endpos = (last_pos[0],last_pos[1]+l)
        elif d == "D":
            endpos = (last_pos[0],last_pos[1]-l)
        else:
            assert False, (d, type(d))
            
        edges.append((last_pos, endpos))
        last_pos = endpos
    
    return area(edges, h_lines)

def main_b(data):
    edges = []
    last_pos = (0,0)
    h_lines = []    

    for i, line in enumerate(data):
        hex = line.split()[-1][2:-1]
        l = int(hex[:-1],base=16)
        d = hex[-1]
        if d == "0":
            h_lines.append(i)
            endpos = (last_pos[0]+l,last_pos[1])
        elif d == "2":
            h_lines.append(i)
            endpos = (last_pos[0]-l,last_pos[1])
        elif d == "3":
            endpos = (last_pos[0],last_pos[1]+l)
        elif d == "1":
            endpos = (last_pos[0],last_pos[1]-l)
        else:
            assert False, (d, type(d))
            
        edges.append((last_pos, endpos))
        last_pos = endpos
    
    return area(edges,h_lines)
    
def area(edges, h_lines):
    sum = 0
    for i in h_lines:
        width = (edges[i][1][0] - edges[i][0][0])
        depth = edges[i][0][1]
        if width > 0:
            width += 1
            depth += 1
            if edges[i-1][0][1] > edges[i][0][1]:
                width -= 1
            if edges[i+1][1][1] > edges[i][1][1]:
                width -= 1
        else:
            width -= 1
            if edges[i-1][0][1] < edges[i][0][1]:
                width += 1
            if edges[i+1][1][1] < edges[i][1][1]:
                width += 1

        sum += width * depth
         
    return sum

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))