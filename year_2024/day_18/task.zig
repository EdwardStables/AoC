const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn path(
    alloc: Allocator,
    start: aoc.Vec2(usize),
    end: aoc.Vec2(usize),
    size: aoc.Vec2(usize),
    grid: []bool,
    pathnodes: *std.ArrayList(usize),
) !void {
    const nodecount = size.x*size.y;
    const adj = try alloc.alloc(?u32, nodecount*nodecount);
    defer alloc.free(adj);
    for (0..adj.len) |a| adj[a] = null;

    for (0..size.y) |y| {
        for (0..size.x) |x| {
            const p = aoc.Vec2Init(usize, x, y).as(i32);
            const pi = p.toIndex(size.x);
            if (y > 0) {
                const ni = p.addVec(aoc.up(i32)).toIndex(size.x);
                if (!grid[ni]) adj[pi*nodecount + ni] = 1;
            }
            if (y < size.y-1) {
                const ni = p.addVec(aoc.dn(i32)).toIndex(size.x);
                if (!grid[ni]) adj[pi*nodecount + ni] = 1;
            }
            if (x > 0) {
                const ni = p.addVec(aoc.lt(i32)).toIndex(size.x);
                if (!grid[ni]) adj[pi*nodecount + ni] = 1;
            }
            if (x < size.x-1) {
                const ni = p.addVec(aoc.rt(i32)).toIndex(size.x);
                if (!grid[ni]) adj[pi*nodecount + ni] = 1;
            }
        }
    }

    const dijk_ret = try aoc.dijkstra(alloc, start.toIndex(size.x), nodecount, adj);
    const dist = dijk_ret.dist;
    const prev = dijk_ret.prev;
    defer alloc.free(dist);
    defer alloc.free(prev);
    var nextind = end.toIndex(size.x);
    try pathnodes.append(nextind);
    while (nextind!=start.toIndex(size.x)) {
        nextind = prev[nextind];
        if (nextind == std.math.maxInt(u32)) { //no path
            pathnodes.clearRetainingCapacity();
            return;
        }
        try pathnodes.append(nextind);
    }
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = if (input.items.len < 30) aoc.Vec2Init(usize, 7, 7) else aoc.Vec2Init(usize, 71, 71);
    const bytestofall: u64 = if (input.items.len < 30) 12 else 1024;
    const start = aoc.Vec2Init(usize, 0, 0);
    const end = aoc.Vec2Init(usize, size.x-1, size.y-1);
    
    var grid = try alloc.alloc(bool, size.x*size.y);
    defer alloc.free(grid);

    for (0..grid.len) |g| grid[g] = false;

    for (input.items, 0..) |line, ind| {
        if (ind == bytestofall) break;
        var p = aoc.Vec2Init(usize, 0, 0);
        var mult: usize = 1;
        var on_x = false;
        for (1..(line.len+1)) |i| {
            const char = line[line.len-i];
            if (char == ',') {
                on_x = true;
                mult = 1;
                continue;
            }
            const c = char - 48;
            if (!on_x) p.y += mult*c
            else p.x += mult*c;

            mult *= 10;
        }
        //std.debug.print("({d},{d})\n", .{p.x, p.y});
        grid[p.toIndex(size.x)] = true;
    }

    var pathnodes = std.ArrayList(usize).init(alloc);
    defer pathnodes.deinit();
    try path(alloc, start, end, size, grid, &pathnodes);
    
    return @intCast(pathnodes.items.len-1);
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = if (input.items.len < 30) aoc.Vec2Init(usize, 7, 7) else aoc.Vec2Init(usize, 71, 71);
    const bytestofall: u64 = if (input.items.len < 30) 12 else 1024;
    const start = aoc.Vec2Init(usize, 0, 0);
    const end = aoc.Vec2Init(usize, size.x-1, size.y-1);
    
    var grid = try alloc.alloc(bool, size.x*size.y);
    defer alloc.free(grid);

    for (0..grid.len) |g| grid[g] = false;


    var remaining_bytes = std.ArrayList(aoc.Vec2(usize)).init(alloc);
    defer remaining_bytes.deinit();
    for (input.items, 0..) |line, ind| {
        var p = aoc.Vec2Init(usize, 0, 0);
        var mult: usize = 1;
        var on_x = false;
        for (1..(line.len+1)) |i| {
            const char = line[line.len-i];
            if (char == ',') {
                on_x = true;
                mult = 1;
                continue;
            }
            const c = char - 48;
            if (!on_x) p.y += mult*c
            else p.x += mult*c;

            mult *= 10;
        }
        if (ind >= bytestofall) try remaining_bytes.append(p)
        else grid[p.toIndex(size.x)] = true;
    }

    var byte_offset: usize = 0;
    var pathnodes = std.ArrayList(usize).init(alloc);
    defer pathnodes.deinit();
    try path(alloc, start, end, size, grid, &pathnodes);

    outer: while (byte_offset < remaining_bytes.items.len) {
        const byte = remaining_bytes.items[byte_offset];
        const bi = byte.toIndex(size.x);
        grid[bi] = true;
        for (pathnodes.items) |p| {
            if (byte.toIndex(size.x) == p) {
                pathnodes.clearRetainingCapacity();
                try path(alloc, start, end, size, grid, &pathnodes);

                if (pathnodes.items.len == 0) {
                    std.debug.print("Part 2 Result: {d},{d}\n", .{byte.x, byte.y});
                    return 0;
                }

                continue :outer;
            }
        }
        byte_offset += 1;
    }
    unreachable;
}
