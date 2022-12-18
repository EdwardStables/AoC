#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_18/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    data = [s.split(",") for s in data]
    data = [(int(x),int(y),int(z)) for x,y,z in data]
    return all_surface_area(data)
    
def all_surface_area(data):
    side_count = 0
    cube_store = set()

    for cube in data:
        tests = [
            (cube[0]+1, cube[1], cube[2]),
            (cube[0]-1, cube[1], cube[2]),
            (cube[0], cube[1]+1, cube[2]),
            (cube[0], cube[1]-1, cube[2]),
            (cube[0], cube[1], cube[2]+1),
            (cube[0], cube[1], cube[2]-1),
        ]
        sub = 0
        to_add = 6
        for t in tests:
            if t in cube_store:
                sub += 1
                to_add -= 1
        cube_store.add(cube)
        side_count -= sub
        side_count += to_add

    return side_count

def adjacent_air(data, outside_air, cube, maxx, maxy, maxz):
    tests = [
        (cube[0]+1, cube[1], cube[2]),
        (cube[0]-1, cube[1], cube[2]),
        (cube[0], cube[1]+1, cube[2]),
        (cube[0], cube[1]-1, cube[2]),
        (cube[0], cube[1], cube[2]+1),
        (cube[0], cube[1], cube[2]-1),
    ]

    adjacent_airs = set()
    for t in tests:
        if t in data or t in outside_air:
            continue
        if t[0] < -1 or t[1] < -1 or t[2] < -1 or \
           t[0] > maxx or t[1] > maxy or t[2] > maxz:
           continue
        adjacent_airs.add(t)

    return adjacent_airs


def main_b(data):
    data = [s.split(",") for s in data]
    data = set((int(x),int(y),int(z)) for x,y,z in data)


    max_x = max(x for x,y,z in data)+1
    max_y = max(y for x,y,z in data)+1
    max_z = max(z for x,y,z in data)+1

    outside_air = set()
    outside_air.add((-1,-1,-1))

    while True:
        new_air = set()
        for entry in outside_air:
            new_air |= adjacent_air(data, outside_air, entry, max_x, max_y, max_z)
        if new_air == set():
            break
        else:
            outside_air |= new_air

    outside_size = (2 * (max_x+2) * (max_y+2)) + (2 * (max_x+2) * (max_z+2)) + (2 * (max_y+2) * (max_z+2)) 
    all_area = all_surface_area(outside_air)
    
    return  all_area - outside_size

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))


 
(0, 0, 5), 
(0, 1, 5), 
(0, 2, 5), 
(0, 3, 5), 
(1, 0, 5)
(1, 1, 5), 
(1, 3, 5), 
(2, 0, 5), 
(3, 0, 5), 
(3, 1, 5), 
(3, 3, 5), 