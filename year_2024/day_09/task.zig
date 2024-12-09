const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const line = input.items[0];
    var total: i64 = 0;

    var start_id: u32 = 0;
    var end_id: u32 = @intCast(line.len / 2);
    var end_index: u32 = @intCast(line.len-1);
    var end_count: u32 = line[end_index]-48;

    var mul_index: u32 = 0;

    outer: for (line, 0..) |char, index| {
        if (index >= end_index) break;
        const value: u32 = char - 48;

        if (index % 2 == 0) { //File
            for (0..value) |_|
            {
                total += mul_index * start_id;
                mul_index += 1;
            }
            start_id += 1;
        } else { //Space
            for (0..value) |_| {
                //Shift the last one back
                if (end_count == 0) {
                    end_id -= 1;
                    end_index -= 2;
                    if (end_index <= index) break :outer;
                    end_count = line[end_index]-48;
                }

                total += mul_index * end_id;
                mul_index += 1;
                end_count -= 1;

            }
        }
    }

    while (end_count > 0) : (end_count-=1) {
        total += mul_index * end_id;
        mul_index += 1;
    }

    return total;
}

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
