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

fn dijkstra(alloc: Allocator, start: aoc.Vec2(usize), size: aoc.Vec2(usize), grid: []GridEntry) !void {
    var pq = std.PriorityQueue(pqueue_entry, void, pric_cmp).init(alloc, {});
    defer pq.deinit();

    try pq.add(.{.pos=start, .dir=.{.x=1,.y=0}, .dist = 0});

    for (0..size.y) |y| {
        for (0..size.x) |x| {
            const p = aoc.Vec2Init(usize, x, y);
            if (p.eq(start)) {
                try pq.add(.{.pos = p, .dir=.{.x=1,.y=0}, .dist = 0});
                try pq.add(.{.pos = p, .dir=.{.x=-1,.y=0}, .dist = std.math.maxInt(i32)});
                try pq.add(.{.pos = p, .dir=.{.x=0,.y=1}, .dist = std.math.maxInt(i32)});
                try pq.add(.{.pos = p, .dir=.{.x=0,.y=-1}, .dist = std.math.maxInt(i32)});
            }
            else if (!grid[p.toIndex(size.x)].wall) {
                try pq.add(.{.pos = p, .dir=.{.x=1,.y=0}, .dist = std.math.maxInt(i32)});
                try pq.add(.{.pos = p, .dir=.{.x=-1,.y=0}, .dist = std.math.maxInt(i32)});
                try pq.add(.{.pos = p, .dir=.{.x=0,.y=1}, .dist = std.math.maxInt(i32)});
                try pq.add(.{.pos = p, .dir=.{.x=0,.y=-1}, .dist = std.math.maxInt(i32)});
            }
        }
    }

    while (pq.count() > 0) {
        var min = pq.remove();
        //std.debug.print("min ({d},{d}) ({d},{d}) {d}\n", .{min.pos.x, min.pos.y, min.dir.x, min.dir.y, min.dist});
        
        //Straight ahead
        {
            const next = min.pos.as(i32).addVec(min.dir.as(i32)).as(usize);
            if (!grid[next.toIndex(size.x)].wall) {
                const dist = min.dist + 1;
                var iter = pq.iterator();
                var ii: usize = 0;
                while (iter.next()) |it| : (ii+=1) {
                    if (!it.pos.eq(next)) continue;
                    if (!it.dir.eq(min.dir)) continue;
                    if (it.dist <= dist) break;
                    _ = pq.removeIndex(ii);
                    break;
                }
                const new_entry: pqueue_entry = .{.pos=next,.dir=min.dir,.dist=dist};
                if (grid[next.toIndex(size.x)].get(min.dir) > dist) {
                    try pq.add(new_entry);
                    grid[next.toIndex(size.x)].set(min.dir, dist);
                }
            }
        }

        //Left
        {
            const next_dir = min.dir.rotate_left();
            const dist = min.dist + 1000;

            var iter = pq.iterator();
            var ii: usize = 0;
            while (iter.next()) |it| : (ii+=1) {
                if (!it.pos.eq(min.pos)) continue;
                if (!it.dir.eq(next_dir)) continue;
                if (it.dist <= dist) break;
                _ = pq.removeIndex(ii);
                break;
            }
            const new_entry: pqueue_entry = .{.pos=min.pos,.dir=next_dir,.dist=dist};
            if (grid[min.pos.toIndex(size.x)].get(next_dir) > dist) {
                try pq.add(new_entry);
                grid[min.pos.toIndex(size.x)].set(next_dir, dist);
            }
        }

        //Right
        {
            const next_dir = min.dir.rotate_right();
            const dist = min.dist + 1000;

            var iter = pq.iterator();
            var ii: usize = 0;
            while (iter.next()) |it| : (ii+=1) {
                if (!it.pos.eq(min.pos)) continue;
                if (!it.dir.eq(next_dir)) continue;
                if (it.dist <= dist) break;
                _ = pq.removeIndex(ii);
                break;
            }
            const new_entry: pqueue_entry = .{.pos=min.pos,.dir=next_dir,.dist=dist};
            if (grid[min.pos.toIndex(size.x)].get(next_dir) > dist) {
                try pq.add(new_entry);
                grid[min.pos.toIndex(size.x)].set(next_dir, dist);
            }
        }
    }
}

fn find_path_dfs(pos: aoc.Vec2(usize), dir: aoc.Vec2(i3), grid: []GridEntry, size: aoc.Vec2(usize)) void {
    const ind = pos.toIndex(size.x);
    if (grid[ind].getGood(dir)) return;
    grid[ind].setGood(dir);

    const val = grid[ind];
    if (val.wall) unreachable;

    //Straight
    {
        const next_pos = pos.as(i32).addVec(dir.rotate_left().rotate_left().as(i32)).as(usize);
        const next_ind = next_pos.toIndex(size.x);
        const next_val = grid[next_ind];
        if (!next_val.wall){
            const diff: i32 = val.get(dir) - next_val.get(dir);
            if (diff == 1) {
                find_path_dfs(next_pos, dir, grid, size);
            }
        }
    }
    //Right
    {
        const next_dir = dir.rotate_right();
        const diff: i32 = val.get(dir) - val.get(next_dir);
        if (diff == 1000) {
            find_path_dfs(pos, dir.rotate_right(), grid, size);
        }
    }
    //Left
    {
        const next_dir = dir.rotate_left();
        const diff: i32 = val.get(dir) - val.get(next_dir);
        if (diff == 1000) {
            find_path_dfs(pos, dir.rotate_left(), grid, size);
        }
    }
}

const GridEntry = struct {
    wall: bool = false,
    left: i32 = std.math.maxInt(i32),
    right: i32 = std.math.maxInt(i32),
    up: i32 = std.math.maxInt(i32),
    down: i32 = std.math.maxInt(i32),
    leftgood: bool = false,
    rightgood: bool = false,
    upgood: bool = false,
    downgood: bool = false,

    fn get(self: @This(), dir: aoc.Vec2(i3)) i32 {
        if (dir.eq(aoc.Vec2Init(i3, -1, 0))) return self.left;
        if (dir.eq(aoc.Vec2Init(i3, 1, 0))) return self.right;
        if (dir.eq(aoc.Vec2Init(i3, 0, -1))) return self.up;
        if (dir.eq(aoc.Vec2Init(i3, 0, 1))) return self.down;
        unreachable;
    }
    fn set(self: *@This(), dir: aoc.Vec2(i3), val: i32) void {
        if (dir.eq(aoc.Vec2Init(i3, -1, 0))){self.left = val; return;}
        if (dir.eq(aoc.Vec2Init(i3, 1, 0))){self.right = val; return;}
        if (dir.eq(aoc.Vec2Init(i3, 0, -1))){self.up = val; return;}
        if (dir.eq(aoc.Vec2Init(i3, 0, 1))){self.down = val; return;}
        unreachable;
    }
    fn anyGood(self: @This()) bool {
        return self.leftgood or self.rightgood or self.downgood or self.upgood;
    }
    fn getGood(self: @This(), dir: aoc.Vec2(i3)) bool {
        if (dir.eq(aoc.Vec2Init(i3, -1, 0))) return self.leftgood;
        if (dir.eq(aoc.Vec2Init(i3, 1, 0))) return self.rightgood;
        if (dir.eq(aoc.Vec2Init(i3, 0, -1))) return self.upgood;
        if (dir.eq(aoc.Vec2Init(i3, 0, 1))) return self.downgood;
        unreachable;
    }
    fn setGood(self: *@This(), dir: aoc.Vec2(i3)) void {
        if (dir.eq(aoc.Vec2Init(i3, -1, 0))){self.leftgood = true; return;}
        if (dir.eq(aoc.Vec2Init(i3, 1, 0))){self.rightgood = true; return;}
        if (dir.eq(aoc.Vec2Init(i3, 0, -1))){self.upgood = true; return;}
        if (dir.eq(aoc.Vec2Init(i3, 0, 1))){self.downgood = true; return;}
        unreachable;
    }
};


pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    var start = aoc.Vec2Zero(usize);
    var end = aoc.Vec2Zero(usize);
    var grid = try alloc.alloc(GridEntry, size.x*size.y);
    defer alloc.free(grid);

    for (input.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            const p = aoc.Vec2Init(usize, x, y);
            if (char == '#') grid[p.toIndex(size.x)].wall = true;
            if (char == 'S') {
                start = p;
            }
            if (char == '.' or char == 'S' or char == 'E') {
                grid[p.toIndex(size.x)].left = std.math.maxInt(i32);
                grid[p.toIndex(size.x)].right = std.math.maxInt(i32);
                grid[p.toIndex(size.x)].up = std.math.maxInt(i32);
                grid[p.toIndex(size.x)].down = std.math.maxInt(i32);
            }
            if (char == 'E') {
                end = p;
            }
        }
    }

    try dijkstra(alloc, start, size, grid);

    grid[start.toIndex(size.x)].setGood(aoc.Vec2Init(i3,1,0));

    find_path_dfs(end, aoc.Vec2Init(i3, 0, -1), grid, size);

    var total: i32 = 0;
    for (grid) |g| {if (g.anyGood()) total += 1;}

    //for (0..size.y) |y| {
    //    for (0..size.x) |x| {
    //        const p = aoc.Vec2Init(usize, x, y);
    //        const pi = p.toIndex(size.x);
    //        const c:u8 = if (grid[pi].anyGood()) 'O' else 
    //                     if (grid[pi].wall) '#' else '.';
    //        std.debug.print("{u}", .{c});
    //    }
    //    std.debug.print("\n", .{});
    //}

    return total;
}
