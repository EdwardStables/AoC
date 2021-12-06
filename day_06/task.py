#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_06/{fname}") as f:
        return [l.strip() for l in f]

def main(data, day_limit):
    data = map(int,data[0].split(","))
    days = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    for d in data:
        days[d] += 1

    for end_day in range(day_limit):
        days[(end_day-2)%9] += days[end_day%9]

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