#!/usr/bin/env python
from timeit import default_timer as time
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
    parser.add_argument("--fetch", "-f", action="store_true", help="Create day template")
    parser.add_argument("--problem", "-p", action="store_true", help="Open the problem statement in the browser")
    parser.add_argument("--leaderboard", "-l", action="store_true", help="Open the leaderboard in the browser")
    parser.add_argument("--year", "-y", type=int, default=dt.now().year)
    parser.add_argument("--run", "-r", action="store_true", help="Run the given day and print answer + timing info (exc data loading)")
    parser.add_argument("--test", "-t", action="store_true", help="Run the given day with input of 'test.txt'")
    parser.add_argument("--regression", action="store_true", help="Like --run, but runs all days, saves a timestamped dataset")
    parser.add_argument("--count", "-c", type=int, default=1, help="Sets number of tests to run for regression or test")
    parser.add_argument("--profile", action="store_true", help="Run cProfile on given day")
    parser.add_argument("--part", type=int, help="Used for profiling. Part 1 or 2. Defaults to 2.", default=2)

    parser.add_argument("--build", "-b", action="store_true", help="Build a zig solution, if present")
    parser.add_argument("--run-zig", "-z", action="store_true", help="Tell --run to use a zig solution, if built")

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

def get_run_funcs(day, year, zig, fname="data.txt"):
    task = get_task(year, day)
    test_path =  Path("year_" + str(year)) / f"day_{day:02}" / fname

    def zig_runner(data, target):
        cmd = f"cd {test_path.parent} && "
        cmd += "task.exe"
        res = Popen(cmd, shell=True)
        res.wait()
        output = test_path.parent/"output.txt"
        if res.returncode != 0 or not output.exists():
            if not output.exists():
                print(f"Exitied with code {res.returncode} but output.txt doesn't exist")
            return 0, 0

        with output.open() as f:
            result, time = f.read().split()
        
        return int(result), int(time)

    def python_runner(data, target):
        t1 = time()
        res = target(data)
        t2 = (time() - t1) * 1000
        return res, t2

    runner = zig_runner if zig else python_runner

    if fname == "test.txt" and not test_path.exists():
        a_fname = "testa.txt"
    else:
        a_fname = fname
    a_data = task.get_data(fname=a_fname)
    a = lambda: runner(a_data, task.main_a)

    if fname == "test.txt" and not test_path.exists():
        b_fname = "testb.txt"
    else:
        b_fname = fname
    b_data = task.get_data(fname=b_fname) 
    b = lambda: runner(b_data, task.main_b)

    return [a, b]


def run_day(day, year, count, zig, fname="data.txt"):
    print(f"Year {year} Day {day} {'(test)' if fname != 'data.txt' else ''}")
    a_runs = []
    b_runs = []
    a_result = None
    b_result = None

    a,b = get_run_funcs(day, year, zig, fname=fname)

    for i in range(count):
        a_res, a_time = a()
        b_res, b_time = b()

        a_runs.append(a_time)
        b_runs.append(b_time)
        if i == 0:
            a_result = a_res
            b_result = b_res
        else:
            assert a_result == a_res
            assert b_result == b_res

    print(f"a: {(sum(a_runs)/count):07.3f}ms          {a_result}")
    print(f"b: {(sum(b_runs)/count):07.3f}ms          {b_result}")
    print(f"{count} Run(s)")

def run_profile(day, year, a_not_b, fname="data.txt"):
    import cProfile
    (a, a_data), (b, b_data) = get_run_funcs(day, year, fname=fname)

    pr = cProfile.Profile()
    if a_not_b:
        pr.runctx("a(a_data)", globals(), locals())
    else:
        pr.runctx("b(b_data)", globals(), locals())
    pr.print_stats()
    pr.dump_stats(f"part_{'a' if a_not_b else 'b'}.prof")

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

def build_zig(day, year):
    cmd = f"cd year_{year}/day_{day:02} && "
    cmd += "zig build-exe task.zig"
    res = Popen(cmd, shell=True)
    res.wait()
    return res.returncode == 0

def main():
    args = get_args()
    if args.problem:
        if args.day == None:
            raise ArgumentError("Argument 'problem' requires --day N argument")
        open_page(f"https://adventofcode.com/{args.year}/day/{args.day}")
    elif args.leaderboard:
        open_page(f"https://adventofcode.com/{args.year}/leaderboard")        
    elif args.fetch:
        if args.day == None:
            raise ArgumentError("Argument 'fetch' requires --day N argument")
        data = get_data(args.day, args.year, get_session_id())
        create_template(args.day, args.year, data)
    elif args.build:
        if args.day == None:
            raise ArgumentError("Argument 'build' requires --day N argument")
        build_zig(args.day, args.year)
    elif args.run:
        if args.day == None:
            raise ArgumentError("Argument 'run' requires --day N argument")
        run_day(args.day, args.year, args.count, args.run_zig)
    elif args.test:
        if args.day == None:
            raise ArgumentError("Argument 'run' requires --day N argument")
        run_day(args.day, args.year, args.count, args.run_zig, fname="test.txt")
    elif args.profile:
        if args.day is None:
            raise ArgumentError("Argument 'profile' requires --day N argument")
        run_profile(args.day, args.year, args.part == 1, fname="test.txt")

if __name__ == "__main__":
    main()
