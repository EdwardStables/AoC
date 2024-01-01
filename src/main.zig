const std = @import("std");
const clap = @import("clap");

////// Task Imports
const y23d01 = @import("y23d01");
////// End Task Imports

const debug = std.debug;
const io = std.io;

const Config = struct {
    year: u32,
    day: u8,
    path: []u8,
    a: bool,
    b: bool,
    count: u32,
    allocator: std.mem.Allocator,

    fn deinit(self: *Config) void {
        self.allocator.free(self.path);
    }
};

fn parseArgs(allocator: std.mem.Allocator) !Config {
    // First we specify what parameters our program can take.
    // We can use `parseParamsComptime` to parse a string into an array of `Param(Help)`
    const params = comptime clap.parseParamsComptime(
        \\-y, --year <u32>  Which year
        \\-d, --day <u8>    Which day
        \\-a                Run part a
        \\-b                Run part b
        \\-c, --count <u32> Number of iterations to run
        \\-p, --path <str>  Input data path
        \\
    );

    // Initialize our diagnostics, which can be used for reporting useful errors.
    // This is optional. You can also pass `.{}` to `clap.parse` if you don't
    // care about the extra information `Diagnostics` provides.
    var diag = clap.Diagnostic{};
    const res = clap.parse(clap.Help, &params, clap.parsers.default, .{ .diagnostic = &diag, .allocator = allocator }) catch |err| {
        // Report useful error and exit
        diag.report(io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    const path = res.args.path orelse "";
    var config = Config{ .year = res.args.year orelse 2023, .day = res.args.day orelse 1, .path = "", .a = res.args.a != 0, .b = res.args.b != 0, .count = res.args.count orelse 1, .allocator = allocator };
    config.path = try std.mem.Allocator.dupe(allocator, u8, path);
    return config;
}

const RunResult = struct {
    time: f32,
    result: u64,
    allocator: std.mem.Allocator = undefined,

    fn format(self: *const RunResult) ![]u8 {
        return try std.fmt.allocPrint(self.allocator, "{d} {d}", .{ self.time, self.result });
    }
};
fn run(config: Config, data: InputData, task: *const fn (data: [][]u8, len: u16) u64) !RunResult {
    const runtimes: u64 = 0;
    var result: u64 = undefined;
    for (0..config.count) |i| {
        const local_result = task(data.data, data.len);
        if (i == 0) {
            result = local_result;
        } else if (local_result != result) {
            return error.ValueError;
        }
    }

    std.debug.print("Got here", .{});

    const average_time: f64 = runtimes / config.count;

    const res = RunResult{ .time = average_time, .result = result };
    std.debug.print("And here", .{});

    return res;
}

const Task = struct { a: *const fn (data: [][]u8, len: u16) u64, b: *const fn (data: [][]u8, len: u16) u64 };

pub fn dummy_a(data: [][]u8, len: u16) u64 {
    _ = data;
    _ = len;
    return 0;
}
pub fn dummy_b(data: [][]u8, len: u16) u64 {
    _ = data;
    _ = len;
    return 0;
}

const InputData = struct {
    data: [][]u8,
    len: u16,
    allocator: std.mem.Allocator,
    fn deinit(self: *InputData) void {
        var i: u16 = 0;
        while (i < self.len) : (i += 1) {
            self.allocator.free(self.data[i]);
        }
        self.allocator.free(self.data);
    }

    fn load_data(path: []u8, allocator: std.mem.Allocator) !InputData {
        const input = try std.fs.cwd().openFile(path, .{});
        defer input.close();

        const buffer: []u8 = try input.readToEndAlloc(allocator, 1024 * 1024);
        defer allocator.free(buffer);
        var split_iterator = std.mem.split(u8, buffer, "\n");

        var data: [][]u8 = try allocator.alloc([]u8, 1024);

        var i: u16 = 0;
        while (split_iterator.next()) |line| : (i += 1) {
            data[i] = try std.mem.Allocator.dupe(allocator, u8, line);
        }

        return InputData{ .data = data, .allocator = allocator, .len = i };
    }
};

fn write_result(result: RunResult) !void {
    const output = try std.fs.cwd().createFile("output.txt", .{});
    defer output.close();
    const output_data = try result.format();
    defer result.allocator.free(output_data);
    _ = try output.write(output_data);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var config = try parseArgs(gpa.allocator());
    defer config.deinit();

    const task: Task = switch (config.year) {
        2023 => switch (config.day) {
            1 => Task{ .a = y23d01.task_a, .b = y23d01.task_b },
            else => Task{ .a = dummy_a, .b = dummy_b },
        },
        else => Task{ .a = dummy_a, .b = dummy_b },
    };

    const target = if (config.a) task.a else task.b;
    var data = try InputData.load_data(config.path, gpa.allocator());
    defer data.deinit();
    var result = try run(config, data, target);
    result.allocator = gpa.allocator();
    try write_result(result);
}
