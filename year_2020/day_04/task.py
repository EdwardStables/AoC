#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2020/day_04/{fname}") as f:
        return [l.strip() for l in f]

def preproc(data):
    ppt = []
    act = {}
    for line in data:
        if line == "":
            ppt.append(act)
            act = {}
        else:
            for f in line.split():
                k, v = f.split(":")
                act[k] = v
    ppt.append(act)
    return ppt

def main_a(data):
    ppts = preproc(data)
    valid = 0
    for ppt in ppts:
        keys = sorted(ppt) 
        if keys == ['byr', 'cid', 'ecl', 'eyr', 'hcl', 'hgt', 'iyr', 'pid'] or \
           keys == ['byr', 'ecl', 'eyr', 'hcl', 'hgt', 'iyr', 'pid']:
           valid += 1
    return valid

def main_b(data):
    ppts = preproc(data)
    valid = 0
    c_byr = lambda v: 1920 <= int(v) <= 2002
    c_iyr = lambda v: 2010 <= int(v) <= 2020
    c_eyr = lambda v: 2020 <= int(v) <= 2030
    c_hgt = lambda v: (v.endswith("cm") and (150 <= int(v[:-2]) <= 193)) or (v.endswith("in") and (59 <= int(v[:-2]) <= 76))
    c_hcl = lambda v: (v[0] == "#" and all(c in "0123456789abcdef" for c in v[1:]))
    c_eyc = lambda v: (v in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
    c_pid = lambda v: (len(v) == 9 and all(c in "0123456789" for c in v))
    for ppt in ppts:
        if "byr" not in ppt or not (v:=c_byr(ppt["byr"])):
            continue
        if "iyr" not in ppt or not (v:=c_iyr(ppt["iyr"])):
            continue
        if "eyr" not in ppt or not (v:=c_eyr(ppt["eyr"])):
            continue
        if "hgt" not in ppt or not (v:=c_hgt(ppt["hgt"])):
            continue
        if "hcl" not in ppt or not (v:=c_hcl(ppt["hcl"])):
            continue
        if "ecl" not in ppt or not (v:=c_eyc(ppt["ecl"])):
            continue
        if "pid" not in ppt or not (v:=c_pid(ppt["pid"])):
            continue
        valid += 1

    return valid

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))