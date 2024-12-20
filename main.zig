const std = @import("std");
const config = @import("config");
const aoc = @import("aoc_util.zig");

const Task = fn(std.mem.Allocator, *std.ArrayList([]const u8)) aoc.TaskErrors!i64;
const TaskPair = struct {
    a: Task,
    b: Task,
};

const RunnerErrors = error{OptionError, ResultMismatchError};


fn get_tasks(comptime year: u32, comptime day: u32) TaskPair {
    const file = switch (year) {
        2019 => switch (day) {
                    1 => @import("year_2019/day_01/task.zig"),
                    //2 => @import("year_2019/day_02/task.zig"),
                    else => @compileError("Unknown day defined.")
                },
        2024 => switch (day) {
                    1  => @import("year_2024/day_01/task.zig"),
                    2  => @import("year_2024/day_02/task.zig"),
                    3  => @import("year_2024/day_03/task.zig"),
                    4  => @import("year_2024/day_04/task.zig"),
                    5  => @import("year_2024/day_05/task.zig"),
                    6  => @import("year_2024/day_06/task.zig"),
                    7  => @import("year_2024/day_07/task.zig"),
                    8  => @import("year_2024/day_08/task.zig"),
                    9  => @import("year_2024/day_09/task.zig"),
                    10 => @import("year_2024/day_10/task.zig"),
                    11 => @import("year_2024/day_11/task.zig"),
                    12 => @import("year_2024/day_12/task.zig"),
                    13 => @import("year_2024/day_13/task.zig"),
                    14 => @import("year_2024/day_14/task.zig"),
                    15 => @import("year_2024/day_15/task.zig"),
                    16 => @import("year_2024/day_16/task.zig"),
                    17 => @import("year_2024/day_17/task.zig"),
                    18 => @import("year_2024/day_18/task.zig"),
                    19 => @import("year_2024/day_19/task.zig"),
                    20 => @import("year_2024/day_20/task.zig"),
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

const Options = struct {
    run_task1: bool = false,
    run_task2: bool = false,
    iterations: u32 = 1,
    test_input: bool = false
};

fn get_options(alloc: std.mem.Allocator) !Options {
    var args = try std.process.argsWithAllocator(alloc);
    defer args.deinit();
    var options: Options = .{};

    var count_option_on_next = false;
    var first_arg = true;

    while (args.next()) |arg| {
        if (first_arg) {
            first_arg = false;
            continue;
        } else
        if (count_option_on_next) {
            options.iterations = try std.fmt.parseInt(u32, arg, 10);
            count_option_on_next = false;
        } else
        if (std.mem.eql(u8, arg, "--t1")) {
            options.run_task1 = true;
        } else
        if (std.mem.eql(u8, arg, "--t2")) {
            options.run_task2 = true;
        } else
        if (std.mem.eql(u8, arg, "--test")) {
            options.test_input = true;
        } else
        if (std.mem.eql(u8, arg, "--number")) {
            count_option_on_next = true;
        } else {
            std.log.err("Unknown argument {s}", .{arg});
            return error.OptionError;
        }
    }

    return options;
}

const RunResult = struct {
    value: i64,
    time: f32 
};

fn do_run(alloc: std.mem.Allocator, iterations: u64, func: Task, input: *std.ArrayList([]const u8)) !RunResult {
    var result: RunResult = .{.value=0,.time=0.0};
    const start_time = std.time.microTimestamp();
    for (0..iterations) |i| {
        const res = try func(alloc, input);
        if (i == 0) {
            result.value = res;
        }
        else if (res != result.value) {
            std.log.err("Mismatch error on iteration {d}, value {d} while iteration 0 had result {d}", .{i, res, result.value});
            return error.OptionError;
        }
    }
    result.time = @floatFromInt(std.time.microTimestamp() - start_time);
    result.time /= 1000;
    result.time /= @floatFromInt(iterations);

    return result;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const tasks = get_tasks(config.year, config.day);
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const options = try get_options(gpa.allocator());

    var input = std.ArrayList([]const u8).init(gpa.allocator());
    defer input.deinit();

    try read_input(gpa.allocator(), &input, config.year, config.day, options.test_input);
    defer {
        for (input.items) |s| {
            gpa.allocator().free(s);
        }
    }

    const t1 = if (options.run_task1)
                   try do_run(gpa.allocator(), options.iterations, tasks.a, &input)
               else
                   RunResult{.value=0,.time=0.0};
    const t2 = if (options.run_task2)
                   try do_run(gpa.allocator(), options.iterations, tasks.b, &input)
               else
                   RunResult{.value=0,.time=0.0};

    try stdout.print("Run {d} Day {d} {d} Iterations\n", .{config.year, config.day, options.iterations});
    try stdout.print("1 {s} {d} {e}\n", .{
        if (options.run_task1) "Enabled" else "Disabled",
        t1.value, t1.time});
    try stdout.print("2 {s} {d} {e}\n", .{
        if (options.run_task2) "Enabled" else "Disabled",
        t2.value, t2.time});
}