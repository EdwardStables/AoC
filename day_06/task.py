#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_06/{fname}") as f:
        return [l.strip() for l in f]

def main(data, day_limit):
    data = map(int,data[0].split(","))
    days = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    for d in data:
        days[d] += 1

    day_count = 0

    while day_count < day_limit:
        new_days = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        new_days[8] = days[0]
        new_days[0] = days[1]
        new_days[1] = days[2]
        new_days[2] = days[3]
        new_days[3] = days[4]
        new_days[4] = days[5]
        new_days[5] = days[6]
        new_days[6] = days[7]
        new_days[7] = days[8]
        new_days[6] += days[0]
        days = new_days
        day_count += 1

    return sum(days)
def main_a(data):
    return main(data, 80)

def main_b(data):
    return main(data, 256)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))