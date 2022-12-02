#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_02/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    overallscore = 0
    for game in data:
        them, me = game.split()
        score = 0

        if me == "X":
            score += 1
        if me == "Y":
            score += 2
        if me == "Z":
            score += 3
        
        if me == "X" and them == "A" or \
           me == "Y" and them == "B" or \
           me == "Z" and them == "C":
           score += 3
        elif me == "X" and them == "C" or \
             me == "Y" and them == "A" or \
             me == "Z" and them == "B":
           score += 6

        overallscore += score

    return overallscore

def main_b(data):
    overallscore = 0
    for game in data:
        them, result = game.split()
        score = 0
        if result == "Z": #win
            score += 6
            if them == "C":
                score += 1
            if them == "A":
                score += 2
            if them == "B":
                score += 3
        if result == "Y": #draw
            score += 3
            if them == "A":
                score += 1
            if them == "B":
                score += 2
            if them == "C":
                score += 3
        if result == "X": #loss
            if them == "B":
                score += 1
            if them == "C":
                score += 2
            if them == "A":
                score += 3
        overallscore += score
    return overallscore

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))