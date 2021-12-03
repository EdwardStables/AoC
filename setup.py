#!/usr/bin/env python3
from argparse import ArgumentParser
from requests import get
from datetime import datetime as dt
from os import mkdir, chmod
from os.path import isdir, isfile, join
from subprocess import Popen

def get_session_id():
    with open("session.private") as f:
        return f.read()

def get_args():
    parser = ArgumentParser()
    parser.add_argument("--day", "-d", required=True, type=int, help="What day to setup")
    parser.add_argument("--problem", "-p", action="store_true", help="Open the problem statement in the browser")
    parser.add_argument("--leaderboard", "-l", action="store_true", help="Open the leaderboard in the browser")
    parser.add_argument("--year", "-y", type=int, default=dt.now().year)
    return parser.parse_args()

def get_data(day: int, year: int, session_id: str):
    cookies = {"session" : session_id}
    return get(f"https://adventofcode.com/{year}/day/{day}/input", cookies=cookies)

def create_template(day: int, data: str):
    name = f"{day:02}"
    if isdir(name):
        print("Target directory already exists")
        return 

    mkdir(name)

    with open(join(name, "data.txt"), 'w') as f:
        f.writelines(data.text)

    for problem in ["a.py", "b.py"]:
        if not isfile(file_path := join(name, problem)):
            create_script_template(file_path, day)

def create_script_template(file_path, day):
    template = f"""#!/usr/bin/env python3

with open("{day:02}/data.txt") as f:
    data = f.readlines()

"""

    with open(file_path, 'w') as f:
        f.write(template)

    chmod(file_path, 0o777)

def main():
    args = get_args()
    do_gen = True
    if args.problem:
        do_gen = False
        Popen(f"$BROWSER https://adventofcode.com/{args.year}/day/{args.day}", shell=True)        
    if args.leaderboard:
        do_gen = False
        Popen(f"$BROWSER https://adventofcode.com/{args.year}/leaderboard", shell=True)        
    if do_gen:
        data = get_data(args.day, args.year, get_session_id())
        create_template(args.day, data)

if __name__ == "__main__":
    main()
