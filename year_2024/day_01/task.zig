 const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var list1 = try std.ArrayList(i64).initCapacity(alloc, input.items.len);
    var list2 = try std.ArrayList(i64).initCapacity(alloc, input.items.len);
    defer list1.deinit();
    defer list2.deinit();

    for (input.items) |line| {
        var iter = std.mem.splitAny(u8, line, "   ");
        var ind: u32 = 0;
        while (iter.next()) |word| {
            if (word.len == 0) continue;
            if (ind == 0) {
                try list1.append(try std.fmt.parseInt(i64, word, 10));
            } else {
                try list2.append(try std.fmt.parseInt(i64, word, 10));
            }
            ind += 1;
        }
    }

    std.mem.sort(i64, list1.items, {}, std.sort.asc(i64));
    std.mem.sort(i64, list2.items, {}, std.sort.asc(i64));

    var total: u64 = 0;
    for (list1.items, list2.items) |left, right| {
        total += @abs(left-right);
    }

    return @intCast(total);
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var list1 = try std.ArrayList(i64).initCapacity(alloc, input.items.len);
    var list2_counts = std.AutoHashMap(i64, i64).init(alloc);
    defer list1.deinit();
    defer list2_counts.deinit();

    for (input.items) |line| {
        var iter = std.mem.splitAny(u8, line, "   ");
        var ind: u32 = 0;
        while (iter.next()) |word| {
            if (word.len == 0) continue;
            const parsed = try std.fmt.parseInt(i64, word, 10);
            if (ind == 0) {
                try list1.append(parsed);
            } else {
                const current = list2_counts.get(parsed) orelse 0;
                try list2_counts.put(parsed, current+1);
            }
            ind += 1;
        }
    }


    var total: i64 = 0;
    for (list1.items) |item| {
        total += item * (list2_counts.get(item) orelse 0);
    }

    return total;

}
