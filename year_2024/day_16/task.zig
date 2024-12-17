const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

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
    return if (a.dist <= b.dist) std.math.Order.lt else
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

    //Too tired to figure it out

    //I think the algorithm is correct now, but the turn/move order means things don't line up
    //maybe different cells for different directions


    while (pq.count() > 0) {
        var min = pq.remove();
        std.debug.print("min ({d},{d}) {d}\n", .{min.pos.x, min.pos.y, min.dist});
        grid[min.pos.toIndex(size.x)] = min.dist;
        const dirs = aoc.offsets(i3);
        for (dirs) |dir| {
            const next = min.pos.as(i32).addVec(dir.as(i32)).as(usize);
            if (grid[next.toIndex(size.x)] == -1) continue;
            const move_cost: i32 = if (min.dir.eq(dir)) 1 else 1001;
            const dist = min.dist + move_cost;

            var iter = pq.iterator();
            var ii: usize = 0;
            while (iter.next()) |it| : (ii+=1) {
                if (!it.pos.eq(next)) continue;
                if (it.dist <= dist) break;
                _ = pq.removeIndex(ii);
                break;
            }

            const new_it: pqueue_entry = .{.pos=next,.dir=dir,.dist=dist};
            if (grid[next.toIndex(size.x)] > dist) {
                try pq.add(new_it);
                grid[next.toIndex(size.x)] = dist;
            }
        }
    }
}

fn find_path_dfs(pos: aoc.Vec2(usize), grid: []i32, good: []bool, size: aoc.Vec2(usize)) void {
    const ind = pos.toIndex(size.x);
    if (good[ind]) return;
    const val = grid[ind];
    if (val == -1) unreachable;

    good[ind] = true;

    const dirs = aoc.offsets(i3);
    for (dirs) |dir| {
        const next_pos = pos.as(i32).addVec(dir.as(i32)).as(usize);
        const next_ind = next_pos.toIndex(size.x);
        const next_val = grid[next_ind];
        if (next_val == -1) continue;

        const diff: i32 = val - next_val;
        if (diff != 1 and diff != 1001) continue;

        find_path_dfs(next_pos, grid, good, size);
    }

}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    var start = aoc.Vec2Zero(usize);
    var end = aoc.Vec2Zero(usize);
    var grid = try alloc.alloc(i32, size.x*size.y);
    defer alloc.free(grid);
    var good = try alloc.alloc(bool, size.x*size.y);
    defer alloc.free(good);
    for (good, 0..) |_,i| {good[i] = false;}

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
    good[start.toIndex(size.x)] = true;
    find_path_dfs(end, grid, good, size);

    var total: i32 = 0;
    for (good) |g| {if (g) total += 1;}

    for (0..size.y) |y| {
        for (0..size.x) |x| {
            const p = aoc.Vec2Init(usize, x, y);
            const pi = p.toIndex(size.x);
            if (grid[pi] != -1) std.debug.print("({d},{d}) {d}\n", .{p.x, p.y, grid[pi]});
        }
    }

    for (0..size.y) |y| {
        for (0..size.x) |x| {
            const p = aoc.Vec2Init(usize, x, y);
            const pi = p.toIndex(size.x);
            const c:u8 = if (good[pi]) 'O' else 
                         if (grid[pi] == -1) '#' else '.';
            std.debug.print("{u}", .{c});
        }
        std.debug.print("\n", .{});
    }

    return total;
}
