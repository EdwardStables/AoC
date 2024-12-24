const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const Trio = struct {
    a: [2]u8,
    b: [2]u8,
    c: [2]u8,
};

fn ge(a: [2]u8, b: [2]u8) bool {
    if (b[0] == a[0]) {
        return a[1] >= b[1];
    }
    return a[0] >= b[0];
}

fn makeTrio(a: [2]u8, b: [2]u8, c: [2]u8) Trio {
    var nt: Trio = .{ .a = a, .b = b, .c = c };

    if (ge(nt.b, nt.a)) {
        const tmp = nt.a;
        nt.a = nt.b;
        nt.b = tmp;
    }
    if (ge(nt.c, nt.b)) {
        const tmp = nt.b;
        nt.b = nt.c;
        nt.c = tmp;
    }
    if (ge(nt.b, nt.a)) {
        const tmp = nt.a;
        nt.a = nt.b;
        nt.b = tmp;
    }

    return nt;
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var connections = std.AutoHashMap([2]u8, std.ArrayList([2]u8)).init(alloc);
    defer {
        var vp = connections.valueIterator();
        while (vp.next()) |v| v.deinit();
        connections.deinit();
    }

    for (input.items) |line| {
        const a = line[0..2];
        const b = line[3..5];
        var gop = try connections.getOrPut(a.*);
        if (!gop.found_existing) gop.value_ptr.* = std.ArrayList([2]u8).init(alloc);
        try gop.value_ptr.append(b.*);
        gop = try connections.getOrPut(b.*);
        if (!gop.found_existing) gop.value_ptr.* = std.ArrayList([2]u8).init(alloc);
        try gop.value_ptr.append(a.*);
    }

    var inps = std.AutoHashMap(Trio, bool).init(alloc);
    defer inps.deinit();

    var ki = connections.keyIterator();
    while (ki.next()) |v| {
        if (v.*[0] != 't') continue;
        for (connections.get(v.*).?.items) |adj1| {
            for (connections.get(v.*).?.items) |adj2| {
                if (adj1[0] == adj2[0] and adj1[1] == adj2[1]) continue;
                for (connections.get(adj1).?.items) |other_con| {
                    if (other_con[0] != adj2[0] or other_con[1] != adj2[1]) continue;
                    const nt = makeTrio(v.*, adj1, adj2);
                    _ = try inps.getOrPut(nt);
                    break;
                }
            }
        }
    }

    //var ki2 = inps.keyIterator();
    //while (ki2.next()) |kk| {
    //    std.debug.print("{s} {s} {s}\n", .{ nt.a, kk.b, kk.c });
    //}

    return inps.count();
}

fn testClique(mask: u32, trial: *std.ArrayList([2]u8), connections: *std.AutoHashMap([2]u8, std.ArrayList([2]u8))) bool {
    for (0..trial.items.len) |i| {
        if (((mask >> @intCast(i)) & 1) != 1) continue;
        inner: for (0..trial.items.len) |ii| {
            if (i == ii) continue;
            if (((mask >> @intCast(ii)) & 1) != 1) continue;
            for (connections.get(trial.items[i]).?.items) |i_neigh| {
                if (i_neigh[0] == trial.items[ii][0] and i_neigh[1] == trial.items[ii][1]) {
                    continue :inner;
                }
            }
            return false;
        }
    }

    return true;
}

fn stripTrial(known_best: u32, trial: *std.ArrayList([2]u8), connections: *std.AutoHashMap([2]u8, std.ArrayList([2]u8))) !bool {
    var mask: u32 = 1;
    var best_size: u32 = 1;
    var best_mask: u32 = 0;
    while (mask < std.math.pow(u32, 2, @intCast(trial.items.len))) : (mask += 1) {
        var clique_size: u32 = 0;
        var sizemask = mask;
        while (sizemask > 0) : (sizemask >>= 1) {
            if ((sizemask & 1) == 1) clique_size += 1;
        }

        if (clique_size <= known_best) continue;
        if (clique_size <= best_size) continue;

        const is_clique = testClique(mask, trial, connections);
        if (!is_clique) continue;

        best_size = clique_size;
        best_mask = mask;
    }

    if (best_size <= known_best) return false;

    const orig_len = trial.items.len;
    for (0..orig_len) |i| {
        const ind = orig_len - i - 1;

        if (((best_mask >> @intCast(ind)) & 1) == 1) continue;
        _ = trial.orderedRemove(ind);
    }

    return true;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var connections = std.AutoHashMap([2]u8, std.ArrayList([2]u8)).init(alloc);
    defer {
        var vp = connections.valueIterator();
        while (vp.next()) |v| v.deinit();
        connections.deinit();
    }

    for (input.items) |line| {
        const a = line[0..2];
        const b = line[3..5];
        var gop = try connections.getOrPut(a.*);
        if (!gop.found_existing) gop.value_ptr.* = std.ArrayList([2]u8).init(alloc);
        try gop.value_ptr.append(b.*);
        gop = try connections.getOrPut(b.*);
        if (!gop.found_existing) gop.value_ptr.* = std.ArrayList([2]u8).init(alloc);
        try gop.value_ptr.append(a.*);
    }

    var largest_clique = std.ArrayList([2]u8).init(alloc);
    defer largest_clique.deinit();
    var trial_clique = std.ArrayList([2]u8).init(alloc);
    defer trial_clique.deinit();

    var kit = connections.keyIterator();
    while (kit.next()) |k| {
        trial_clique.clearRetainingCapacity();
        const others = connections.get(k.*).?;
        if (others.items.len + 1 <= largest_clique.items.len) continue;

        try trial_clique.append(k.*);

        for (others.items) |o| {
            try trial_clique.append(o);
        }

        //Reduce trial to the largest clique it contains
        const strip_success = try stripTrial(@intCast(largest_clique.items.len), &trial_clique, &connections);
        if (!strip_success) continue;

        const temp = trial_clique;
        trial_clique = largest_clique;
        largest_clique = temp;
    }

    std.sort.insertion([2]u8, largest_clique.items, {}, cmp);

    std.debug.print("Task 2 Solution :{s}", .{largest_clique.items[0]});
    for (largest_clique.items[1..]) |lci| {
        std.debug.print(",{s}", .{lci});
    }
    std.debug.print("\n,", .{});

    return @intCast(largest_clique.items.len);
}

fn cmp(_: void, lhs: [2]u8, rhs: [2]u8) bool {
    return !ge(lhs, rhs);
}
