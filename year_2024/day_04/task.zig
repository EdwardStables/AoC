const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn checkForXMAS(input: *std.ArrayList([]const u8), start: aoc.Vec2(i32), dir: aoc.Vec2(i32)) bool {
    if (dir.x == -1 and start.x < 3) return false;
    if (dir.x == 1  and start.x >= input.items[0].len-3) return false;
    if (dir.y == -1 and start.y < 3) return false;
    if (dir.y == 1  and start.y >= input.items.len-3) return false;

    var pos = start;
    pos = pos.addVec(dir);
    if (input.items[@intCast(pos.y)][@intCast(pos.x)] != 'M') return false;
    pos = pos.addVec(dir);
    if (input.items[@intCast(pos.y)][@intCast(pos.x)] != 'A') return false;
    pos = pos.addVec(dir);
    if (input.items[@intCast(pos.y)][@intCast(pos.x)] != 'S') return false;
    return true;
}

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    for (input.items, 0..) |row, y| {
        for (row, 0..) |cell, x| {
            if (cell != 'X') continue;
            if (checkForXMAS(input, aoc.Vec2Init(i32, @intCast(x), @intCast(y)), aoc.Vec2Init(i32, @intCast( 1), @intCast( 0)))) total += 1;
            if (checkForXMAS(input, aoc.Vec2Init(i32, @intCast(x), @intCast(y)), aoc.Vec2Init(i32, @intCast( 1), @intCast( 1)))) total += 1;
            if (checkForXMAS(input, aoc.Vec2Init(i32, @intCast(x), @intCast(y)), aoc.Vec2Init(i32, @intCast( 0), @intCast( 1)))) total += 1;
            if (checkForXMAS(input, aoc.Vec2Init(i32, @intCast(x), @intCast(y)), aoc.Vec2Init(i32, @intCast(-1), @intCast( 1)))) total += 1;
            if (checkForXMAS(input, aoc.Vec2Init(i32, @intCast(x), @intCast(y)), aoc.Vec2Init(i32, @intCast(-1), @intCast( 0)))) total += 1;
            if (checkForXMAS(input, aoc.Vec2Init(i32, @intCast(x), @intCast(y)), aoc.Vec2Init(i32, @intCast(-1), @intCast(-1)))) total += 1;
            if (checkForXMAS(input, aoc.Vec2Init(i32, @intCast(x), @intCast(y)), aoc.Vec2Init(i32, @intCast( 0), @intCast(-1)))) total += 1;
            if (checkForXMAS(input, aoc.Vec2Init(i32, @intCast(x), @intCast(y)), aoc.Vec2Init(i32, @intCast( 1), @intCast(-1)))) total += 1;
        }
    }
    return total;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    for (input.items, 0..) |row, y| {
        for (row, 0..) |cell, x| {
            if (cell != 'A') continue;
            if (y == 0 or y == input.items.len-1) continue;
            if (x == 0 or x == input.items[0].len-1) continue;
        
            if (
                (input.items[y-1][x-1] == 'M' and input.items[y+1][x+1] == 'S' or
                 input.items[y-1][x-1] == 'S' and input.items[y+1][x+1] == 'M') and
                (input.items[y-1][x+1] == 'M' and input.items[y+1][x-1] == 'S' or
                 input.items[y-1][x+1] == 'S' and input.items[y+1][x-1] == 'M')
            ) total += 1;
        }
    }
    return total;
}
