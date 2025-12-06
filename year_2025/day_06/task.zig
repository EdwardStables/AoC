const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const rows = 4;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var num_its: [rows]std.mem.TokenIterator(u8, std.mem.DelimiterType.any) = undefined;
    num_its[0] = std.mem.tokenizeAny(u8, input.items[0], " ");
    num_its[1] = std.mem.tokenizeAny(u8, input.items[1], " ");
    num_its[2] = std.mem.tokenizeAny(u8, input.items[2], " ");
    if (rows > 3) num_its[3] = std.mem.tokenizeAny(u8, input.items[3], " ");
    var op_it = std.mem.tokenizeAny(u8, input.items[rows], " ");

    var s: i64 = 0;
    while (op_it.next()) |op| {
        var sl: i64 = if (op[0] == '*') 1 else 0;
        for (0..rows) |i| {
            if (op[0] == '*') {
                sl *= try std.fmt.parseInt(i64, num_its[i].next().?, 10);
            } else {
                sl += try std.fmt.parseInt(i64, num_its[i].next().?, 10);
            }
        }
        s += sl;
    }

    return s;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var op_index = input.items[0].len;
    var op: u8 = while (op_index > 0) { op_index -= 1; if (input.items[rows][op_index] != ' ') break input.items[rows][op_index]; } else unreachable;

    var sum: i64 = 0;
    var num: i64 = if (op == '*') 1 else 0;
    var i: usize = input.items[0].len;
    while (i > 0) {
        i -= 1;

        var v: i64 = 0;
        var no_num = true;
        for (0..rows) |r| {
            if (input.items[r][i] != ' ') {
                no_num = false;
                v *= 10;
                v += input.items[r][i] - '0';
            }
        }
        if (!no_num) {
            if (op == '*') num *= v else num += v;
        }

        if (no_num) {
            sum += num;
            op = while (op_index > 0) { op_index -= 1; if (input.items[rows][op_index] != ' ') break input.items[rows][op_index]; } else unreachable;
            num = if (op == '*') 1 else 0;
        }
        if (i == 0) {
            sum += num;
        }
    }

    return sum;
}
