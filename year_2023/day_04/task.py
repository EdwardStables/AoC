#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_04/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    sum = 0
    for row in data:
        score = 0
        nums, wins = row.split(":")[1].split("|")
        nums = nums.split()
        wins = wins.split()
        for n in nums:
            if n in wins:
                score = 1 if not score else (score*2)
        sum += score
    return sum 

from collections import defaultdict
def main_b(data):
    counts = defaultdict(int)
    for row in data:
        card, game = row.split(":")

        card_id = int(card.split()[1])
        counts[card_id] += 1

        nums, wins = game.split("|")
        nums = nums.split()
        wins = wins.split()

        matching = 0
        for n in nums:
            if n in wins:
                matching += 1

        for i in range(card_id+1,card_id+matching+1):
            counts[i] += counts[card_id]

    return sum(counts.values())

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))