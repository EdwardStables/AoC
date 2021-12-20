#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_20/{fname}") as f:
        return [l.strip() for l in f]

def parse(data):
    return data[0], data[2:]

def patch_num(patch):
    patch = patch.replace('.','0')
    patch = patch.replace('#','1')
    num = int(patch, base=2)
    return num

def patch(img, y, x, ext):
    out = ""
    xmax = len(img[0]) - 1
    ymax = len(img) - 1
    #00
    if y == 0 or x == 0:
        out += ext 
    else:
        out += img[y-1][x-1]
    #01
    if y == 0:
        out += ext
    else:
        out += img[y-1][x]
    #02
    if y == 0 or x == xmax:
        out += ext
    else:
        out += img[y-1][x+1]
    #10
    if x == 0:
        out += ext
    else:
        out += img[y][x-1]
    #11
    out += img[y][x]
    #12
    if x == xmax:
        out += ext
    else:
        out += img[y][x+1]
    #20
    if x == 0 or y == ymax:
        out += ext
    else:
        out += img[y+1][x-1]
    #21
    if y == ymax:
        out += ext
    else:
        out += img[y+1][x]
    #22
    if x == xmax or y == ymax:
        out += ext
    else:
        out += img[y+1][x+1]
    return out

def process(img, alg, ext):
    img = expand(img,ext)
    out = []
    for y in range(len(img)):
        row = "" 
        for x in range(len(img[0])):
            row+=alg[patch_num(patch(img, y, x, ext))]
        out.append(row)
    return out

def img_print(img):
    for row in img:
        print(''.join(row))
    print()

def expand(img, ext):
    out = [ext * (len(img[0])+2)]
    for row in img:
        out.append(ext + row + ext)
    out.append(ext * (len(img[0])+2))
    return out

def main(data, limit):
    alg, img = parse(data)
    ext = '.'
    for i in range(limit):
        img = process(img, alg, ext)
        if alg[0] == '#':
            ext = '#' if ext == '.' else '.'

    lit = 0
    for r in img:
        for c in r:
            if c == '#':
                lit += 1
    return lit 

def main_a(data):
    return main(data, 2)

def main_b(data):
    return main(data, 50)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))