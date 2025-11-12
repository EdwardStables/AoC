const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const IntCode = @import("../intcode.zig").IntCode;
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var ic = try IntCode.init(alloc, input.items[0]); defer ic.deinit();
    try ic.pushInput(1);
    if (!ic.execute(false)) {
        std.debug.print("Execute finished with error\n", .{});
    }

    var last_output: i64 = 0;
    while (ic.getOutput()) |out| {
        std.debug.print("Output code {}\n", .{out});
        last_output = out;
    }

    return last_output;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var ic = try IntCode.init(alloc, input.items[0]); defer ic.deinit();
    try ic.pushInput(2);
    if (!ic.execute(false)) {
        std.debug.print("Execute finished with error\n", .{});
    }

    var last_output: i64 = 0;
    while (ic.getOutput()) |out| {
        std.debug.print("Output code {}\n", .{out});
        last_output = out;
    }

    return last_output;
}
