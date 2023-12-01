#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_01/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    sum = 0

    for line in data:
        n = ""
        for char in line:
            if char.isnumeric():
                n += char
        sum += int(n[0] + n[-1])
        
    return sum

def fwd_search(s):
    if s[0] not in "otfsen": return None
    if s[0:3] == "one": return 1
    if s[0:3] == "two": return 2
    if s[0:5] == "three": return 3
    if s[0:4] == "four": return 4
    if s[0:4] == "five": return 5
    if s[0:3] == "six": return 6
    if s[0:5] == "seven": return 7
    if s[0:5] == "eight": return 8
    if s[0:4] == "nine": return 9

    return None

def bwd_search(s):
    if s[-1] not in "eorxnt": return None
    if s[-1] == "e":
        if s[-3:] == "one": return 1
        if s[-5:] == "three": return 3
        if s[-4:] == "five": return 5
        if s[-4:] == "nine": return 9
    if s[-3:] == "two": return 2
    if s[-4:] == "four": return 4
    if s[-3:] == "six": return 6
    if s[-5:] == "seven": return 7
    if s[-5:] == "eight": return 8

    return None

def main_b(data):
    sum = 0

    for line in data:
        for i, char in enumerate(line):
            found = None
            if char.isnumeric():
                found = int(char)
            else:
                found = fwd_search(line[i:])
            if found is None: continue

            sum += 10*int(found)
            break

        for i, char in enumerate(line[::-1]):
            found = None
            if char.isnumeric():
                found = int(char)
            else:
                found = bwd_search(line[:len(line)-i])
            if found is None: continue

            sum += int(found)
            break

    return sum 

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))