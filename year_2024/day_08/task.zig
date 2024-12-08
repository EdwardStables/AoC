const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = aoc.Vec2Init(i32, @intCast(input.items[0].len), @intCast(input.items.len));
    const coords = std.ArrayList(aoc.Vec2(i32));
    var frequencies = std.AutoHashMap(u8, coords).init(alloc);
    defer {
        var it = frequencies.valueIterator();
        while (it.next()) |val| {
            val.deinit();
        }
        frequencies.deinit();
    }
    for (input.items, 0..) |line, y| {
        for (line, 0..) |cell,x| {
            if (cell == '.') continue;

            var arr = frequencies.get(cell) orelse coords.init(alloc);
            try arr.append(aoc.Vec2Init(i32, @intCast(x), @intCast(y)));
            try frequencies.put(cell, arr);
        }
    }
    var locations = try alloc.alloc(bool, @intCast(size.x*size.y));
    defer alloc.free(locations);
    for (0..@intCast(size.x*size.y)) |i| locations[i] = false;

    var coord_it = frequencies.valueIterator();
    while (coord_it.next()) |sigcoords| {
        for (sigcoords.items, 0..) |c1, ind1| {
            for (sigcoords.items, 0..) |c2, ind2| {
                if (ind1 == ind2) continue;
                const xdiff = c1.x - c2.x;
                const ydiff = c1.y - c2.y;
                const p1 = aoc.Vec2Init(i32, c1.x+xdiff, c1.y+ydiff);
                const p2 = aoc.Vec2Init(i32, c2.x-xdiff, c2.y-ydiff);
                if (p1.inBounds(aoc.Vec2Init(i32, 0, 0), size)) {
                    locations[p1.toIndex(@intCast(size.x))] = true;
                }
                if (p2.inBounds(aoc.Vec2Init(i32, 0, 0), size)) {
                    locations[p2.toIndex(@intCast(size.x))] = true;
                }
            }
        }
    }

    var total: i64 = 0;
    for (0..@intCast(size.x*size.y)) |i| {if(locations[i]) total+=1;}

    return total;
}

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
