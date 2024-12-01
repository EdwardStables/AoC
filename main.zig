const std = @import("std");
const config = @import("config");
const aoc = @import("aoc_util.zig");

const Task = fn(std.mem.Allocator) aoc.TaskErrors!i64;
const TaskPair = struct {
    a: Task,
    b: Task,
};

fn get_tasks(comptime year: u32, comptime day: u32) TaskPair {
    const file = switch (year) {
        2019 => switch (day) {
                    1 => @import("year_2019/day_01/task.zig"),
                    else => @compileError("Unknown day defined.")
                },
        else => @compileError("Unknown year defined.")
    };

    return .{.a=file.task1, .b=file.task2};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("hello world\n", .{});
    const tasks = get_tasks(2019, 1);
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    _ = try tasks.a(gpa.allocator());
    _ = try tasks.b(gpa.allocator());
}