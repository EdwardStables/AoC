const std = @import("std");
const clap = @import("clap");

const debug = std.debug;
const io = std.io;

const Config = struct {
    data: []u8,
    a: bool,
    b: bool,
    count: u32,
    allocator: std.mem.Allocator,

    fn deinit(self: *Config) void {
        self.allocator.free(self.data);
    }
};

fn parseArgs(allocator: std.mem.Allocator) !Config {
    // First we specify what parameters our program can take.
    // We can use `parseParamsComptime` to parse a string into an array of `Param(Help)`
    const params = comptime clap.parseParamsComptime(
        \\-a                Run part a
        \\-b                Run part b
        \\-c, --count <u32> Number of iterations to run
        \\-d, --data <str>  Input data path
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

    const data = res.args.data orelse "";
    var config = Config{ .data = "", .a = res.args.a != 0, .b = res.args.b != 0, .count = res.args.count orelse 1, .allocator = allocator };
    config.data = try std.mem.Allocator.dupe(allocator, u8, data);
    return config;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var config = try parseArgs(gpa.allocator());
    defer config.deinit();

    debug.print("Run a: {}\n", .{config.a});
    debug.print("Run b: {}\n", .{config.b});
    debug.print("Path: {s}", .{config.data});
}
