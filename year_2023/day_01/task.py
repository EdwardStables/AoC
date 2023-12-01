#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_01/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    sum = 0

    for line in data:
        for char in line:
            if char in "0123456789":
                sum += 10*int(char)
                break
        for char in line[::-1]:
            if char in "0123456789":
                sum += int(char)
                break
        
    return sum

def main_b(data):
    sum = 0

    for line in data:
        for i, char in enumerate(line):
            found = None
            if char in "0123456789":
                found = int(char)
            elif char in "otfsen":
                s = line[i:]
                if s[0:3] == "one": found = 1
                elif s[0:3] == "two": found = 2
                elif s[0:5] == "three": found = 3
                elif s[0:4] == "four": found = 4
                elif s[0:4] == "five": found = 5
                elif s[0:3] == "six": found = 6
                elif s[0:5] == "seven": found = 7
                elif s[0:5] == "eight": found = 8
                elif s[0:4] == "nine": found = 9

            if found is None: continue

            sum += 10*int(found)
            break

        for i, char in enumerate(line[::-1]):
            found = None
            if char in "0123456789":
                found = int(char)
            elif char in "eorxnt":
                s = line[:len(line)-i]
                if s[-1] == "e":
                    if s[-3:] == "one": found = 1
                    elif s[-5:] == "three": found = 3
                    elif s[-4:] == "five": found = 5
                    elif s[-4:] == "nine": found = 9
                elif s[-3:] == "two": found = 2
                elif s[-4:] == "four": found = 4
                elif s[-3:] == "six": found = 6
                elif s[-5:] == "seven": found = 7
                elif s[-5:] == "eight": found = 8
            if found is None: continue

            sum += int(found)
            break

    return sum 

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))