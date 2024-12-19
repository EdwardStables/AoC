const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn match(target: []const u8, available: *std.ArrayList([]const u8), max_lookahead: usize) bool {
    if (target.len == 0) return true;

    for (1..(1+max_lookahead)) |lookahead_size| {
        if (lookahead_size > target.len) break;

        for (available.items) |test_val| {
            if (std.mem.eql(u8, test_val, target[0..lookahead_size])) {
                if (match(target[lookahead_size..], available, max_lookahead))
                    return true;
            }
        }
    }
    return false;
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var available = std.ArrayList([]const u8).init(alloc);
    defer available.deinit();
    var split_iterator = std.mem.splitAny(u8, input.items[0], ", ");
    var max_in_len: usize = 0;
    while (split_iterator.next()) |it| {
        if (it.len == 0) continue;
        max_in_len = if (it.len > max_in_len) it.len else max_in_len;
        try available.append(it);
    }

    var total: i64 = 0;
    
    for (input.items[2..]) |target| {
        if (match(target, &available, max_in_len))
            total += 1;
    }

    return total;
}

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
