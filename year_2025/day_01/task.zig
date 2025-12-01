const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var val: i16 = 50;
    var count: i64 = 0;
    for (input.items) |line| {
        const num = try std.fmt.parseInt(i16, line[1..], 10);
        if (line[0] == 'L') {
            val -= num;
        } else {
            val += num;
        }
        val = @mod(val, 100);

        if (val == 0) {
            count += 1;
        }
    }
    return count;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var val: i16 = 50;
    var count: i64 = 0;
    for (input.items) |line| {
        var num = try std.fmt.parseInt(i16, line[1..], 10);
        const update: i16 = if (line[0] == 'L') -1 else 1;
        
        while (num > 0) : (num -= 1) { //it's not dumb if it works
            val += update;
            val = @mod(val, 100);
            if (val == 0) {
                count += 1;
            }
        }

    }
    return count;
}
