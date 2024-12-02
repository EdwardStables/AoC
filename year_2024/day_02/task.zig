 const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    for (input.items) |line| {
        var ind: u32 = 0;
        var prev: i16 = 0;
        var val: i16 = 0;
        var asc = false;
        var valid = true;

        var iter = std.mem.splitAny(u8, line, " ");
        while (iter.next()) |word| : ({
            ind += 1;
            prev = val;
        }) {
            val = try std.fmt.parseInt(i16, word, 10);
            if (ind == 0) {
                continue;
            } else
            if (ind == 1) {
                asc = val > prev;
            }
        
            const diff = @abs(val - prev);

            //Invalid case
            if (asc != (val > prev) or diff < 1 or diff > 3) {
                valid = false;
                break;
            }
        }

        if (valid) total += 1;
    }


    return total;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    for (input.items) |line| {
        var data = [_]i16{0}**8;
        var word_count: u32 = 0;

        var iter = std.mem.splitAny(u8, line, " ");
        while (iter.next()) |word| : ({
            word_count += 1;
        }) {
            data[word_count] = try std.fmt.parseInt(i16, word, 10);
        }

        
        var all_valid = false;
        for (0..word_count+1) |skip| {
            var valid = true;
            var effective_ind: u8 = 0;
            var prev: i16 = 0;
            var asc = false;

            for (0..word_count) |ind| {
                if (ind == skip) continue;
                const val: i16 = data[ind];

                if (effective_ind == 0) {
                    effective_ind+=1;
                    prev = val;
                    continue;
                } else
                if (effective_ind == 1) {
                    asc = val > prev;
                }
        
                const diff = @abs(val - prev);

                //Invalid case
                if (asc != (val > prev) or diff < 1 or diff > 3) {
                    valid = false;
                    break;
                }

                prev = val;
                effective_ind += 1;
            }
            if (valid) {
                all_valid = true;
                break;
            }
        }

        if (all_valid) total += 1;
    }

    return total;
}
