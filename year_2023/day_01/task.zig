const std = @import("std");

pub fn task_a(data: [][]u8, len: u16) u64 {
    var i: u16 = 0;
    while (i < len) : (i += 1) {
        std.debug.print("{d}\n", .{i});
        std.debug.print("{s}\n", .{data[i]});
    }
    return 0;
}

pub fn task_b(data: [][]u8, len: u16) u64 {
    var i: u16 = 0;
    while (i < len) : (i += 1) {
        std.debug.print("{d}\n", .{i});
        std.debug.print("{s}\n", .{data[i]});
    }
    return 0;
}
