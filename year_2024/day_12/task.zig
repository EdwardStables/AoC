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

const Segment = struct {
    start: aoc.Vec2(i32),
    end: aoc.Vec2(i32),
    side: u8,
    merged: bool = false,
};

fn floodArea(queue: *std.ArrayList(aoc.Vec2(i32)), input: *std.ArrayList([]const u8), mask: []bool, edge_segments: *std.ArrayList(Segment)) !i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    const i32size = aoc.Vec2Init(i32, @intCast(input.items[0].len), @intCast(input.items.len));
    const target = input.items[@intCast(queue.items[0].y)][@intCast(queue.items[0].x)];
    var area: i64 = 0;

    while (queue.items.len > 0) {
        const next = queue.pop();
        if (mask[next.toIndex(size.x)]) continue;
        area += 1;
        for (aoc.offsets(i32), 0..) |offs, edge| {
            const adj = next.addVec(offs);
            if (!adj.inBounds(aoc.Vec2Zero(i32), i32size) or input.items[@intCast(adj.y)][@intCast(adj.x)] != target) {
                try edge_segments.append(.{ .start = adj, .end = adj , .side = @intCast(edge) });
                continue;
            }
            if (mask[adj.toIndex(size.x)]) continue;
            try queue.append(adj);
        }
        mask[next.toIndex(size.x)] = true;
    }

    return area;
}

fn perimiter(edge_segments: *std.ArrayList(Segment)) i64 {
    var merge_count: i64 = 0;
    var changed = true;
    while (changed) {
        changed = false;
        for (edge_segments.items, 0..) |to_merge, merge_index| {
            if (to_merge.merged) continue;
            for (edge_segments.items, 0..) |to_receive, receive_index| {
                if (merge_index == receive_index) continue;
                if (to_receive.merged) continue;
                if (to_merge.side != to_receive.side) continue;
                if (to_merge.side % 2 == 1) { //H
                    if (to_merge.end.y != to_receive.end.y) continue;
                    if (to_merge.start.x != to_receive.end.x + 1) continue;

                    edge_segments.items[receive_index].end.x = to_merge.end.x;
                    edge_segments.items[merge_index].merged = true;
                    merge_count += 1;

                } else { //V
                    if (to_merge.end.x != to_receive.end.x) continue;
                    if (to_merge.start.y != to_receive.end.y + 1) continue;

                    edge_segments.items[receive_index].end.y = to_merge.end.y;
                    edge_segments.items[merge_index].merged = true;
                    merge_count += 1;
                }
            }
        }
    }

    return @as(i64, @intCast(edge_segments.items.len)) - merge_count;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = aoc.Vec2Init(usize, input.items[0].len, input.items.len);
    var mask = try alloc.alloc(bool, size.x*size.y);
    defer alloc.free(mask);
    var queue = std.ArrayList(aoc.Vec2(i32)).init(alloc);
    defer queue.deinit();
    var edge_segments = std.ArrayList(Segment).init(alloc);
    defer edge_segments.deinit();

    for (0..mask.len) |i| mask[i] = false;

    var total: i64 = 0;
    var pos = aoc.Vec2Zero(i32);
    while (pos.y < size.y) : ({pos.y+=1;pos.x = 0;}) {
        while (pos.x < size.x) : (pos.x+=1) {
            if (mask[pos.toIndex(size.x)]) continue;
            queue.clearRetainingCapacity();
            try queue.append(pos);
            const area = try floodArea(&queue, input, mask, &edge_segments);
            if (area < 3) {
                const score = area * 4;
                total += score;
            } else 
            {
                const peri = perimiter(&edge_segments);
                const score = area * peri;
                total += score;
            }
            edge_segments.clearRetainingCapacity();
        }
    }

    return total;
}
