#!/usr/bin/env python3
from copy import deepcopy

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_19/{fname}") as f:
        return [l.strip() for l in f]

def parse(data, skip=False):
    wf = True
    
    workflows = {}
    parts = []

    for line in data:
        if line == "":
            if skip:
                return workflows
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
    workflows = parse(data, skip=True)
    end_ranges = []
    
    range_queue = [
        [
            "in",
            {
                "x" : [1,4000],
                "m" : [1,4000],
                "a" : [1,4000],
                "s" : [1,4000]
            }
        ]
    ]
    
    while range_queue:
        wf, ranges = range_queue.pop(0)
        
        bad = False
        for _, (mi, ma) in ranges.items():
            if mi > ma:
                bad = True
        if bad: continue

        for step in workflows[wf]:
            if step == "R":
                break
            if step == "A":
                end_ranges.append(ranges)
                break
            if ":" not in step:
                range_queue.append([step,ranges])
                break

            test, action = step.split(":")
            assert "<" in test or ">" in test
            k = test[0]
            v = int(test[2:])
            if action == "R":
                if ">" in test:
                    ranges[k][1] = min(ranges[k][1], v)
                if "<" in test:
                    ranges[k][0] = max(ranges[k][0], v)
            else:
                new_range = deepcopy(ranges)
                if ">" in test:
                    ranges[k][1] = min(ranges[k][1], v)
                    new_range[k][0] = max(ranges[k][0],v+1)
                if "<" in test:
                    ranges[k][0] = max(ranges[k][0], v)
                    new_range[k][1] = min(ranges[k][1],v-1)
                if action == "A":
                    end_ranges.append(new_range)
                else:
                    range_queue.append([action,new_range])

    total = 0
    for range in end_ranges:
        for _, (mi, ma) in range.items():
            if mi > ma:
                break
        else:
            num = 1
            for _, (mi, ma) in range.items():
                num *= ma - mi + 1
            total += num
                
    return total

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))