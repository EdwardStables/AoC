#!/usr/bin/env python3
from argparse import ArgumentError, ArgumentParser
from requests import get
from datetime import datetime as dt
from os import mkdir, chmod, listdir
from os.path import isdir, isfile, join
from subprocess import Popen
from collections import defaultdict
import csv

def get_session_id():
    with open("session.private") as f:
        return f.read()

def get_args():
    parser = ArgumentParser()
    parser.add_argument("--day", "-d", type=int, help="What day to setup")
    parser.add_argument("--build", "-b", action="store_true", help="Create day template")
    parser.add_argument("--problem", "-p", action="store_true", help="Open the problem statement in the browser")
    parser.add_argument("--leaderboard", "-l", action="store_true", help="Open the leaderboard in the browser")
    parser.add_argument("--year", "-y", type=int, default=dt.now().year)
    parser.add_argument("--run", "-r", action="store_true", help="Run the given day and print answer + timing info (exc data loading)")
    parser.add_argument("--regression", action="store_true", help="Like --run, but runs all days, saves a timestamped dataset")
    parser.add_argument("--count", "-c", type=int, default=1, help="Sets number of tests to run for regression. Either whole regression c times, or single test c times if `-d` also given")
    parser.add_argument("--benchmark", action="store_true", help="Run timeit on the given day to get a good runtime. Excludes file loading")

    return parser.parse_args()

def get_data(day: int, year: int, session_id: str):
    cookies = {"session" : session_id}
    return get(f"https://adventofcode.com/{year}/day/{day}/input", cookies=cookies)

def create_template(day: int, data: str):
    name = f"day_{day:02}"
    if isdir(name):
        print("Target directory already exists")
        return 

    mkdir(name)

    with open(join(name, "data.txt"), 'w') as f:
        f.writelines(data.text)

    if not isfile(file_path := join(name, "task.py")):
        create_script_template(file_path, day)

def create_script_template(file_path, day):
    template = f"""#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_{day:02}/{{fname}}") as f:
        return [l.strip() for l in f]

def main_a(data):
    return 0

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))"""

    with open(file_path, 'w') as f:
        f.write(template)

    chmod(file_path, 0o777)

def run(day):
    from timeit import default_timer as time
    module = __import__(f"day_{day:02}.task")

    data = module.task.get_data()
    t1 = time()
    a_res = module.task.main_a(data) 
    a_time = (time() - t1) * 1000
    data = module.task.get_data() 
    t1 = time()
    b_res = module.task.main_b(data) 
    b_time = (time() - t1) * 1000

    return [(a_time, a_res), (b_time, b_res)]

def run_day(day):
    print(f"Day {day}")
    a, b = run(day)
    print(f"a: {a[0]:07.3f}ms  {a[1]}")
    print(f"b: {b[0]:07.3f}ms  {b[1]}")

def run_benchmark(day):
    from timeit import timeit
    from math import floor
    module = __import__(f"day_{day:02}.task")
    sample_time = run(day)
    a_reps = floor(5000/sample_time[0][0])
    b_reps = floor(5000/sample_time[1][0])

    data = module.task.get_data()
    a_time = 1000 * timeit(lambda: module.task.main_a(data), number = a_reps)/a_reps
    data = module.task.get_data() 
    b_time = 1000 * timeit(lambda: module.task.main_b(data), number = b_reps)/b_reps


    print(f"Day {day} Benchmark")
    print(f"a: {a_time:07.3f}ms  {a_reps} runs")
    print(f"b: {b_time:07.3f}ms  {b_reps} runs")

def run_regression(day=None, count=1):
    days = [int(d.split("_")[1]) for d in listdir(".") if d.startswith("day")]
    days.sort()
    results = defaultdict(list)
    for _ in range(count):
        for d in days:
            if day is None or d==day:
                a, b = run(d)
                results[d].append((dt.now(), a[0], b[0], a[1], b[1]))

    golden_ans = {k:(v["a answer"],v["b answer"]) for k, v in get_results().items()}

    for day, res_list in results.items():
        if day in golden_ans:
            for res in res_list:
                assert (r:=res[3]) == (g:=golden_ans[day][0]), f"Day {day} a result mismatch, got {r} expected {g}"
                assert (r:=res[4]) == (g:=golden_ans[day][1]), f"Day {day} b result mismatch, got {r} expected {g}"

    for day, res_list in results.items():
        for res in res_list:
            write_entry({
                "DateTime" : res[0],
                "Test" : day,
                "a" : res[1],
                "b" : res[2],
                "a answer" : res[3],
                "b answer" : res[4],
            })

def get_results_csv_header():
    return ["DateTime","Test", "a", "b", "a answer", "b answer"]

def write_entry(data):
    header = get_results_csv_header()
    assert header == read_csv("data/results.csv")[0]
    row = [data[header] for header in header]
    write_results(row)

def write_results(row):
    with open("data/results.csv", 'a') as f:
        writer = csv.writer(f)
        writer.writerow(row)

def get_results():
    csv_results = read_csv("data/results.csv")
    if csv_results == None:
        return {}

    else:
        #verify schema
        header = get_results_csv_header()
        assert header == csv_results[0]
        results = { }
        for res in csv_results[1:]:
            result = {h:res[i] for i, h in enumerate(header)}
            results[int(result["Test"])] = {k:float(v) if k != "DateTime" else v for k,v in result.items() if k != "Test"}

    return results


def read_csv(file):
    if isfile(file):
        with open(file) as f:
            return [line for line in csv.reader(f)]

    else:
        return None

def main():
    args = get_args()
    if args.problem:
        if args.day == None:
            raise ArgumentError("Argument 'problem' requires --day N argument")
        Popen(f"$BROWSER https://adventofcode.com/{args.year}/day/{args.day}", shell=True)        
    elif args.leaderboard:
        Popen(f"$BROWSER https://adventofcode.com/{args.year}/leaderboard", shell=True)        
    elif args.build:
        if args.day == None:
            raise ArgumentError("Argument 'build' requires --day N argument")
        data = get_data(args.day, args.year, get_session_id())
        create_template(args.day, data)
    elif args.run:
        if args.day == None:
            raise ArgumentError("Argument 'run' requires --day N argument")
        run_day(args.day)
    elif args.regression:
        if args.day is not None:
            run_regression(day=args.day, count=args.count)
        else:
            run_regression(count=args.count)
    elif args.benchmark:
        run_benchmark(args.day)

if __name__ == "__main__":
    main()
