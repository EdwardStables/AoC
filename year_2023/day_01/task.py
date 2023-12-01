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

def main_b(data):
    num_strings = [
        "one", "two", "three", "four",
        "five", "six", "seven", "eight", "nine"
    ]
    sum = 0

    for line in data:
        for i, char in enumerate(line):
            found = None
            if char.isnumeric():
                found = int(char)
            else:
                for j, s in enumerate(num_strings):
                    if line[i:i+len(s)] == s:
                        found = j + 1
            if found is None: continue

            sum += 10*int(found)
            break
        for i, char in enumerate(line[::-1]):
            found = None
            end_index = len(line) - i
            if char.isnumeric():
                found = int(char)
            else:
                for j, s in enumerate(num_strings):
                    if line[end_index-len(s):end_index] == s:
                        found = j + 1
            if found is None: continue

            sum += int(found)
            break

    return sum 

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))