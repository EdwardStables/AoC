const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var orders = std.AutoHashMap(u8, std.ArrayList(u8)).init(alloc);
    defer {
        var it = orders.valueIterator();
        while (it.next()) |val| {
            val.deinit();
        }
        orders.deinit();
    }
    var section2: u32 = 0;

    for (input.items, 0..) |line, ind| {
        if (line.len == 0) {
            section2 = @intCast(ind);
            section2 += 1;
            break;
        }
        const k: u8 = (line[0]-48) * 10 + (line[1]-48);
        const v: u8 = (line[3]-48) * 10 + (line[4]-48);

        var key = try orders.getOrPut(k);
        if (!key.found_existing){
            key.value_ptr.* = try std.ArrayList(u8).initCapacity(alloc, 10);
        }
        try key.value_ptr.append(v);
    }

    var total: i64 = 0;
    var linelist = try std.ArrayList(u8).initCapacity(alloc, 22);
    for (input.items[section2..]) |line| {
        linelist.clearAndFree();
        var lineind: u8 = 0;
        while (lineind < line.len) : ({lineind += 3;}) {
            const val: u8 = (line[lineind]-48) * 10 + (line[lineind+1]-48);
            try linelist.append(val);
        }

        if (!std.sort.isSorted(u8, linelist.items, orders, orderingLessThan)) continue;
        total += linelist.items[linelist.items.len / 2];
    }
    linelist.deinit();


    return total;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var orders = std.AutoHashMap(u8, std.ArrayList(u8)).init(alloc);
    defer {
        var it = orders.valueIterator();
        while (it.next()) |val| {
            val.deinit();
        }
        orders.deinit();
    }
    var section2: u32 = 0;

    for (input.items, 0..) |line, ind| {
        if (line.len == 0) {
            section2 = @intCast(ind);
            section2 += 1;
            break;
        }
        const k: u8 = (line[0]-48) * 10 + (line[1]-48);
        const v: u8 = (line[3]-48) * 10 + (line[4]-48);

        var key = try orders.getOrPut(k);
        if (!key.found_existing){
            key.value_ptr.* = try std.ArrayList(u8).initCapacity(alloc, 10);
        }
        try key.value_ptr.append(v);
    }

    var total: i64 = 0;
    var linelist = try std.ArrayList(u8).initCapacity(alloc, 22);
    for (input.items[section2..]) |line| {
        linelist.clearAndFree();
        var lineind: u32 = 0;
        while (lineind < line.len) : ({lineind += 3;}) {
            const val: u8 = (line[lineind]-48) * 10 + (line[lineind+1]-48);
            try linelist.append(val);
        }

        if (std.sort.isSorted(u8, linelist.items, orders, orderingLessThan)) continue;
        std.sort.insertion(u8, linelist.items, orders, orderingLessThan);
        total += linelist.items[linelist.items.len / 2];
    }

    linelist.deinit();

    return total;
}

fn orderingLessThan(ordering: std.AutoHashMap(u8, std.ArrayList(u8)), lhs:u8, rhs:u8) bool {
    const gt_list = ordering.get(lhs) orelse return false;

    for (gt_list.items) |b| {
        if (rhs == b) {
            return true;
        }
    }

    return false;
}
