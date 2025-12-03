const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var sum: i64 = 0;
    for (input.items) |line| {
        var left_largest: u8 = 0;
        var left_largest_ind: ?usize = 0;
        for (line[0..line.len-1], 0..) |c, i| {
            if (left_largest_ind == null or c > left_largest) {
                left_largest = c;
                left_largest_ind = i;
            }
        }
        var right_largest = line[left_largest_ind.?+1];
        for (line[(left_largest_ind.?+2)..]) |c| {
            if (c > right_largest) {
                right_largest = c;
            }
        }

        sum += (left_largest-48)*10;
        sum += right_largest - 48; 
    }
    return sum;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var sum: i64 = 0;
    for (input.items) |line| {
        var ind: u8 = 12;
        var start_ind: usize = 0;
        while (ind > 0) : (ind -= 1) {
            var largest_found: u8 = 0;
            for (line[start_ind..line.len-(ind-1)], start_ind..) |c, i| {
                if (c > largest_found) {
                    largest_found = c;
                    start_ind = i+1;
                }
            }

            sum += (largest_found-48)*std.math.pow(i64, 10, ind-1);
        }
    }
    return sum;
}
