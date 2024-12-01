const std = @import("std");
const config = @import("config");
const aoc = @import("aoc_util.zig");

const Task = fn(std.mem.Allocator, std.ArrayList([]const u8)) aoc.TaskErrors!i64;
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

fn read_input(alloc: std.mem.Allocator, output: *std.ArrayList([]const u8), year: u32, day: u32, test_input: bool) !void {
    const file = if (test_input) "test" else "data";
    const filename = try std.fmt.allocPrint(alloc, "year_{d}/day_{d:0>2}/{s}.txt", .{year, day, file});
    defer alloc.free(filename);
    const handle = try std.fs.cwd().openFile(filename, .{});
    defer handle.close();

    while (try handle.reader().readUntilDelimiterOrEofAlloc(alloc, '\n', std.math.maxInt(usize))) |line| {
        defer alloc.free(line);
        try output.append(try std.fmt.allocPrint(alloc, "{s}", .{line}));
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("hello world\n", .{});
    const tasks = get_tasks(config.year, config.day);
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const test_input = false;
    var input = std.ArrayList([]const u8).init(gpa.allocator());
    defer input.deinit();

    try read_input(gpa.allocator(), &input, config.year, config.day, test_input);
    defer {
        for (input.items) |s| {
            gpa.allocator().free(s);
        }
    }

    const t1_result = try tasks.a(gpa.allocator(), input);
    const t2_result = try tasks.b(gpa.allocator(), input);

    std.debug.print("Results: {d} {d}\n", .{t1_result, t2_result});
}