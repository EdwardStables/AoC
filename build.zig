const std = @import("std");

pub fn build(b: *std.Build) void {
    //b.option(u32, "day", "Which day to build for given year");

    const exe = b.addExecutable(.{
        .name = "aoc",
        .root_source_file = b.path("main.zig"),
        .target = b.host,
    });
    b.installArtifact(exe);
}
