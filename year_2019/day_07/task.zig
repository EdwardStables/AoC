const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const IntCode = @import("../intcode.zig").IntCode;
const Allocator = std.mem.Allocator;

fn run(ic: *IntCode, program: []const u8, config: []i32) !i64 {
    var out: i32 = 0;

    for (0..5) |ind| {
        try ic.resetMemMap(program);
        try ic.pushInput(config[ind]);
        try ic.pushInput(out);
        _=ic.execute(false);
        out = ic.getOutput().?;
    }

    return out;
}

fn permutations(ic: *IntCode, program: []const u8, max: *i64, k: usize, config: []i32) !void {
    if (k == 1) {
        const output = try run(ic, program, config);
        if (output > max.*) {
            max.* = output;
        }
    } else {
        try permutations(ic, program, max, k-1, config);
        for (0..k-1) |i| {
            if (k % 2 == 0) {
                const t = config[i];
                config[i] = config[k-1];
                config[k-1] = t;
            } else {
                const t = config[0];
                config[0] = config[k-1];
                config[k-1] = t;
            }
            try permutations(ic, program, max, k-1, config);
        }
    }
}

pub fn task4(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var ic = try IntCode.init(alloc, input.items[0]); defer ic.deinit();
    var max: i64 = 0;
    var config = [5]i32{0, 1, 2, 3, 4};
    try permutations(&ic, input.items[0], &max, 5, &config);
    return max;
}

fn run2(ic: []*IntCode, program: []const u8, config: []i32) !i64 {
    var out: i32 = 0;
    for (0..5) |ind| {
        try ic[ind].resetMemMap(program);
        try ic[ind].pushInput(config[ind]);
    }

    try ic[0].pushInput(0);
    const debug = false;

    while (true) {
        out = ic[0].executeUntilOutput(debug) orelse break;
        try ic[1].pushInput(out);
        out = ic[1].executeUntilOutput(debug) orelse break;
        try ic[2].pushInput(out);
        out = ic[2].executeUntilOutput(debug) orelse break;
        try ic[3].pushInput(out);
        out = ic[3].executeUntilOutput(debug) orelse break;
        try ic[4].pushInput(out);
        out = ic[4].executeUntilOutput(debug) orelse break;
        try ic[0].pushInput(out);
    }

    return out;
}

fn permutations2(ic: []*IntCode, program: []const u8, max: *i64, k: usize, config: []i32) !void {
    if (k == 1) {
        const output = try run2(ic, program, config);
        if (output > max.*) {
            max.* = output;
        }
    } else {
        try permutations2(ic, program, max, k-1, config);
        for (0..k-1) |i| {
            if (k % 2 == 0) {
                const t = config[i];
                config[i] = config[k-1];
                config[k-1] = t;
            } else {
                const t = config[0];
                config[0] = config[k-1];
                config[k-1] = t;
            }
            try permutations2(ic, program, max, k-1, config);
        }
    }
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var ic0 = try IntCode.init(alloc, input.items[0]); defer ic0.deinit();
    var ic1 = try IntCode.init(alloc, input.items[0]); defer ic1.deinit();
    var ic2 = try IntCode.init(alloc, input.items[0]); defer ic2.deinit();
    var ic3 = try IntCode.init(alloc, input.items[0]); defer ic3.deinit();
    var ic4 = try IntCode.init(alloc, input.items[0]); defer ic4.deinit();

    var max: i64 = 0;
    var ic = [5]*IntCode{&ic0,&ic1,&ic2,&ic3,&ic4};

    var config = [5]i32{5, 6, 7, 8, 9};
    try permutations2(&ic, input.items[0], &max, 5, &config);

    return max;
}
