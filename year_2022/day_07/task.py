#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_07/{fname}") as f:
        return [l.strip() for l in f]

class Dir:
    def __init__(self):
        self.files = []
        self.dirs = {}
        self.parent = None
        self.size = None

def iterate_sizes(pwd):
    pwd.size = sum(pwd.files)
    for name, ptr in pwd.dirs.items():
        iterate_sizes(ptr)
        pwd.size += ptr.size

def get_all_sizes(pwd, arr):
    arr.append(pwd.size)
    for name, ptr in pwd.dirs.items():
        get_all_sizes(ptr, arr)

def parse(data):
    root = Dir()
    cwd = None
    ls_mode = False
    for line in data:
        if ls_mode:
            if line[0] == "$":
                ls_mode = False
            else:
                if line[:4] == "dir ":
                    d = Dir()
                    d.parent = cwd
                    cwd.dirs[line[4:]] = d
                else:
                    cwd.files.append(int(line.split()[0]))
        if not ls_mode:
            if line.startswith("$ cd "):
                target = line[5:]
                if target == "/":
                    cwd = root
                elif target == "..":
                    cwd = cwd.parent
                else:
                    cwd = cwd.dirs[target]
            if line == "$ ls":
                ls_mode = True
    return root

def main_a(data):
    root = parse(data)
    iterate_sizes(root)
    all_dir_sizes = []
    get_all_sizes(root, all_dir_sizes)
    all_dir_sizes = [v for v in all_dir_sizes if v <= 100000]
    return sum(all_dir_sizes)

def main_b(data):
    root = parse(data)
    iterate_sizes(root)
    all_dir_sizes = []
    get_all_sizes(root, all_dir_sizes)
    all_dir_sizes.sort()
    to_free = 30000000 - (70000000-root.size)
    for s in all_dir_sizes:
        if s >= to_free:
            return s

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))