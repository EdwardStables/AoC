#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_19/{fname}") as f:
        return [l.strip() for l in f]

def parse(data):
    wf = True
    
    workflows = {}
    parts = []

    for line in data:
        if line == "":
            wf = False
            continue
        if wf:
            name, body = line[:-1].split("{")
            steps = body.split(",")
            workflows[name] = steps
        else:
            attrs = line[1:-1].split(",")
            attrs = [a.split("=") for a in attrs]
            parts.append({a:int(b) for a,b in attrs})

    return workflows, parts

def process(part, workflow):
    for step in workflow:
        if step == "R":
            return "R"        
        if step == "A":
            return "A"

        if ":" not in step:
            return step

        test, action = step.split(":")
        assert "<" in test or ">" in test

        k = test[0]
        v = int(test[2:])
        if "<" in test:
            if part[k] < v:
                return action
        if ">" in test:
            if part[k] > v:
                return action

def main_a(data):
    workflows, parts = parse(data)
    accepted = []

    for part in parts:
        wf = "in"
        while True:
            new_wf = process(part, workflows[wf])
            if new_wf == "R":
                break
            if new_wf == "A":
                accepted.append(part)
                break
            wf = new_wf

    return sum([sum(d.values()) for d in accepted])

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))