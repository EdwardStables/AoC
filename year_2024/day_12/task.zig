const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn floodFill(queue: *std.ArrayList(aoc.Vec2(i32)), input: *std.ArrayList([]const u8), mask: []bool) !i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    const i32size = aoc.Vec2Init(i32, @intCast(input.items[0].len), @intCast(input.items.len));
    const target = input.items[@intCast(queue.items[0].y)][@intCast(queue.items[0].x)];
    var area: i64 = 0;
    var peri: i64 = 0;

    while (queue.items.len > 0) {
        const next = queue.pop();
        if (mask[next.toIndex(size.x)]) continue;
        area += 1;
        var thisperimiter: i64 = 4;
        for (aoc.offsets(i32)) |offs| {
            const adj = next.addVec(offs);
            if (!adj.inBounds(aoc.Vec2Zero(i32), i32size)) continue;
            if (input.items[@intCast(adj.y)][@intCast(adj.x)] != target) continue;
            thisperimiter -= 1;
            if (mask[adj.toIndex(size.x)]) continue;
            try queue.append(adj);
        }
        mask[next.toIndex(size.x)] = true;
        peri += thisperimiter;
    }

    return area * peri;
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    var mask = try alloc.alloc(bool, size.x*size.y);
    defer alloc.free(mask);
    var queue = std.ArrayList(aoc.Vec2(i32)).init(alloc);
    defer queue.deinit();

    for (0..mask.len) |i| mask[i] = false;

    var total: i64 = 0;
    var pos = aoc.Vec2Zero(i32);
    while (pos.y < size.y) : ({pos.y+=1;pos.x = 0;}) {
        while (pos.x < size.x) : (pos.x+=1) {
            if (mask[pos.toIndex(size.x)]) continue;
            queue.clearRetainingCapacity();
            try queue.append(pos);
            total += try floodFill(&queue, input, mask);
        }
    }

    return total;
}

fn floodArea(queue: *std.ArrayList(aoc.Vec2(i32)), input: *std.ArrayList([]const u8), mask: []bool) !i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    const i32size = aoc.Vec2Init(i32, @intCast(input.items[0].len), @intCast(input.items.len));
    const target = input.items[@intCast(queue.items[0].y)][@intCast(queue.items[0].x)];
    var area: i64 = 0;

    while (queue.items.len > 0) {
        const next = queue.pop();
        if (mask[next.toIndex(size.x)]) continue;
        area += 1;
        for (aoc.offsets(i32)) |offs| {
            const adj = next.addVec(offs);
            if (!adj.inBounds(aoc.Vec2Zero(i32), i32size)) continue;
            if (input.items[@intCast(adj.y)][@intCast(adj.x)] != target) continue;
            if (mask[adj.toIndex(size.x)]) continue;
            try queue.append(adj);
        }
        mask[next.toIndex(size.x)] = true;
    }

    return area;
}

fn perimiter(start: aoc.Vec2(i32), input: *std.ArrayList([]const u8)) i64 {
    const i32size = aoc.Vec2Init(i32, @intCast(input.items[0].len), @intCast(input.items.len));
    const target = input.items[@intCast(start.y)][@intCast(start.x)];
    var direction_changes: i64 = 1;

    var pos = start;
    const dirs = aoc.offsets(i32);
    var di: i8 = 0;

    while (true) {
        for (1..5) |offset| {
            const test_index: i8 = @mod(di + 2 + @as(i8, @intCast(offset)), 4);
            const test_dir = dirs[@intCast(test_index)];
            const test_pos = pos.addVec(test_dir);
            if (!test_pos.inBounds(aoc.Vec2Zero(i32), i32size)) continue;
            if (input.items[@intCast(test_pos.y)][@intCast(test_pos.x)] != target) continue;

            pos = test_pos;
            if (test_index != di) {
                const inc: i64 = if (offset == 4) 2 else 1;
                direction_changes += inc;

            }
            di = test_index;
            
            break;
        }
        if (pos.eq(start) and di == 2) direction_changes += 1;
        if (pos.eq(start)) return direction_changes;
    }
    unreachable;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    var mask = try alloc.alloc(bool, size.x*size.y);
    defer alloc.free(mask);
    var queue = std.ArrayList(aoc.Vec2(i32)).init(alloc);
    defer queue.deinit();

    for (0..mask.len) |i| mask[i] = false;

    var total: i64 = 0;
    var pos = aoc.Vec2Zero(i32);
    while (pos.y < size.y) : ({pos.y+=1;pos.x = 0;}) {
        while (pos.x < size.x) : (pos.x+=1) {
            if (mask[pos.toIndex(size.x)]) continue;
            queue.clearRetainingCapacity();
            try queue.append(pos);
            const area = try floodArea(&queue, input, mask);
            if (area < 3) {
                const score = area * 4;
                total += score;
                std.debug.print("{d},{d} {d}x{d}={d}\n", .{pos.x, pos.y, area, 4, score} );
            } else 
            {
                const peri = perimiter(pos, input);
                const score = area * peri;
                std.debug.print("{d},{d} {d}x{d}={d}\n", .{pos.x, pos.y, area, peri, score} );
                total += score;
            }
        }
    }

    return total;
}
