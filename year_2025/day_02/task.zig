const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn digits(num_in: u64) u16 {
    var n: u16 = 1;
    var num = num_in;
    if ( num >= 100000000 ) { n += 8; num /= 100000000; }
    if ( num >= 10000     ) { n += 4; num /= 10000; }
    if ( num >= 100       ) { n += 2; num /= 100; }
    if ( num >= 10        ) { n += 1; }

    return n;
}

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var it = std.mem.tokenizeAny(u8, input.items[0], "-,");
    var inval_sum: i64 = 0;
    while (true) {
        const num_str = it.next() orelse break;
        const lim_str = it.next() orelse unreachable;
        var num = try std.fmt.parseInt(u64, num_str, 10);
        const lim = try std.fmt.parseInt(u64, lim_str, 10);

        while (num <= lim) : (num += 1) {
            const d = digits(num);
            if (d % 2 == 1) continue;
            const div = std.math.pow(u64, 10, @intCast(d/2));
            if (@divFloor(num, div) == @mod(num, div)) {
                inval_sum += @intCast(num);
            }
        }
    }
    return inval_sum;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var it = std.mem.tokenizeAny(u8, input.items[0], "-,");
    var inval_sum: i64 = 0;
    while (true) {
        const num_str = it.next() orelse break;
        const lim_str = it.next() orelse unreachable;
        var num = try std.fmt.parseInt(u64, num_str, 10);
        const lim = try std.fmt.parseInt(u64, lim_str, 10);

        while (num <= lim) : (num += 1) {
            const dig = digits(num);
            if (dig == 1) continue;
            for (1..dig/2+1) |d| {
                if (dig % d != 0) continue;
                const div = std.math.pow(u64, 10, d);
                const val = @mod(num, div);
                var local_num = @divFloor(num, div);

                while (local_num > 0) {
                    if (val != @mod(local_num,div)) break;
                    local_num = @divFloor(local_num, div);
                }
                if (local_num == 0) {
                    inval_sum += @intCast(num);
                    break;
                }
            }
        }
    }
    return inval_sum;
}
