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
const changeProfitPair = struct { change: i5, profit: i5 };

fn changes(alloc: Allocator, start: u64) !std.ArrayList(changeProfitPair) {
    var hists = try std.ArrayList(changeProfitPair).initCapacity(alloc, 2000);
    var prev_price: i5 = @intCast(start % 10);
    var secret = start;

    for (0..2001) |_| {
        secret = bruteforce(secret, 1);
        const price: i5 = @intCast(secret % 10);
        const diff: i5 = price - prev_price;
        prev_price = price;
        try hists.append(.{ .change = diff, .profit = price });
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

fn profitFromHist(all_hists: std.ArrayList(std.ArrayList(changeProfitPair)), test_hist: hist) u64 {
    var total: u64 = 0;
    var ii: usize = 0;
    for (all_hists.items) |inp| {
        for (3..inp.items.len) |i| {
            const this_his: hist = .{
                ._4 = inp.items[i - 3].change,
                ._3 = inp.items[i - 2].change,
                ._2 = inp.items[i - 1].change,
                ._1 = inp.items[i - 0].change,
            };

            if (test_hist._1 == this_his._1 and
                test_hist._2 == this_his._2 and
                test_hist._3 == this_his._3 and
                test_hist._4 == this_his._4)
            {
                total += @intCast(inp.items[i].profit);
                //if (test_hist._1 == 0 and
                //    test_hist._2 == -1 and
                //    test_hist._3 == 9 and
                //    test_hist._4 == -9)
                //{
                //    std.debug.print("{d}\n", .{total});
                //}
                break;
            }
        }
        ii += 1;
    }
    return total;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var all_changes = try std.ArrayList(std.ArrayList(changeProfitPair)).initCapacity(alloc, input.items.len);
    defer {
        for (all_changes.items) |c| c.deinit();
        all_changes.deinit();
    }

    for (input.items) |line| {
        const c = try changes(alloc, try std.fmt.parseInt(u64, line, 10));
        try all_changes.append(c);
    }

    var profits = std.AutoHashMap(hist, u64).init(alloc);
    defer profits.deinit();

    var best_hist: ?hist = null;
    var best_profit: i64 = 0;

    for (all_changes.items, 0..) |inputline, progress| {
        std.debug.print("{d}/{d}\n", .{ progress, all_changes.items.len });
        for (3..inputline.items.len) |i| {
            const target: hist = .{
                ._4 = inputline.items[i - 3].change,
                ._3 = inputline.items[i - 2].change,
                ._2 = inputline.items[i - 1].change,
                ._1 = inputline.items[i - 0].change,
            };
            if (profits.contains(target)) continue;
            const profit = profitFromHist(all_changes, target);
            try profits.put(target, profit);
            if (profit > best_profit) {
                best_hist = target;
                best_profit = @intCast(profit);
            }
        }
    }

    std.debug.print("Part 2 Solution: {d},{d},{d},{d}\n", .{ best_hist.?._4, best_hist.?._3, best_hist.?._2, best_hist.?._1 });
    return best_profit;
}
