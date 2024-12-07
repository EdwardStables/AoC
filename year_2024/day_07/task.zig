const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn calcRecursive(input: []i64, value: i64, target: i64, concat: bool) bool {
    if (value > target) return false;

    if (input.len == 0) {
        if (value == target) return true;
        return false;
    }
    //Add
    var next_value = value + input[0];
    if (calcRecursive(input[1..], next_value, target, concat)) return true;

    next_value = value * input[0];
    if (calcRecursive(input[1..], next_value, target, concat)) return true;

    if (concat) {
        var mult: i64 = 10;
        while (input[0]>=mult) {
            mult *= 10;
        }
        next_value = value * mult + input[0];
        if (calcRecursive(input[1..], next_value, target, concat)) return true;
    }

    return false;
}

pub fn run(input: *std.ArrayList([]const u8), concat: bool) aoc.TaskErrors!i64 {
    var factors: [12]i64 = undefined;
    var total: i64 = 0;

    for (input.items) |line| {
        var target: i64 = 0;
        var split = std.mem.splitAny(u8, line, " :");
        var ind: u8 = 0;
        while (split.next()) |it| : (ind += 1) {
            switch(ind) {
                0 => target = try std.fmt.parseInt(i64, it, 10),
                1 => continue,
                else => {
                   factors[ind-2] = try std.fmt.parseInt(i64, it, 10);
                }
            }
        }

        ind -= 2; //Length of local array
        if (calcRecursive(factors[1..ind], factors[0], target, concat)) total += target;
    }


    return total;
}

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return run(input, false);
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return run(input, true);
}
