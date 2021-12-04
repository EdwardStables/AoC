#!/usr/bin/env python3
from argparse import ArgumentError, ArgumentParser
from requests import get
from datetime import datetime as dt
from os import mkdir, chmod, listdir
from os.path import isdir, isfile, join
from subprocess import Popen

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
    parser.add_argument("--regression", action="store_true", help="Like --run, but runs all days")
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
    from time import time
    module = __import__(f"day_{day:02}.task")

    data = module.task.get_data()
    t1 = time()
    a_res = module.task.main_a(data) 
    a_time = (time() - t1) * 1000
    data = module.task.get_data() 
    t1 = time()
    b_res = module.task.main_b(data) 
    b_time = (time() - t1) * 1000

    print(f"a: {a_time:07.3f}ms  {a_res}")
    print(f"b: {b_time:07.3f}ms  {b_res}")

def run_day(day):
    print(f"Day {day}")
    run(day)

def run_regression():
    days = [int(d.split("_")[1]) for d in listdir(".") if d.startswith("day")]
    days.sort()
    for d in days:
        run_day(d)

def main():
    args = get_args()
    if args.problem:
        if args.day == None:
            raise ArgumentError("Argument 'problem' requires --day N argument")
        Popen(f"$BROWSER https://adventofcode.com/{args.year}/day/{args.day}", shell=True)        
    if args.leaderboard:
        Popen(f"$BROWSER https://adventofcode.com/{args.year}/leaderboard", shell=True)        
    if args.build:
        if args.day == None:
            raise ArgumentError("Argument 'build' requires --day N argument")
        data = get_data(args.day, args.year, get_session_id())
        create_template(args.day, data)
    if args.run:
        if args.day == None:
            raise ArgumentError("Argument 'run' requires --day N argument")
        run(args.day)
    if args.regression:
        run_regression()

if __name__ == "__main__":
    main()
