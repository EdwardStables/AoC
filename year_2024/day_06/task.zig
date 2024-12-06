const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 1;

    var pos = aoc.Vec2Init(i16,0,0);
    var dir = aoc.Vec2Init(i16,0,-1);

    const h = input.items.len;
    const w = input.items[0].len;
    var mask = try alloc.alloc(bool, h*w);
    defer alloc.free(mask);

    for (input.items, 0..) |line, y| {
        for (line, 0..) |cell, x| {
            mask[@as(usize,@intCast(y))*w + @as(usize,@intCast(x))] = false;
            if (cell == '^') {
                pos.x = @intCast(x);
                pos.y = @intCast(y);
            }
        }
    }

    while (true) {
        const nextpos = pos.addVec(dir);
        if (nextpos.y >= h or nextpos.y < 0 or nextpos.x >= w or nextpos.x < 0) break;

        //Rotate CW
        if (input.items[@intCast(nextpos.y)][@intCast(nextpos.x)] == '#') {
            const dx = dir.x;
            dir.x = -dir.y;
            dir.y = dx;
            continue;
        }

        mask[@as(usize,@intCast(pos.y))*w + @as(usize,@intCast(pos.x))] = true;
        pos = nextpos;
        if (mask[@as(usize,@intCast(pos.y))*w + @as(usize,@intCast(pos.x))] != true) {
            total += 1;
        }
    }

    return total;
}

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
