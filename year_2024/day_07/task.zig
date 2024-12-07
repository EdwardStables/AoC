const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const ops = enum {add, mul, cat};

fn calcRecursive(input: []i64, target: i64, concat: bool) bool {
    if (input.len == 0) {
        if (target == 0) return true;
        return false;
    }

    const last = input.len-1;
    
    const addtarget = target - input[last];
    if (calcRecursive(input[0..last], addtarget, concat)) { return true; }

    const multarget = @divTrunc(target, input[last]);
    if (multarget * input[last] == target) {
        if (calcRecursive(input[0..last], multarget, concat)) { return true; }
    }


    if (concat) {
        var cattarget = target;
        var value = input[last];
        while (value>0) {
            const valrem = @mod(value, 10);
            const targetrem = @mod(cattarget, 10);
            if (valrem != targetrem) return false;
            value = @divFloor(value, 10);
            cattarget = @divFloor(cattarget, 10);
        }
        if (calcRecursive(input[0..last], cattarget, concat)) { return true; }
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
        if (calcRecursive(factors[0..ind], target, concat)) total += target;
    }


    return total;
}

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return run(input, false);
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return run(input, true);
}
