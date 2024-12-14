const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = if (input.items.len == 12) aoc.Vec2Init(i32, 11, 7) else aoc.Vec2Init(i32, 101, 103);
    const quad = aoc.Vec2Init(i32, @divFloor(size.x, 2), @divFloor(size.y, 2));
    
    const steps = 100;
    var q1: i64 = 0;
    var q2: i64 = 0;
    var q3: i64 = 0;
    var q4: i64 = 0;

    for (input.items) |line| {
        var pos = aoc.Vec2Zero(i32);
        var vec = aoc.Vec2Zero(i32);

        var split_it = std.mem.splitAny(u8, line, "pv=, ");
        _ = split_it.next();
        _ = split_it.next();
        pos.x = try std.fmt.parseInt(i32, split_it.next().?, 10);
        pos.y = try std.fmt.parseInt(i32, split_it.next().?, 10);
        _ = split_it.next();
        _ = split_it.next();
        vec.x = try std.fmt.parseInt(i32, split_it.next().?, 10);
        vec.y = try std.fmt.parseInt(i32, split_it.next().?, 10);

        pos.x += steps*vec.x;
        pos.y += steps*vec.y;

        pos.x = @mod(pos.x, size.x);
        pos.y = @mod(pos.y, size.y);


        if (pos.x < quad.x and pos.y < quad.y) q1 += 1;
        if (pos.x > quad.x and pos.y < quad.y) q2 += 1;
        if (pos.x < quad.x and pos.y > quad.y) q3 += 1;
        if (pos.x > quad.x and pos.y > quad.y) q4 += 1;
    }


    return q1*q2*q3*q4;
}

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
