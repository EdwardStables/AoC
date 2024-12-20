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

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
