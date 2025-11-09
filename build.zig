const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "aoc",
        .root_source_file = b.path("main.zig"),
        .target = b.graph.host,
        .optimize = optimize,
    });

    const day = b.option(u32, "day", "Day to build for a given year") orelse 0;
    const year = b.option(u32, "year", "Year to build") orelse 0;

    const options = b.addOptions();
    options.addOption(u32, "day",  day);
    options.addOption(u32, "year", year);

    exe.root_module.addOptions("config", options);
    b.installArtifact(exe);
}
