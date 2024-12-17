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

const pqueue_entry = struct {
    pos: aoc.Vec2(usize),
    dir: aoc.Vec2(i3),
    dist: i32,
};
fn pric_cmp(_: void, a: pqueue_entry, b: pqueue_entry) std.math.Order {
    return if (a.dist == b.dist) std.math.Order.eq else
           if (a.dist < b.dist) std.math.Order.lt  else std.math.Order.gt;
}

fn dijkstra(alloc: Allocator, start: aoc.Vec2(usize), size: aoc.Vec2(usize), grid: []i32) !void {
    var pq = std.PriorityQueue(pqueue_entry, void, pric_cmp).init(alloc, {});
    defer pq.deinit();

    try pq.add(.{.pos=start, .dir=.{.x=1,.y=0}, .dist = 0});
    grid[start.toIndex(size.x)] = 0;

    for (0..size.y) |y| {
        for (0..size.x) |x| {
            const p = aoc.Vec2Init(usize, x, y);
            if (grid[p.toIndex(size.x)] == std.math.maxInt(i32)) {
                try pq.add(.{.pos = p, .dir=.{.x=0,.y=0}, .dist = std.math.maxInt(i32)});
            }
        }
    }

    while (pq.count() > 0) {
        var min = pq.remove();
        grid[min.pos.toIndex(size.x)] = min.dist;
        const dirs = aoc.offsets(i3);
        for (dirs, 0..) |dir, i| {
            const next = min.pos.as(i32).addVec(dir.as(i32)).as(usize);
            if (grid[next.toIndex(size.x)] == -1) continue;
            if (aoc.offsets(i3)[(i+2)%4].eq(min.dir)) continue;

            const move_cost: i32 = if (min.dir.eq(dir)) 1 else 1001;
            const dist = min.dist + move_cost;

            var iter = pq.iterator();
            var ii: usize = 0;
            while (iter.next()) |it| : (ii+=1) {
                if (!it.pos.eq(next)) continue;
                if (it.dist <= dist) break;
                _ = pq.removeIndex(ii);
                var new_it = it;
                new_it.dist = dist;
                new_it.dir = dir;
                try pq.add(new_it);
                break;
            }
        }
    }
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
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
                grid[p.toIndex(size.x)] = std.math.maxInt(i32);
            }
            if (char == 'E') {
                end = p;
            }
        }
    }

    try dijkstra(alloc, start, size, grid);

    return @intCast(grid[end.toIndex(size.x)]);
}
