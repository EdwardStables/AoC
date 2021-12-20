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
    with open(f"day_19/{fname}") as f:
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

def check_offset_intersection(new_points, points):
    for i, base in enumerate(points):
        matched = 0
        offset = base - new_points[randint(0,len(new_points)-1)]
        new_points = [p+offset for p in new_points]
        for p in new_points:
            if p in points:
                matched += 1
                if matched >= 12:
                    return new_points 
    return False

def main_a(data):
    data = parse(data)
    scanners = set(data[0])
    done = [0]

    while True:
        for i, beacon in enumerate(data):
            if i in done:
                continue
            for r in get_rots():
                points = check_offset_intersection(rotate(r,beacon),scanners)
                if points:
                    done.append(i)
                    scanners.update(points)
        if len(done) == len(data):
            break
        
    return len(scanners)

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))