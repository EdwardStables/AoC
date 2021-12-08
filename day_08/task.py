#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_08/{fname}") as f:
        return [l.strip() for l in f]

def get_output_digits(line):
    return line.split('|')[1].split()

def get_all_digits(line):
    return line.replace('|','').split()

def main_a(data):
    outs = []
    for line in data:
        out = get_output_digits(line)
        outs.extend(out)
    count = 0
    for v in outs:
        if len(v) in [2,4,3,7]:
            count += 1

    return count

def main_b(data):
    sum = 0
    for line in data:
        segs = {
            "a" : "",
            "b" : "",
            "c" : "",
            "d" : "",
            "e" : "",
            "f" : "",
            "g" : ""
        }

        nums = {
            
        }

        digs = get_all_digits(line)
        for d in digs:
            if 1 not in nums and len(d) == 2:
                nums[1] = set(d)
            elif 4 not in nums and len(d) == 4:
                nums[4] = set(d)
            elif 7 not in nums and len(d) == 3:
                nums[7] = set(d)
            elif 8 not in nums and len(d) == 7:
                nums[8] = set(d)

        #0: use 1 and 7 to find d
        segs['d'] = (nums[7]-nums[1]).pop()

        #1 use 1 to find 0 and 6
        nums[6] = [n for d in digs if len(d)==6 and not nums[1].issubset(n := set(d))][0]


        #3 use 6 and 1 to find a, b
        segs['a'] = (nums[1] - nums[6]).pop()
        segs['b'] = (nums[1] - set(segs['a'])).pop()

        for d in digs:
            if len(d) != 6:
                continue
            n = set(d)
            if n == nums[6]:
                continue
            elif len(n - nums[4]) == 2:
                nums[9] = n
            else:
                nums[0] = n

        for d in digs:
            if len(d) != 5:
                continue
            if segs['b'] not in d:
                nums[2] = set(d)
            elif segs['a'] not in d:
                nums[5] = set(d)
            else:
                nums[3] = set(d)

        nums = {''.join(sorted(v)) : k for k, v in nums.items()}

        for n, m  in zip(get_output_digits(line), [1000, 100, 10, 1]):
            n = ''.join(sorted(n))
            sum += m * nums[n]

    return sum

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))