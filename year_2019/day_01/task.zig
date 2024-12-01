const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: u64 = 0;

    for (input.items) |line| {
        var val = try std.fmt.parseInt(u64, line, 10);
        val /= 3;
        val -= 2;
        total += val;
    }

    return @as(i64, @intCast(total));
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: u64 = 0;

    for (input.items) |line| {
        var val = try std.fmt.parseInt(u64, line, 10);
        while (val > 5) {
            val /= 3;
            val -= 2;
            total += val;
        }
    }

    return @as(i64, @intCast(total));
}