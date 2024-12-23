const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn bruteforce(start: u64, iterations: u64) u64 {
    var secret = start;

    for (0..iterations) |_| {
        //Step 1
        const m64 = secret * 64;
        secret = m64 ^ secret;
        secret = secret % 16777216;

        //Step 2
        const d32 = secret / 32;
        secret = d32 ^ secret;
        secret = secret % 16777216;

        //Step 3
        const m2048 = secret * 2048;
        secret = m2048 ^ secret;
        secret = secret % 16777216;
    }

    return secret;
}

const hist = struct { _1: i5, _2: i5, _3: i5, _4: i5 };

fn changes(alloc: Allocator, start: u64) !std.AutoHashMap(hist, u4) {
    var hists = std.AutoHashMap(hist, u4).init(alloc);
    var _1: i5 = 0;
    var _2: i5 = 0;
    var _3: i5 = 0;
    var _4: i5 = 0;
    var prev_price: i5 = @intCast(start % 10);
    var have_hist: u32 = 0;
    var secret = start;

    for (0..2000) |_| {
        secret = bruteforce(secret, 1);
        const price: i5 = @intCast(secret % 10);
        const diff: i5 = price - prev_price;
        prev_price = price;

        _4 = _3;
        _3 = _2;
        _2 = _1;
        _1 = diff;
        have_hist += 1;

        if (have_hist > 4) {
            const h: hist = .{ ._1 = _1, ._2 = _2, ._3 = _3, ._4 = _4 };
            if (!hists.contains(h)) {
                try hists.put(h, @intCast(price));
            }
        }
    }

    return hists;
}

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    for (input.items) |line| {
        total += @intCast(bruteforce(try std.fmt.parseInt(u64, line, 10), 2000));
    }
    return total;
}

fn profitFromHist(all_hists: *std.ArrayList(std.AutoHashMap(hist, u4)), test_hist: hist) u64 {
    var total: u64 = 0;
    for (all_hists.items) |inp| {
        total += inp.get(test_hist) orelse 0;
    }
    return total;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var all_changes = std.ArrayList(std.AutoHashMap(hist, u4)).init(alloc);
    defer {
        for (0..all_changes.items.len) |i| all_changes.items[i].deinit();
        all_changes.deinit();
    }

    for (input.items) |line| {
        const c = try changes(alloc, try std.fmt.parseInt(u64, line, 10));
        try all_changes.append(c);
    }

    var profits = std.AutoHashMap(hist, u64).init(alloc);
    defer profits.deinit();

    var max_profit: ?u64 = null;
    var best_hist: ?hist = null;

    for (all_changes.items) |c| {
        var kit = c.keyIterator();
        while (kit.next()) |k| {
            if (profits.contains(k.*)) continue;
            const p = profitFromHist(&all_changes, k.*);
            try profits.put(k.*, p);
            if (p > (max_profit orelse 0)) {
                max_profit = p;
                best_hist = k.*;
            }
        }
    }

    return @intCast(max_profit.?);
}
