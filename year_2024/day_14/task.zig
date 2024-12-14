const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = if (input.items.len == 12) aoc.Vec2Init(i32, 11, 7) else aoc.Vec2Init(i32, 101, 103);
    const quad = aoc.Vec2Init(i32, @divFloor(size.x, 2), @divFloor(size.y, 2));
    
    const steps = 100;
    var q1: i64 = 0;
    var q2: i64 = 0;
    var q3: i64 = 0;
    var q4: i64 = 0;

    for (input.items) |line| {
        var pos = aoc.Vec2Zero(i32);
        var vec = aoc.Vec2Zero(i32);

        var split_it = std.mem.splitAny(u8, line, "pv=, ");
        _ = split_it.next();
        _ = split_it.next();
        pos.x = try std.fmt.parseInt(i32, split_it.next().?, 10);
        pos.y = try std.fmt.parseInt(i32, split_it.next().?, 10);
        _ = split_it.next();
        _ = split_it.next();
        vec.x = try std.fmt.parseInt(i32, split_it.next().?, 10);
        vec.y = try std.fmt.parseInt(i32, split_it.next().?, 10);

        pos.x += steps*vec.x;
        pos.y += steps*vec.y;

        pos.x = @mod(pos.x, size.x);
        pos.y = @mod(pos.y, size.y);


        if (pos.x < quad.x and pos.y < quad.y) q1 += 1;
        if (pos.x > quad.x and pos.y < quad.y) q2 += 1;
        if (pos.x < quad.x and pos.y > quad.y) q3 += 1;
        if (pos.x > quad.x and pos.y > quad.y) q4 += 1;
    }


    return q1*q2*q3*q4;
}

fn print(disp: []bool, size: aoc.Vec2(i32), positions: *std.ArrayList(aoc.Vec2(i32))) void {
    for (0..@intCast(size.y*size.x)) |i| disp[i] = false;

    for (positions.items) |p| {
        disp[@as(u32, @intCast(p.y*size.x + p.x))] = true;
    }

    for (0..@intCast(size.y)) |y| {
        for (0..@intCast(size.x)) |x| {
            const char: u8 = if (disp[y * @as(u32,@intCast(size.x)) + x]) '0' else '_';
            std.debug.print("{u}", .{char});
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("\n", .{});
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const size = if (input.items.len == 12) aoc.Vec2Init(i32, 11, 7) else aoc.Vec2Init(i32, 101, 103);
    var positions = try std.ArrayList(aoc.Vec2(i32)).initCapacity(alloc, input.items.len);
    defer positions.deinit();
    var velocities = try std.ArrayList(aoc.Vec2(i32)).initCapacity(alloc, input.items.len);
    defer velocities.deinit();
    
    var steps: i64 = 0;

    for (input.items) |line| {
        var pos = aoc.Vec2Zero(i32);
        var vec = aoc.Vec2Zero(i32);

        var split_it = std.mem.splitAny(u8, line, "pv=, ");
        _ = split_it.next();
        _ = split_it.next();
        pos.x = try std.fmt.parseInt(i32, split_it.next().?, 10);
        pos.y = try std.fmt.parseInt(i32, split_it.next().?, 10);
        _ = split_it.next();
        _ = split_it.next();
        vec.x = try std.fmt.parseInt(i32, split_it.next().?, 10);
        vec.y = try std.fmt.parseInt(i32, split_it.next().?, 10);

        try positions.append(pos);
        try velocities.append(vec);
    }

    //const quad = aoc.Vec2Init(i32, @divFloor(size.x, 2), @divFloor(size.y, 2));
    var disp = try alloc.alloc(bool, @intCast(size.x*size.y));
    disp = disp;
    defer alloc.free(disp);
    var min_xvar: u64 = 0;
    var min_yvar: u64 = 0;

    while (steps < 40000) {
        var xtotal: u64 = 0;
        var ytotal: u64 = 0;
        for (positions.items, velocities.items, 0..) |p,v,i| {
            var next = p.addVec(v);
            next.x = @mod(next.x, size.x);
            next.y = @mod(next.y, size.y);
            positions.items[i] = next;
            xtotal += @intCast(next.x);
            ytotal += @intCast(next.y);
        }
        steps += 1;

        const xmean: u64 = @intCast(xtotal/input.items.len);
        const ymean: u64 = @intCast(ytotal/input.items.len);
        var sqsumx: u64 = 0;
        var sqsumy: u64 = 0;

        for (positions.items) |p| {
            sqsumx += @as(u64, @intCast(std.math.pow(i32, p.x - @as(i32, @intCast(xmean)), 2)));
            sqsumy += @as(u64, @intCast(std.math.pow(i32, p.y - @as(i32, @intCast(ymean)), 2)));
        }

        const xvar: u64 = sqsumx/input.items.len;
        const yvar = sqsumy/input.items.len;

        if (min_xvar == 0) {
            min_xvar = xvar;
        }
        else if (xvar <= min_xvar) {
           min_xvar = xvar;
        }
        if (min_yvar == 0) {
            min_yvar = yvar;
        }
        else if (yvar <= min_yvar) {
           min_yvar = yvar;
        }

        if (steps != 1 and xvar == min_xvar and yvar == min_yvar) {
            //print(disp, size, &positions);
            break;
        }
    }
    return steps;
}
