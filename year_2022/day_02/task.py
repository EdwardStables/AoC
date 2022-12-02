#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_02/{fname}") as f:
        return [l.strip() for l in f]
        

"""
1 A rock
2 B paper
3 C sisscors

1 X rock
2 Y paper
3 Z sisscors

X C
1 3

Y A
2 1

Z B
3 2
"""
me_int = {"X":1,"Y":2,"Z":3}
them_int = {"A":1,"B":2,"C":3}

def main_a(data):
    overallscore = 0
    for game in data:
        them, me = game.split()
        score = 0

        me = me_int[me]
        them = them_int[them]

        score += me
        
        if me == them:
           score += 3
        elif (them % 3) + 1 == me:
            score += 6
        overallscore += score

    return overallscore

def main_b(data):
    overallscore = 0
    for game in data:
        them, result = game.split()
        them = them_int[them]
        score = 0
        if result == "Z": #win
            score += 6 + (them%3+1)
        if result == "Y": #draw
            score += 3 + them
        if result == "X": #loss
            score += them-1 if them > 1 else 3
        overallscore += score
    return overallscore

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))