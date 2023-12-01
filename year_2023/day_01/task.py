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
        "zero", "one", "two", "three", "four",
        "five", "six", "seven", "eight", "nine"
    ]
    sum = 0

    for line in data:
        on_first = True
        potential_last = 0
    
        for i, char in enumerate(line):
            found = None
            if char.isnumeric():
                found = int(char)
            else:
                for j, s in enumerate(num_strings):
                    if line[i:i+len(s)] == s:
                        found = j
            if found is None: continue

            if on_first:
                val = 10 * int(found)
                sum += val
            else:
                potential_last = int(found)
            on_first = False
        
        sum += potential_last
    return sum 

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))