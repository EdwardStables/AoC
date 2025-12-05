const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const range_len = for (input.items, 0..) |line, i| {
        if (line.len == 0) break i;
    } else unreachable;
    var ranges = try std.ArrayList(aoc.Vec2(u64)).initCapacity(alloc, range_len);
    defer ranges.deinit(alloc);

    for (input.items[0..range_len]) |line| {
        const split = for (line, 0..) |c, i| {
            if (c == '-') break i;
        } else unreachable;

        const left:  u64 = aoc.intParse(u64, line[0..split]);
        const right: u64 = aoc.intParse(u64, line[split+1..]);
        
        try ranges.append(alloc, .{.x=left,.y=right});
    }

    var fresh: i64 = 0;
    for (input.items[range_len+1..]) |line| {
        const id: u64 = aoc.intParse(u64, line);
        for (ranges.items) |range| {
            if (id >= range.x and id <= range.y) {
                fresh += 1;
                break;
            }
        }
    }

    return fresh;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const range_len = for (input.items, 0..) |line, i| {
        if (line.len == 0) break i;
    } else unreachable;
    const R = struct {range: aoc.Vec2(u64), valid: bool};
    var ranges = try std.ArrayList(R).initCapacity(alloc, range_len);
    defer ranges.deinit(alloc);

    outer: for (input.items[0..range_len]) |line| {
        const split = for (line, 0..) |c, i| {
            if (c == '-') break i;
        } else unreachable;

        var left:  u64 = aoc.intParse(u64, line[0..split]);
        var right: u64 = aoc.intParse(u64, line[split+1..]);
        for (ranges.items, 0..) |r, i| {
            if (!r.valid) continue;
            const range = r.range;
            //New range inside existing
            if (range.x <= left and right <= range.y) continue :outer;

            //New range encloses existing
            if (left < range.x and range.y < right) {
                ranges.items[i].valid = false;
                continue;
            }

            //New range overlaps on lower side
            if (left <= range.y and range.y < right) {
                left = range.y+1;
            }

            //New range overlaps on upper side
            if (left < range.x and range.x <= right) {
                right = range.x-1;
            }
            if (right < left) continue :outer;
        }
        try ranges.append(alloc, .{.range=.{.x=left,.y=right}, .valid = true});
    }

    var count: i64 = 0;
    for (ranges.items) |range| {
        if (range.valid)
            count += @intCast(range.range.y - range.range.x + 1);
    }

    return count;
}
