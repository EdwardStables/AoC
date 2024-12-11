const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn run(alloc: Allocator, input: *std.ArrayList([]const u8), iter: u64) aoc.TaskErrors!i64 {
    var map = std.AutoHashMap(u64, u64).init(alloc);
    defer map.deinit();
    var map2 = std.AutoHashMap(u64, u64).init(alloc);
    defer map2.deinit();

    var active: u32 = 0;

    for (input.items[0]) |char| {
        if (char == ' ') {
            const gop = try map.getOrPut(active);
            gop.value_ptr.* = if (gop.found_existing) gop.value_ptr.* + 1 else 1;
            active = 0;
        } else {
            active = active*10 + char - 48;
        }
    }
    const gop = try map.getOrPut(active);
    gop.value_ptr.* = if (gop.found_existing) gop.value_ptr.* + 1 else 1;

    for (0..iter) |_| {
        var it = map.keyIterator();
        while (it.next()) |key_it| {
            const key = key_it.*;
            const count = map.get(key) orelse unreachable;
            if (key == 0) {
                const zerogop = try map2.getOrPut(1);
                zerogop.value_ptr.* = if (zerogop.found_existing) zerogop.value_ptr.* + count else count;
            } else {
                const digits = std.math.log10(key) + 1;
                if (digits % 2 == 1) {
                    const oddgop = try map2.getOrPut(key*2024);
                    oddgop.value_ptr.* = if (oddgop.found_existing) oddgop.value_ptr.* + count else count;
                } else {
                    const factor = std.math.pow(u64, 10, digits/2);
                    const leftgop = try map2.getOrPut(key/factor);
                    leftgop.value_ptr.* = if (leftgop.found_existing) leftgop.value_ptr.* + count else count;
                    const rightgop = try map2.getOrPut(key%factor);
                    rightgop.value_ptr.* = if (rightgop.found_existing) rightgop.value_ptr.* + count else count;
                }
            }
        }
        const tmp = map2;
        map2 = map;
        map = tmp;
        map2.clearRetainingCapacity();
    }

    var total: i64 = 0;
    var it = map.valueIterator();
    while (it.next()) |val_it| {
        total += @intCast(val_it.*);
    }
    return total;
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return run(alloc, input, 25);
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return run(alloc, input, 75);
}
