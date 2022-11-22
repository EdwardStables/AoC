#!/usr/bin/env python3
from math import prod

def get_data(fname = "data.txt"):
    with open(f"year_2021/day_16/{fname}") as f:
        return [l.strip() for l in f]

def b2d(num):
    return int(num,base=2)

def h2b(num):
    res = ""
    for c in num:
        res += f"{int(c,base=16):04b}"
    return res

class Packet:
    def __init__(self, bits):
        self.bits = bits
        self.version = None
        self.type = None
        self.ID = None

        self.isliteral = None
        self.literals = ""
        self.literal_val = 0
        self.sub_packets = []
        self.length = 6

    def parse_literal(self):
        literal_bits = self.bits[6:]
        pointer = 0
        while True:
            self.literals += literal_bits[pointer+1:pointer+5]
            self.length += 5
            if literal_bits[pointer] == '0':
                break
            else:
                pointer += 5
        self.literal_val = b2d(self.literals)

    def parse_operator(self):
        self.ID = self.bits[6]
        if self.ID == '0':
            self.length += 15
            sub_packet_length = b2d(self.bits[7:22])
            self.parse_N_packet_bits(self.bits[22:22+sub_packet_length])
        else:
            self.length += 11
            sub_packet_count = b2d(self.bits[7:18])
            self.parse_N_packets(sub_packet_count)

    def parse_N_packet_bits(self, bits):
        self.length += len(bits)
        start = 22
        while start < 22+len(bits):
            new_packet = Packet(self.bits[start:])
            new_len = new_packet.parse()
            start += new_len
            self.sub_packets.append(new_packet)

    def parse_N_packets(self, count):
        start = 18
        for _ in range(count):
            new_packet = Packet(self.bits[start:])
            new_len = new_packet.parse()
            self.length += new_len
            start += new_len
            self.sub_packets.append(new_packet)

    def __repr__(self):
        str = f"Version: {self.version}\nType: {self.type}"
        if self.isliteral:
            str += f"\nLiteral val: {self.literal_val}"
        else:
            str += f"\nID: {len(self.ID)}"
            str += f"\nNum sub: {len(self.sub_packets)}"
        return str

    def parse(self):
        self.version = b2d(self.bits[:3])
        self.type = b2d(self.bits[3:6])
        
        if self.type == 4:
            self.isliteral = True
            self.parse_literal()
        else:
            self.isliteral = False
            self.length += 1
            self.parse_operator()
            self.run_operator()
        return self.length

    def run_operator(self):
        vals = [p.literal_val for p in self.sub_packets]
        if self.type == 0:
            self.literal_val = sum(vals)
        elif self.type == 1:
            self.literal_val = prod(vals)
        elif self.type == 2:
            self.literal_val = min(vals)
        elif self.type == 3:
            self.literal_val = max(vals)
        elif self.type == 5:
            self.literal_val = 1 if vals[0] > vals[1] else 0
        elif self.type == 6:
            self.literal_val = 1 if vals[0] < vals[1] else 0
        elif self.type == 7:
            self.literal_val = 1 if vals[0] == vals[1] else 0

def sum_ver(p: Packet):
    if not p.sub_packets:
        return p.version
    else:
        return p.version + sum(sum_ver(sp) for sp in p.sub_packets)

def main_a(data):
    data = h2b(data[0])
    packet = Packet(data)
    packet.parse()
    return sum_ver(packet)

def main_b(data):
    data = h2b(data[0])
    packet = Packet(data)
    packet.parse()
    return packet.literal_val

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))