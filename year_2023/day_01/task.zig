const std = @import("std");

pub fn task_a(data: [][]u8, len: u16) u64 {
    std.debug.print("{s}\n", .{data[len - 2]});
    return 1;
}

pub fn task_b(data: [][]u8, len: u16) u64 {
    std.debug.print("{s}\n", .{data[len - 2]});
    return 2;
}
