#!/usr/bin/env python3
from pathlib import Path
from argparse import ArgumentError, ArgumentParser
from requests import get
from datetime import datetime as dt
from os import mkdir, chmod, listdir
from os.path import isdir, isfile, join
from subprocess import Popen
from collections import defaultdict
import csv

def get_task(year, day):
    module = __import__(f"year_{year}.day_{day:02}.task")
    return getattr(module, f"day_{day:02}").task

def get_session_id():
    with open("session.private") as f:
        return f.read().strip()

def get_args():
    parser = ArgumentParser()
    parser.add_argument("--day", "-d", type=int, help="What day to setup")
    parser.add_argument("--build", "-b", action="store_true", help="Create day template")
    parser.add_argument("--problem", "-p", action="store_true", help="Open the problem statement in the browser")
    parser.add_argument("--leaderboard", "-l", action="store_true", help="Open the leaderboard in the browser")
    parser.add_argument("--year", "-y", type=int, default=dt.now().year)
    parser.add_argument("--run", "-r", action="store_true", help="Run the given day and print answer + timing info (exc data loading)")
    parser.add_argument("--test", "-t", action="store_true", help="Run the given day with input of 'test.txt'")
    parser.add_argument("--regression", action="store_true", help="Like --run, but runs all days, saves a timestamped dataset")
    parser.add_argument("--count", "-c", type=int, default=1, help="Sets number of tests to run for regression or test")
    parser.add_argument("--benchmark", action="store_true", help="Run timeit on the given day to get a good runtime. Excludes file loading")

    return parser.parse_args()

def get_data(day: int, year: int, session_id: str):
    cookies = {"session" : session_id}
    return get(f"https://adventofcode.com/{year}/day/{day}/input", cookies=cookies)

def create_template(day: int, year:int, data: str):
    t_dir = Path("year_"+str(year)) / f"day_{day:02}"
    if t_dir.is_dir():
        print("Target directory already exists")
        return 

    t_dir.mkdir(parents=True)

    with (t_dir/"data.txt").open('w') as f:
        f.writelines(data.text)

    with (t_dir/"test.txt").open('w') as f:
        pass

    if not (p := t_dir/"task.py").exists():
        create_script_template(p, year, day)

    if not isfile(p := join(t_dir, "task.py")):
        create_script_template(p, year, day)

def create_script_template(file_path: Path, year, day):
    template = f"""#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_{year}/day_{day:02}/{{fname}}") as f:
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

    with file_path.open('w') as f:
        f.write(template)
    file_path.chmod(0o777)

def run(day, year, fname="data.txt"):
    from timeit import default_timer as time
    task = get_task(year, day)
    test_path =  Path("year_" + str(year)) / f"day_{day:02}" / fname
    if fname == "test.txt" and not test_path.exists():
        a_fname = "testa.txt"
    else:
        a_fname = fname
    data = task.get_data(fname=a_fname)

    t1 = time()
    a_res = task.main_a(data) 
    a_time = (time() - t1) * 1000

    if fname == "test.txt" and not test_path.exists():
        b_fname = "testb.txt"
    else:
        b_fname = fname
    data = task.get_data(fname=b_fname) 
    t1 = time()
    b_res = task.main_b(data) 
    b_time = (time() - t1) * 1000

    return [(a_time, a_res), (b_time, b_res)]

def run_day(day, year, count, fname="data.txt"):
    print(f"Year {year} Day {day} {'(test)' if fname != 'data.txt' else ''}")
    a_runs = []
    b_runs = []
    a_res = None
    b_res = None
    for i in range(count):
        a, b = run(day, year, fname=fname)
        a_runs.append(a[0])
        b_runs.append(b[0])
        if i == 0:
            a_res = a[1]
            b_res = b[1]
        else:
            assert a_res == a[1]
            assert b_res == b[1]

    print(f"a: {(sum(a_runs)/count):07.3f}ms          {a_res}")
    print(f"b: {(sum(b_runs)/count):07.3f}ms          {b_res}")
    print(f"{count} Run(s)")

def run_benchmark(day, year):
    from timeit import timeit
    from math import floor
    task = get_task(year, day)
    sample_time = run(day, year)
    a_reps = floor(5000/sample_time[0][0])
    b_reps = floor(5000/sample_time[1][0])

    data = task.get_data()
    a_time = 1000 * timeit(lambda: task.main_a(data), number = a_reps)/a_reps
    data = task.get_data() 
    b_time = 1000 * timeit(lambda: task.main_b(data), number = b_reps)/b_reps


    print(f"Year {year} Day {day} Benchmark")
    print(f"a: {a_time:07.3f}ms  {a_reps} runs")
    print(f"b: {b_time:07.3f}ms  {b_reps} runs")

def run_regression(year, day=None, count=1):
    days = [int(d.split("_")[1]) for d in listdir(f"year_{year}") if d.startswith("day")]
    days.sort()
    results = defaultdict(list)
    for _ in range(count):
        for d in days:
            if day is None or d==day:
                a, b = run(d, year)
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

def open_page(url):
    if Path(".wsl").exists():
        print(url)
    else:
        Popen(f"$BROWSER {url}", shell=True)        

def main():
    args = get_args()
    if args.problem:
        if args.day == None:
            raise ArgumentError("Argument 'problem' requires --day N argument")
        open_page(f"https://adventofcode.com/{args.year}/day/{args.day}")
    elif args.leaderboard:
        open_page(f"https://adventofcode.com/{args.year}/leaderboard")        
    elif args.build:
        if args.day == None:
            raise ArgumentError("Argument 'build' requires --day N argument")
        data = get_data(args.day, args.year, get_session_id())
        create_template(args.day, args.year, data)
    elif args.run:
        if args.day == None:
            raise ArgumentError("Argument 'run' requires --day N argument")
        run_day(args.day, args.year, args.count)
    elif args.test:
        if args.day == None:
            raise ArgumentError("Argument 'run' requires --day N argument")
        run_day(args.day, args.year, args.count, fname="test.txt")
    elif args.regression:
        if args.day is not None:
            run_regression(args.year, day=args.day, count=args.count)
        else:
            run_regression(args.year, count=args.count)
    elif args.benchmark:
        run_benchmark(args.day, args.year)

if __name__ == "__main__":
    main()
