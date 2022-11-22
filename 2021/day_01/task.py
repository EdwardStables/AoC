#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_01/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    data = [int(d) for d in data]
    increase = 0
    for i in range(1, len(data)):
        if data[i] > data[i-1]:
            increase += 1

    return increase

def main_b(data):
    data = [int(d) for d in data]
    increase = 0
    for i in range(3, len(data)):
        if data[i] > data[i-3]:
            increase += 1

    return increase

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))