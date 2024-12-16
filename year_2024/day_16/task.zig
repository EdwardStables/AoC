const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

var completed: u32 = 0;
var total: u32 = 0;

fn printgrid(size: aoc.Vec2(usize), grid: []i32) void {
    for (0..size.y) |y| {
        for (0..size.x) |x| {
            const p = aoc.Vec2Init(usize, x, y);
            const i = p.toIndex(size.x);
            const c = grid[i];
            const k: u8 = if (c == -1) '#' else
                          if (c == -2 or c == 0) 'O' else '.';
            std.debug.print("{u}", .{k});
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("\n", .{});
}

pub fn dfs(cost_in: i64, lastdir: aoc.Vec2(i32), grid: []i32, pos: aoc.Vec2(usize), size: aoc.Vec2(usize)) void {
    const val = grid[pos.toIndex(size.x)];
    if (val >= 0 and val <= cost_in) return;
    if (val == -1) unreachable;

    //On current path, not resolved
    grid[pos.toIndex(size.x)] = @intCast(cost_in);

    const dirs = aoc.offsets(i32);
    for (dirs, 0..) |dir, i| {
        const next = pos.as(i32).addVec(dir).as(usize);
        if (grid[next.toIndex(size.x)] == -1) continue;
        if (aoc.offsets(i32)[(i+2)%4].eq(lastdir)) continue;

        var cost = cost_in;
        cost += if (lastdir.eq(dir)) 0 else 1000;
        cost += 1;

        dfs(cost, dir, grid, next, size);
    }

    completed += 1;

    return;
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    var start = aoc.Vec2Zero(usize);
    var end = aoc.Vec2Zero(usize);
    var grid = try alloc.alloc(i32, size.x*size.y);
    defer alloc.free(grid);

    for (input.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            const p = aoc.Vec2Init(usize, x, y);
            if (char == '#') grid[p.toIndex(size.x)] = -1;
            if (char == 'S') {
                start = p;
            }
            if (char == '.' or char == 'S' or char == 'E') {
                total += 1;
                grid[p.toIndex(size.x)] = std.math.maxInt(i32);
            }
            if (char == 'E') {
                end = p;
            }
        }
    }

    dfs(0, aoc.Vec2Init(i32, 1, 0), grid, start, size);

    return @intCast(grid[end.toIndex(size.x)]);
}

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
