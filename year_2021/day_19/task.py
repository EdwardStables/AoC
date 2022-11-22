#!/usr/bin/env python3
from math import pi, cos, sin
from random import randint

class Point:
    def __init__(self, x,y,z):
        self.x = round(x)
        self.y = round(y)
        self.z = round(z)
    def __eq__(self, other):
        return self.x == other.x and self.y==other.y and self.z == other.z
    def __hash__(self):
        return hash((self.x, self.y, self.z))
    def __repr__(self):
        return f"{self.x} {self.y} {self.z}"
    def __add__(self, other):
        return Point(self.x+other.x, self.y+other.y, self.z+other.z)
    def __sub__(self, other):
        return Point(self.x-other.x, self.y-other.y, self.z-other.z)
    def __lt__(self,other):
        return  (self.x < other.x) or \
                (self.x == other.x and self.y < other.y) or \
                (self.x == other.x and self.y == other.y and self.z < other.z)

def get_data(fname = "data.txt"):
    with open(f"year_2021/day_19/{fname}") as f:
        return [l.strip() for l in f]

def parse(data):
    all_scanners = []
    current_scanner = []

    for line in data:
        if line.startswith("---"):
            continue
        if line == "":
            all_scanners.append(current_scanner)
            current_scanner = []
        else:
            current_scanner.append([int(n) for n in line.split(',')])
    all_scanners.append(current_scanner)
    all_scanners = [[Point(p[0],p[1],p[2]) for p in s] for s in all_scanners]

    return all_scanners

def rotx(d):
    return [Point(1,0,0),            Point(0,cos(d),-sin(d)), Point(0,sin(d),cos(d))]

def roty(d):
    return [Point(cos(d),0,sin(d)),  Point(0,1,0),            Point(-sin(d),0,cos(d))]

def rotz(d):
    return [Point(cos(d),-sin(d),0), Point(sin(d),cos(d),0),  Point(0,0,1)]

rotations = [
     rotx(0),
     rotx(pi/2),
     rotx(pi),
     rotx(1.5*pi),
     roty(0),
     roty(pi/2),
     roty(pi),
     roty(1.5*pi),
     rotz(0),
     rotz(pi/2),
     rotz(pi),
     rotz(1.5*pi),
]

def mult(m1, m2):
    return [ Point(m1[0].x*m2[0].x + m1[0].y*m2[1].x + m1[0].z*m2[2].x,
                m1[0].x*m2[0].y + m1[0].y*m2[1].y + m1[0].z*m2[2].y,
                m1[0].x*m2[0].z + m1[0].y*m2[1].z + m1[0].z*m2[2].z),
        Point(m1[1].x*m2[0].x + m1[1].y*m2[1].x + m1[1].z*m2[2].x,
                m1[1].x*m2[0].y + m1[1].y*m2[1].y + m1[1].z*m2[2].y,
                m1[1].x*m2[0].z + m1[1].y*m2[1].z + m1[1].z*m2[2].z),
        Point(m1[2].x*m2[0].x + m1[2].y*m2[1].x + m1[2].z*m2[2].x,
                m1[2].x*m2[0].y + m1[2].y*m2[1].y + m1[2].z*m2[2].y,
                m1[2].x*m2[0].z + m1[2].y*m2[1].z + m1[2].z*m2[2].z)
    ]

def get_rots():
    #can't figure out why they are/aren't unique, so just create all and only send uniques
    sent = []
    for i in range(4):
        for j in range(4,8):
            for k in range(8,12):
                res = mult(rotations[k],mult(rotations[j],rotations[i]))
                if res not in sent:
                    sent.append(res)
                    yield res

def mat_vec_mult(m, v):
    return Point(m[0].x*v.x + m[0].y*v.y + m[0].z*v.z,
                    m[1].x*v.x + m[1].y*v.y + m[1].z*v.z,
                    m[2].x*v.x + m[2].y*v.y + m[2].z*v.z)

rot_count = 0
def rotate(mat, beacon):
    global rot_count
    rot_count+=1
    return [mat_vec_mult(mat, s) for s in beacon]

new_point_ind = 0
def check_offset_intersection_a(new_points, points):
    global new_point_ind
    new_point_ind %= len(new_points)
    for i, base in enumerate(points):
        matched = 0
        offset = base - new_points[new_point_ind]
        new_points = [p+offset for p in new_points]
        for p in new_points:
            if p in points:
                matched += 1
                if matched >= 12:
                    new_point_ind = 0
                    return new_points, offset
    new_point_ind += 1
    return False, None

new_point_ind_b = 0
def check_offset_intersection_b(new_points, points):
    global new_point_ind_b
    new_point_ind_b %= len(new_points)
    for i, beacon in enumerate(points):
        if beacon is None:
            continue
        for base in beacon:
            matched = 0
            offset = base - new_points[new_point_ind_b]
            offset_new_points = [p+offset for p in new_points]
            for p in offset_new_points:
                if p in beacon:
                    matched += 1
                    if matched >= 12:
                        new_point_ind_b = 0
                        return offset_new_points, offset, i
    new_point_ind_b += 1
    return False, None, None

def main_a(data):
    data = parse(data)
    scanners = set(data[0])
    done = [0]

    while True:
        for i, beacon in enumerate(data):
            if i in done:
                continue
            for r in get_rots():
                points, _ = check_offset_intersection_a(rotate(r,beacon),scanners)
                if points:
                    done.append(i)
                    scanners.update(points)
        if len(done) == len(data):
            break

    return len(scanners)

def main_b(data):
    data = parse(data)
    done = set([0])
    offsets = [Point(0,0,0)] + [None] * (len(data)-1)
    scanner_to_beacon = [set(data[0])] + [None]*(len(data)-1)

    while True:
        for i, beacon in enumerate(data):
            if i in done:
                continue
            for r in get_rots():
                points, offset, rel = check_offset_intersection_b(rotate(r,beacon),scanner_to_beacon)
                if points:
                    print(f"setting {i} with offset {offset} relative to {rel} with offset {offsets[rel]}")
                    offsets[i] = offset 
                    done.add(i)
                    scanner_to_beacon[i] = points
        if len(done) == len(data):
            break

    max_dist = 0
    print(offsets)
    for o1 in offsets:
        for o2 in offsets:
            if o2 == o1:
                continue
            max_dist = max((o1.x - o2.x) + (o1.y - o2.y) + (o1.z - o2.z), max_dist)
    return max_dist

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))