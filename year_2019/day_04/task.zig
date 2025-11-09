const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn valid(val: u32) bool {
    var digit: u32 = 1;
    var lowest: ?u32 = null;
    var seen_double = false;
    while (digit <= 100000) {
        const div_val = val / digit;
        const rem_val = div_val % 10;
        digit *= 10;
        if (lowest != null and rem_val > lowest.?) return false;

        if (lowest != null and rem_val == lowest.?) {
            seen_double = true;
        } else {
            lowest = rem_val;
        }
    }

    return seen_double;
}

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var val = try std.fmt.parseInt(u32, input.items[0][0..6], 10);
    const hi = try std.fmt.parseInt(u32, input.items[0][7..], 10);

    var count: u32 = 0;
    while (val <= hi) : (val += 1) {
        if (valid(@intCast(val))) {
            count += 1;
        }
    }

    return @intCast(count);
}

fn valid2(val: u32) bool {
    var digit: u32 = 1;
    var lowest: ?u32 = null;
    var lowest_count: u16 = 0;
    var seen_double = false;
    while (digit <= 100000) {
        const div_val = val / digit;
        const rem_val = div_val % 10;
        digit *= 10;
        if (lowest != null and rem_val > lowest.?) return false;

        if (lowest != null and rem_val == lowest.?) {
            lowest_count += 1;
        } else {
            if (lowest_count == 1) {
                seen_double = true;
            }
            lowest = rem_val;
            lowest_count = 0;
        }
    }

    return seen_double or lowest_count == 1;
}

pub fn task3(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    if (valid2(112222)) {
        std.debug.print("valid\n", .{});
    } else {
        std.debug.print("invalid\n", .{});
    }
    return 0;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var val = try std.fmt.parseInt(u32, input.items[0][0..6], 10);
    const hi = try std.fmt.parseInt(u32, input.items[0][7..], 10);

    var count: u32 = 0;
    while (val <= hi) : (val += 1) {
        if (valid2(@intCast(val))) {
            count += 1;
        }
    }

    return @intCast(count);
}
