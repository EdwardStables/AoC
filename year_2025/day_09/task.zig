const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var squares = try alloc.alloc(aoc.Vec2(i64), input.items.len); defer alloc.free(squares);
    for (input.items, 0..) |line, j| {
        const comma = for (line, 0..) |c, i| {if (c == ',') break i;} else unreachable;
        squares[j] = aoc.Vec2Init(i64, aoc.intParse(i64, line[0..comma]),  aoc.intParse(i64, line[comma+1..]));
    }

    var largest: u64 = 0;
    for (squares, 0..) |l, i| {
        for (squares[i+1..]) |r| {
            const size: u64 = (@abs(l.x - r.x)+1) * (@abs(l.y - r.y)+1);
            largest = @max(size, largest);
        }
    }

    return @intCast(largest);
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var squares = try alloc.alloc(aoc.Vec2(i64), input.items.len); defer alloc.free(squares);
    for (input.items, 0..) |line, j| {
        const comma = for (line, 0..) |c, i| {if (c == ',') break i;} else unreachable;
        squares[j] = aoc.Vec2Init(i64, aoc.intParse(i64, line[0..comma]),  aoc.intParse(i64, line[comma+1..]));
    }

    var perimiter = try std.ArrayList(aoc.Vec2(i64)).initCapacity(alloc, 1000); defer perimiter.deinit(alloc);
    
    var point = squares[squares.len-1];
    for (squares) |s| {
        while (!point.eq(s)) {
            try perimiter.append(alloc, point);
            if (s.x == point.x) point.y += if (s.y - point.y > 0) 1 else -1;
            if (s.y == point.y) point.x += if (s.x - point.x > 0) 1 else -1;
        }
    }

    var largest: i64 = 0;
    for (squares, 0..) |s1, i| {
        inner: for (squares[i+1..] ) |s2| {
            const size: i64 = @intCast((@abs(s1.x-s2.x)+1) * (@abs(s1.y-s2.y)+1));
            if (size <= largest) continue;
            for (squares) |p| {
                if (p.x > @min(s1.x, s2.x) and p.x < @max(s1.x, s2.x) and
                    p.y > @min(s1.y, s2.y) and p.y < @max(s1.y, s2.y)) {
                    continue :inner;
                }
            }
            for (perimiter.items) |p| {
                if (p.x > @min(s1.x, s2.x) and p.x < @max(s1.x, s2.x) and
                    p.y > @min(s1.y, s2.y) and p.y < @max(s1.y, s2.y)) {
                    continue :inner;
                }
            }
            largest = size;
        }
    }



    return @intCast(largest);
}
