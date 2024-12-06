const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 1;

    var pos = aoc.Vec2Init(i16,0,0);
    var dir = aoc.Vec2Init(i16,0,-1);

    const h = input.items.len;
    const w = input.items[0].len;
    var mask = try alloc.alloc(bool, h*w);
    defer alloc.free(mask);

    for (input.items, 0..) |line, y| {
        for (line, 0..) |cell, x| {
            mask[@as(usize,@intCast(y))*w + @as(usize,@intCast(x))] = false;
            if (cell == '^') {
                pos.x = @intCast(x);
                pos.y = @intCast(y);
            }
        }
    }

    while (true) {
        const nextpos = pos.addVec(dir);
        if (nextpos.y >= h or nextpos.y < 0 or nextpos.x >= w or nextpos.x < 0) break;

        //Rotate CW
        if (input.items[@intCast(nextpos.y)][@intCast(nextpos.x)] == '#') {
            const dx = dir.x;
            dir.x = -dir.y;
            dir.y = dx;
            continue;
        }

        mask[@as(usize,@intCast(pos.y))*w + @as(usize,@intCast(pos.x))] = true;
        pos = nextpos;
        if (mask[@as(usize,@intCast(pos.y))*w + @as(usize,@intCast(pos.x))] != true) {
            total += 1;
        }
    }

    return total;
}

fn checkLoop(
    startpos: aoc.Vec2(i16),
    startdir: aoc.Vec2(i16),
    visitedMask: []aoc.Vec2(i16),
    input: *std.ArrayList([]const u8),
    obstacle: aoc.Vec2(i16),
) bool {
    var pos = startpos;
    var dir = startdir;
    const h = input.items.len;
    const w = input.items[0].len;
    visitedMask[@as(usize,@intCast(pos.y))*w + @as(usize,@intCast(pos.x))] = dir;

    while (true) {
        const nextpos = pos.addVec(dir);
        if (nextpos.y >= h or nextpos.y < 0 or nextpos.x >= w or nextpos.x < 0) {
            return false;
        }

        if (visitedMask[nextpos.toIndex(w)].eq(dir)){
            return true;
        }

        visitedMask[nextpos.toIndex(w)] = dir;

        //Rotate CW
        if (
            input.items[@intCast(nextpos.y)][@intCast(nextpos.x)] == '#' or
            (nextpos.x == obstacle.x and nextpos.y == obstacle.y)
        ) {
            const dx = dir.x;
            dir.x = -dir.y;
            dir.y = dx;
            continue;
        }

        pos = nextpos;
    }
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const h = input.items.len;
    const w = input.items[0].len;
    var dir_mask = try alloc.alloc(aoc.Vec2(i16), h*w);
    defer alloc.free(dir_mask);
    var seen_mask = try alloc.alloc(bool, h*w);
    defer alloc.free(seen_mask);
    for (0..h*w) |i| {seen_mask[i] = false;} //clear mask to avoid realloc

    var init_x: i16 = 0;
    var init_y: i16 = 0;
    for (input.items, 0..) |line, y| {
        for (line, 0..) |cell, x| {
            if (cell == '^') {
                init_x = @intCast(x);
                init_y = @intCast(y);
            }
        }
    }

    const start_pos = aoc.Vec2Init(i16,init_x,init_y);
    const start_dir = aoc.Vec2Init(i16,0,-1);
    var pos = start_pos;
    var dir = start_dir;

    var trial_points = try std.ArrayList(aoc.Vec2(i16)).initCapacity(alloc, 2000);
    defer trial_points.deinit();

    while (true) {
        const nextpos = pos.addVec(dir);
        if (nextpos.y >= h or nextpos.y < 0 or nextpos.x >= w or nextpos.x < 0) break;

        //Rotate CW
        if (input.items[@intCast(nextpos.y)][@intCast(nextpos.x)] == '#') {
            const dx = dir.x;
            dir.x = -dir.y;
            dir.y = dx;
            continue;
        } else {
            if (!nextpos.eq(start_pos) and !seen_mask[nextpos.toIndex(w)]) {
                try trial_points.append(nextpos);
                seen_mask[nextpos.toIndex(w)] = true;
            }
        }

        pos = nextpos;
    }

    var loopcount: i64 = 0;
    for (trial_points.items) |obstacle| {
        for (0..h*w) |i| {dir_mask[i].x = 0; dir_mask[i].y = 0;} //clear mask to avoid realloc
        if (checkLoop(start_pos, start_dir, dir_mask, input, obstacle)) {
            loopcount+=1;
        }
    }

    return loopcount;
}
