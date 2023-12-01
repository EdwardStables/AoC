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
        on_first = True
        potential_last = 0
    
        for i, char in enumerate(line):
            found = None
            if char.isnumeric():
                found = int(char)
            else:
                for j, s in enumerate(num_strings):
                    if line[i:i+len(s)] == s:
                        found = j + 1
            if found is None: continue

            if on_first:
                val = int(found)
                potential_last = val
                sum += 10*val
            else:
                potential_last = int(found)
            on_first = False
        print(potential_last) 
        sum += potential_last
    return sum 

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))