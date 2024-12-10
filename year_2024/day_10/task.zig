const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn explore(last_level: u8, pos: aoc.Vec2(i16), input: *std.ArrayList([]const u8), seen: *std.ArrayList(aoc.Vec2(i16))) !i64 {
    const size = aoc.Vec2Init(i16, @intCast(input.items[0].len), @intCast(input.items.len));
    if (!pos.inBounds(aoc.Vec2Zero(i16), size)) return 0;

    const level = input.items[@intCast(pos.y)][@intCast(pos.x)];

    if (last_level+1 != level) {
        return 0;
    }
    if (level == 48+9) {
        for (seen.items) |s| {
            if (s.eq(pos)) {
                return 0;
            }
        }
        try seen.append(pos);
        return 1;
    }

    var total: i64 = 0;
    const dirs: [4]aoc.Vec2(i16) = .{
        pos.addVec(aoc.Vec2Init(i16, 1, 0)),
        pos.addVec(aoc.Vec2Init(i16, -1, 0)),
        pos.addVec(aoc.Vec2Init(i16, 0, 1)),
        pos.addVec(aoc.Vec2Init(i16, 0, -1))
    };
    
    for (dirs) |d| {
        var ret: i64 = 0;
        ret = try explore(level, d, input, seen);
        total += ret;
    }
    return total;
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var seen = std.ArrayList(aoc.Vec2(i16)).init(alloc);
    defer seen.deinit();

    var total: i64 = 0;

    for (input.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            if (char != 48) continue;
            const pos = aoc.Vec2Init(i16, @intCast(x), @intCast(y));
            total += try explore(47, pos, input, &seen);
            seen.clearRetainingCapacity();
        }
    }


    return total;
}

fn exploreFull(last_level: u8, pos: aoc.Vec2(i16), input: *std.ArrayList([]const u8), ) !i64 {
    const size = aoc.Vec2Init(i16, @intCast(input.items[0].len), @intCast(input.items.len));
    if (!pos.inBounds(aoc.Vec2Zero(i16), size)) return 0;

    const level = input.items[@intCast(pos.y)][@intCast(pos.x)];

    if (last_level+1 != level) {
        return 0;
    }
    if (level == 48+9) {
        return 1;
    }

    var total: i64 = 0;
    const dirs: [4]aoc.Vec2(i16) = .{
        pos.addVec(aoc.Vec2Init(i16, 1, 0)),
        pos.addVec(aoc.Vec2Init(i16, -1, 0)),
        pos.addVec(aoc.Vec2Init(i16, 0, 1)),
        pos.addVec(aoc.Vec2Init(i16, 0, -1))
    };
    
    for (dirs) |d| {
        var ret: i64 = 0;
        ret = try exploreFull(level, d, input);
        total += ret;
    }
    return total;
}
pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {

    var total: i64 = 0;

    for (input.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            if (char != 48) continue;
            const pos = aoc.Vec2Init(i16, @intCast(x), @intCast(y));
            total += try exploreFull(47, pos, input);
        }
    }


    return total;
}
