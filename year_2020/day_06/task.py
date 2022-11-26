#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2020/day_06/{fname}") as f:
        return [l.strip() for l in f]

def group_count(data: str):
    count = 1
    data = sorted(data)
    last = data[0]
    for d in data[1:]:
        if d != last:
            last = d
            count += 1
    return count

def main_a(data):
    sum = 0
    cur_line = ""
    for line in data:
        if line == "":
            sum += group_count(cur_line)
            cur_line = ""
        else:
            cur_line += line

    return sum + group_count(cur_line)

def get_common(data):
    common = set(data[0])
    for d in data[1:]:
        common = common.intersection(set(d))

    return len(common)

def main_b(data):
    sum = 0
    cur_group = []
    for line in data:
        if line == "":
            sum += get_common(cur_group)
            cur_group = []
        else:
            cur_group.append(line)

    return sum + get_common(cur_group)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))