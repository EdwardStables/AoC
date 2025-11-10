const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var orbits = try std.ArrayList(?usize).initCapacity(alloc, input.items.len);
    var positions = std.StringHashMap(usize).init(alloc);
    var orbit_counts = try std.ArrayList(?usize).initCapacity(alloc, input.items.len);

    defer orbits.deinit();
    defer positions.deinit();
    defer orbit_counts.deinit();

    try positions.put("COM", 0);
    for (input.items, 1..) |line, ind| {
        var orb = std.mem.splitAny(u8, line, ")"); 
        _=orb.next();
        try positions.put(orb.next().?, ind);
    }

    try orbits.append(null); //COM
    try orbit_counts.append(0);

    for (input.items) |line| {
        var orb = std.mem.splitAny(u8, line, ")"); 
        const around = orb.next().?;
        try orbits.append(positions.get(around).?);
        try orbit_counts.append(null);
    }

    var updated = true;
    while (updated) {
        updated = false;
        for (orbits.items, 0..) |around, ind| {
            if (around == null) continue;

            if (orbit_counts.items[ind] == null and orbit_counts.items[around.?] != null) {
                orbit_counts.items[ind] = orbit_counts.items[around.?].? + 1;
                updated = true;
            }
        }
    }

    var sum: i64 = 0;
    for (orbit_counts.items) |it| {
        sum += @intCast(it.?);
    }

    return sum;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var orbits = try std.ArrayList(?usize).initCapacity(alloc, input.items.len);
    var positions = std.StringHashMap(usize).init(alloc);

    defer orbits.deinit();
    defer positions.deinit();

    try positions.put("COM", 0);
    for (input.items, 1..) |line, ind| {
        var orb = std.mem.splitAny(u8, line, ")"); 
        _=orb.next();
        try positions.put(orb.next().?, ind);
    }

    try orbits.append(null); //COM

    for (input.items) |line| {
        var orb = std.mem.splitAny(u8, line, ")"); 
        const around = orb.next().?;
        try orbits.append(positions.get(around).?);
    }

    var you_parents = std.ArrayList(usize).init(alloc);
    var san_parents = std.ArrayList(usize).init(alloc);
    defer you_parents.deinit();
    defer san_parents.deinit();

    var you_current = positions.get("YOU").?;
    while (you_current != 0) {
        try you_parents.append(orbits.items[you_current].?);
        you_current = orbits.items[you_current].?;
    }
    var san_current = positions.get("SAN").?;
    while (san_current != 0) {
        try san_parents.append(orbits.items[san_current].?);
        san_current = orbits.items[san_current].?;
    }

    var ind: usize = 0;
    while (you_parents.items[you_parents.items.len - 1 - ind] == san_parents.items[san_parents.items.len - 1 - ind]) {
        ind += 1;
    }

    return @intCast(you_parents.items.len + san_parents.items.len - (2*ind));
}
