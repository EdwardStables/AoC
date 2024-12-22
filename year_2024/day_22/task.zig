const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn bruteforce(start: u64, iterations: u64) u64 {
    var secret = start;

    for (0..iterations) |_| {
        //Step 1
        const m64 = secret * 64;
        secret = m64 ^ secret;
        secret = secret % 16777216;

        //Step 2
        const d32 = secret / 32;
        secret = d32 ^ secret;
        secret = secret % 16777216;

        //Step 3
        const m2048 = secret * 2048;
        secret = m2048 ^ secret;
        secret = secret % 16777216;
    }

    return secret;
}

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    for (input.items) |line| {
        total += @intCast(bruteforce(try std.fmt.parseInt(u64, line, 10), 2000));
    }
    return total;
}

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
