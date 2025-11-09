const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const move = enum {
    up, down, left, right, accept
};

fn getNumPadPos(c: u8) aoc.Vec2(i8) {
    return switch(c) {
        '7' => aoc.Vec2Init(i8, 0, 0),
        '8' => aoc.Vec2Init(i8, 1, 0),
        '9' => aoc.Vec2Init(i8, 2, 0),
        '4' => aoc.Vec2Init(i8, 0, 1),
        '5' => aoc.Vec2Init(i8, 1, 1),
        '6' => aoc.Vec2Init(i8, 2, 1),
        '1' => aoc.Vec2Init(i8, 0, 2),
        '2' => aoc.Vec2Init(i8, 1, 2),
        '3' => aoc.Vec2Init(i8, 2, 2),
        '0' => aoc.Vec2Init(i8, 1, 3),
        'A' => aoc.Vec2Init(i8, 2, 3),
        else => unreachable
    };
}

fn getDirPadPos(d: move) aoc.Vec2(i8) {
    return switch(d) {
        move.up     => aoc.Vec2Init(i8, 1, 0),
        move.down   => aoc.Vec2Init(i8, 1, 1),
        move.left   => aoc.Vec2Init(i8, 0, 1),
        move.right  => aoc.Vec2Init(i8, 2, 1),
        move.accept => aoc.Vec2Init(i8, 2, 0),
    };
}

fn getNumberPadMove(target: aoc.Vec2(i8), pos: aoc.Vec2(i8)) move {
    if (target.x < pos.x) return move.left;
    if (target.y < pos.y) return move.up;
    if (target.y > pos.y) return move.down;
    if (target.x > pos.x) return move.right;
    unreachable;
}

fn getDirPadMove(target: aoc.Vec2(i8), pos: aoc.Vec2(i8)) move {
    if (target.y < pos.y) return move.up;
    if (target.x > pos.x) return move.right;
    if (target.y > pos.y) return move.down;
    if (target.x < pos.x) return move.left;
    unreachable;
}

fn movePosition(target: *aoc.Vec2(i8), dir: move) void {
    switch(dir) {
        move.up    => target.y -= 1,
        move.down  => target.y += 1,
        move.left  => target.x -= 1,
        move.right => target.x += 1,
        else       => unreachable
    }
}

fn pressDirPad(target_pos: move, p1: *aoc.Vec2(i8), p2: *aoc.Vec2(i8), level: u8) i64 {
    //std.debug.print("Update: Level {d} {s}\n", .{level, @tagName(target_pos)});

    if (level == 3) return 1;

    var moves: i64 = 0;
    const pad = switch(level) {
        1 => p1,
        2 => p2,
        else => unreachable
    };

    const target = getDirPadPos(target_pos);

    while (!target.eq(pad.*)) {
        const movedir = getDirPadMove(target, pad.*);
        if (level != 3) {
            moves += pressDirPad(movedir, p1, p2, level+1);
        }
        movePosition(pad, movedir);
    }
    moves += pressDirPad(move.accept, p1, p2, level+1);

    return moves;
}

fn getInputLength(np: *aoc.Vec2(i8), p1: *aoc.Vec2(i8), p2: *aoc.Vec2(i8), line: []const u8) i64 {
    var moves: i64 = 0;
    var target_index: u32 = 0;
    while (target_index < line.len) : (target_index += 1) {
        const target_pos = getNumPadPos(line[target_index]);
        var local_moves: i64 = 0;
        while (!np.eq(target_pos)) {
            const dir = getNumberPadMove(target_pos, np.*);
            movePosition(np, dir);
            local_moves += pressDirPad(dir, p1, p2, 1);
        }
        local_moves += pressDirPad(move.accept, p1, p2, 1);
        moves += local_moves;
        std.debug.print("Char {u} is {d}/{d}\n", .{line[target_index], local_moves, moves});
    }

    return moves;
}

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var numberPadPos = aoc.Vec2Init(i8, 2, 3);
    var dirPad1Pos = aoc.Vec2Init(i8, 2, 0);
    var dirPad2Pos = aoc.Vec2Init(i8, 2, 0);
    var total: i64 = 0;
    for (input.items) |line| {
        const len = getInputLength(&numberPadPos, &dirPad1Pos, &dirPad2Pos, line);
        const factor = try std.fmt.parseInt(u32, line[0..(line.len-1)], 10);
        std.debug.print("Line {s} => {d} x {d}\n", .{line, len, factor});
        total += factor*len;
    }

    return total;
}

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
