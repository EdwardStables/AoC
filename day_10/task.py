#!/usr/bin/env python3
from collections import deque
from bisect import insort

def get_data(fname = "data.txt"):
    with open(f"day_10/{fname}") as f:
        return [l.strip() for l in f]

pairs = {
    "(":")",
    "[":"]", 
    "{":"}", 
    "<":">", 
}

def is_corrupt(line):
    lq = deque()
    for c in line:
        if c in "([<{":
            lq.append(c)
        else:
            open = lq.pop()
            exp_close = pairs[open]
            if c != exp_close:
                return (True, c, None)
    return (False, None, lq)

def main_a(data):
    score = 0
    scores = {
        ")" : 3,
        "]" : 57,
        "}" : 1197,
        ">" : 25137,
    }
    for line in data:
        is_c, c, _ = is_corrupt(line)
        if is_c:
            score += scores.get(c)
    return score

def main_b(data):
    score_list = []
    scores = {
        ")" : 1,
        "]" : 2,
        "}" : 3,
        ">" : 4,
    }

    for line in data:
        new_score = 0
        is_c, _, queue = is_corrupt(line)
        if is_c:
            continue

        while len(queue) > 0:
            new_score *= 5
            new_score += scores[pairs[queue.pop()]]
        
        insort(score_list, new_score)

    return score_list[len(score_list)//2]

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))