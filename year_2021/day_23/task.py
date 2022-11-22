#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_23/{fname}") as f:
        return [l.strip() for l in f]


class Board:
    def __init__(self, board_str):
        self.corridor = [None for _ in range(11)]
        self.room1 = [None, None, None, None]
        self.room2 = [None, None, None, None]
        self.room3 = [None, None, None, None]
        self.room4 = [None, None, None, None]
        self.read(board_str)

    def corridor_count(self):
        count = 0
        for c in self.corridor:
            if c is not None:
                count += 1 
        return count

    def room_count(self, r):
        if r == 1:
            return len([c for c in self.room1 if c is not None])
        if r == 2:
            return len([c for c in self.room2 if c is not None])
        if r == 3:
            return len([c for c in self.room3 if c is not None])
        if r == 4:
            return len([c for c in self.room4 if c is not None])

    def read(self, board_str):
        #corridor
        for i, p in enumerate(board_str[1][1:-2]):
            self.corridor[i] = p if p != '.' else None

        room_depth = len(board_str) - 3
        print(room_depth)

        for d in range(room_depth):
            for r in range(4):
                if board_str[d+2].startswith("###"):
                    ln = board_str[d+2][2:]
                else:
                    ln = board_str[d+2]
                p = ln[1+2*r]
                print(p)
                self.room_from_ind(r+1)[d] =  p if p != '.' else None

    def __repr__(self):
        r1 = [r if r is not None else '.' for r in self.room1 ]
        r2 = [r if r is not None else '.' for r in self.room2 ]
        r3 = [r if r is not None else '.' for r in self.room3 ]
        r4 = [r if r is not None else '.' for r in self.room4 ]
        out = "#############\n"
        out += f"#{''.join(['.' if n == None else n for n in self.corridor])}#\n"

        out += f"###{r1[0]}#{r2[0]}#{r3[0]}#{r4[0]}###\n"
        for i in range(1, len(r1)):
            out += f"  #{r1[i]}#{r2[i]}#{r3[i]}#{r4[i]}#\n"
        out += f"  #########\n"
        return out

    def set_room_from_ind(self, i, v):
        if i == 1:
            self.room1 = v
        if i == 2:
            self.room2 = v
        if i == 3:
            self.room3 = v
        if i == 4:
            self.room4 = v

    def room_from_ind(self, i):
        if i == 1:
            return self.room1
        if i == 2:
            return self.room2
        if i == 3:
            return self.room3
        if i == 4:
            return self.room4

def diff(b1: Board, b2:Board):
    diff_piece = None
    corridor_pos = None
    room_first_pos = None
    first_pos_pos = 0
    room_second_pos = None
    second_pos_pos = 0

    if b1.corridor_count() != b2.corridor_count():
        for i, (c1, c2) in enumerate(zip(b1.corridor, b2.corridor)):
            if c1 != c2:
                corridor_pos = i
    
    for i in range(1,5):
        if (b1rc := b1.room_count(i)) != (b2rc := b2.room_count(i)):
            if room_first_pos is None:
                room_first_pos = i
                first_pos_pos = 1 if max(b1rc, b2rc) == 2 else 2
                if (p := b1.room_from_ind(i)[first_pos_pos-1]) is not None:
                    diff_piece = p
                else:
                    diff_piece = b2.room_from_ind(i)[first_pos_pos-1]
            else:
                room_second_pos = i
                second_pos_pos = 1 if max(b1rc, b2rc) == 2 else 2

    moves = 0

    def room_pos(i):
        if i == 1:
            return 2
        if i == 2:
            return 4
        if i == 3:
            return 6
        if i == 4:
            return 8

    move_index_0 = room_pos(room_first_pos)
    moves += first_pos_pos

    if corridor_pos is not None:
        move_index_1 = corridor_pos
    else:
        move_index_1 = room_pos(room_second_pos)
        moves += second_pos_pos

    moves += abs(move_index_1 - move_index_0)

    return moves, diff_piece
    
def main_a(data):
    return 0
    costs = {
        "A" : 1,
        "B" : 10,
        "C" : 100,
        "D" : 1000
    }
    boards = []
    with open("day_23/soln_a.txt") as f:
        board = []
        for l in f:
            if l == "\n":
                boards.append(Board(board))
                board = []
            else:
                board.append(l.strip())
        boards.append(Board(board))
        
    cost = 0
    for i in range(len(boards)-1):
        moves, piece = diff(boards[i], boards[i+1])
        cost += moves * costs[piece]

    return cost

def read_b(data):
    return data[0:3] + ["#D#C#B#A#","#D#B#A#C#"] + data[3:]

def main_b(data):
    data = read_b(data)
    start_board = Board(data)
    print(start_board)
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))