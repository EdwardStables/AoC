const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const pair = struct{
    from: u16,
    to: u16,
};

const cell = enum (u32) {
    clear,
    visited,
    wall
};

fn dfs(
    pos: aoc.Vec2(usize),
    end: aoc.Vec2(usize),
    size: aoc.Vec2(usize),
    grid: []cell,
    costs: *std.AutoHashMap(pair, i32),
    current_cost: i32,
    cheat: ?pair
) !void {
    if (pos.eq(end)) {
        if (cheat == null) {
            try costs.put(.{.from = 0,.to = 0}, current_cost);
        } else {
            try costs.put(cheat.?, current_cost);
        }
        return;
    }

    const dirs = aoc.offsets(i32);
    grid[pos.toIndex(size.x)] = cell.visited;

    //Skip wall
    if (cheat == null) {
        for (dirs) |dir| {
            const nextpos = pos.as(i32).addVec(dir.scale(2));
            const wallpos = pos.as(i32).addVec(dir);

            if (!nextpos.inBounds(aoc.Vec2Zero(i32), size.as(i32))) continue;
            if (grid[nextpos.toIndex(size.x)] != cell.clear) continue;
            if (grid[wallpos.toIndex(size.x)] != cell.wall) continue;

            try dfs(nextpos.as(usize), end, size, grid, costs, current_cost+2, .{.from=@intCast(pos.toIndex(size.x)), .to=@intCast(nextpos.toIndex(size.x))});
        }
    }

    for (dirs) |dir| {
        const nextpos = pos.as(i32).addVec(dir);
        if (grid[nextpos.toIndex(size.x)] != cell.clear) continue;
        try dfs(nextpos.as(usize), end, size, grid, costs, current_cost+1, cheat);
    }

    grid[pos.toIndex(size.x)] = cell.clear;
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    var start = aoc.Vec2Zero(usize);
    var end = aoc.Vec2Zero(usize);
    var grid = try alloc.alloc(cell, size.x*size.y);
    defer alloc.free(grid);

    for (input.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            const p = aoc.Vec2Init(usize, x, y);
            if (char == '#') {
                grid[p.toIndex(size.x)] = cell.wall;
            }
            else {
                if (char == 'S') {
                    start = p;
                }
                if (char == 'E') {
                    end = p;
                }
                grid[p.toIndex(size.x)] = cell.clear;
            }
        }
    }

    grid[start.toIndex(size.x)] = cell.visited;

    var costs = std.AutoHashMap(pair, i32).init(alloc);
    defer costs.deinit();

    try dfs(start, end, size, grid, &costs, 0, null);

    const base_cost = costs.get(.{.to=0,.from=0}).?;

    var vi = costs.valueIterator();
    var total: i64 = 0;
    while(vi.next()) |v| {
        const result = base_cost - v.*;
        if (result >= 100) total += 1;
    }

    return total;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    const nodecount = size.x*size.y;
    var start = aoc.Vec2Zero(usize);
    var end = aoc.Vec2Zero(usize);
    var grid = try alloc.alloc(cell, size.x*size.y);
    defer alloc.free(grid);

    for (input.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            const p = aoc.Vec2Init(usize, x, y);
            if (char == '#') {
                grid[p.toIndex(size.x)] = cell.wall;
            }
            else {
                if (char == 'S') {
                    start = p;
                }
                if (char == 'E') {
                    end = p;
                }
                grid[p.toIndex(size.x)] = cell.clear;
            }
        }
    }

    grid[start.toIndex(size.x)] = cell.visited;

    const adj = try alloc.alloc(?u32, nodecount*nodecount);
    defer alloc.free(adj);
    for (0..adj.len) |a| adj[a] = null;

    for (0..size.y) |y| {
        for (0..size.x) |x| {
            const p = aoc.Vec2Init(usize, x, y).as(i32);
            const pi = p.toIndex(size.x);
            if (y > 0) {
                const ni = p.addVec(aoc.up(i32)).toIndex(size.x);
                if (grid[ni] != cell.wall) adj[pi*nodecount + ni] = 1;
            }
            if (y < size.y-1) {
                const ni = p.addVec(aoc.dn(i32)).toIndex(size.x);
                if (grid[ni] != cell.wall) adj[pi*nodecount + ni] = 1;
            }
            if (x > 0) {
                const ni = p.addVec(aoc.lt(i32)).toIndex(size.x);
                if (grid[ni] != cell.wall) adj[pi*nodecount + ni] = 1;
            }
            if (x < size.x-1) {
                const ni = p.addVec(aoc.rt(i32)).toIndex(size.x);
                if (grid[ni] != cell.wall) adj[pi*nodecount + ni] = 1;
            }
        }
    }

    const dijk_end = try aoc.dijkstra(alloc, end.toIndex(size.x), nodecount, adj);
    const end_dist = dijk_end.dist;
    const end_prev = dijk_end.prev;
    defer alloc.free(end_dist);
    defer alloc.free(end_prev);

    const dijk_start = try aoc.dijkstra(alloc, start.toIndex(size.x), nodecount, adj);
    const start_dist = dijk_start.dist;
    const start_prev = dijk_start.prev;
    defer alloc.free(start_dist);
    defer alloc.free(start_prev);

    const base_cost: i64 = @intCast(start_dist[end.toIndex(size.x)]);
    const skipsize: usize = 20;

    var costs = std.AutoHashMap(pair, i32).init(alloc);
    defer costs.deinit();

    for (0..nodecount) |fromind| {
        const frompos = aoc.Vec2FromIndex(usize, fromind, size.x);
        const fromcost = start_dist[fromind];
        if (grid[fromind]==cell.wall) continue;
        for (0..nodecount) |toind| {
            if (fromind == toind) continue;
            if (grid[toind]==cell.wall) continue;
            const topos = aoc.Vec2FromIndex(usize, toind, size.x);
            const tocost = end_dist[toind];
            const thisskipsize = frompos.manhatten(topos);
            if (thisskipsize > skipsize) continue;
            const cost = fromcost + thisskipsize + tocost;

            if (cost <= base_cost - 100){
                try costs.put(.{ .from = @intCast(fromind), .to = @intCast(toind) }, @intCast(base_cost-@as(i64,@intCast(cost))));
            }
        }
    }

    return costs.count();
}
