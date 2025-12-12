const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var fitcount: i64 = 0;
    for (input.items) |line| {
        if (line.len <= 3) continue;
        const area: u32 = aoc.intParse(u32, line[0..2]) * aoc.intParse(u32, line[3..5]);
        var fillcount: u32 = 0;
        for (0..6) |i| {
            const l = line[7+(i*3)..7+(i*3)+2];
            fillcount += aoc.intParse(u32, l);
        }

        if (fillcount*9 <= area) fitcount += 1;
        
    }
    return fitcount;
}

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
