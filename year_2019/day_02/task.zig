const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const IntCode = @import("../intcode.zig").IntCode;

const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var ic = try IntCode.init(alloc, input.items[0]); defer ic.deinit();
    ic.setMem(1, 12);
    ic.setMem(2, 2);
    if (!ic.execute(false)) {
        std.debug.print("Execute finished with error\n", .{});
    }
    
    return @intCast(ic.getMem(0).?);
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var ic = try IntCode.init(alloc, input.items[0]); defer ic.deinit();
    
    for (0..100) |noun| {
        for (0..100) |verb| {
            ic.setMem(1, @intCast(noun));
            ic.setMem(2, @intCast(verb));
            if (!ic.execute(false)) {
                std.debug.print("Execute finished with error\n", .{});
            }

            if (ic.getMem(0).? == 19690720) return @intCast(100*noun + verb);
            try ic.resetMemMap(input.items[0]);
        }
    }
    
    return error.Unexpected;
}
