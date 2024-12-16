const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const Cell = enum(u3) {
    CLEAR,
    WALL,
    BOX,
    LEFTBOX,
    RIGHTBOX
};

fn print(pos: aoc.Vec2(usize), width: usize, height: usize, grid: []Cell) void {
    for (0..height) |y| {
        for (0..width) |x| {
            const p = aoc.Vec2Init(usize, x, y);
            if (p.eq(pos)) {
                std.debug.print("@", .{});
                continue;
            }
            switch (grid[p.toIndex(width)]) {
                Cell.CLEAR => std.debug.print(".", .{}),
                Cell.WALL=> std.debug.print("#", .{}),
                Cell.BOX=> std.debug.print("O", .{}),
                Cell.LEFTBOX=> std.debug.print("[", .{}),
                Cell.RIGHTBOX=> std.debug.print("]", .{}),
            }
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("\n", .{});
}

pub fn move(pos: aoc.Vec2(u16), dir: aoc.Vec2(i16), width: usize, grid: []Cell) aoc.Vec2(u16) {
    var test_pos = pos.as(i16).addVec(dir);
    var found_space = false;

    while(test_pos.inBounds(aoc.Vec2Zero(i16), aoc.Vec2Init(i16,@intCast(width),@intCast(width))))
        : (test_pos = test_pos.addVec(dir)) 
    {
        const ind = test_pos.toIndex(width);
        if (grid[ind] == Cell.WALL) break;
        if (grid[ind] == Cell.BOX) continue;

        found_space = true;
        break;
    }

    if (!found_space) {
        return pos;
    }

    const inv_dir = dir.scale(-1);

    while (!test_pos.eq(pos.as(i16))) {
        const next = test_pos.addVec(inv_dir);
        const ni = next.toIndex(width);
        const ti = test_pos.toIndex(width);
        std.debug.assert(grid[ti] == Cell.CLEAR);
        std.debug.assert(grid[ni] != Cell.WALL);

        if (grid[ni] == Cell.BOX) {
            grid[ti] = Cell.BOX;
            grid[ni] = Cell.CLEAR;
        }

        test_pos = next;
    }

    return pos.as(i16).addVec(dir).as(u16);
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var pos = aoc.Vec2Zero(u16);
    const width = input.items[0].len;
    var grid = try alloc.alloc(Cell, width*width);
    defer alloc.free(grid);

    for (input.items[0..width], 0..) |line,y| {
        for (line, 0..) |cell,x| {
            var p = aoc.Vec2Init(usize, x, y);
            switch(cell) {
                '#' => grid[p.toIndex(width)] = Cell.WALL,
                '.' => grid[p.toIndex(width)] = Cell.CLEAR,
                'O' => grid[p.toIndex(width)] = Cell.BOX,
                '@' => {
                    grid[p.toIndex(width)] = Cell.CLEAR;
                    pos = p.as(u16);
                },
                else => unreachable
            }
        }
    }

    for (input.items[width..]) |line| {
        for (line) |dir| {
            switch(dir) {
                '>' => pos = move(pos, aoc.offsets(i16)[0], width, grid),
                'v' => pos = move(pos, aoc.offsets(i16)[1], width, grid),
                '<' => pos = move(pos, aoc.offsets(i16)[2], width, grid),
                '^' => pos = move(pos, aoc.offsets(i16)[3], width, grid),
                else => unreachable
            }
        }
    }

    var total: i64 = 0;
    for (0..width) |y| {
        for (0..width) |x| {
            const p = aoc.Vec2Init(usize, x, y);
            if (grid[p.toIndex(width)] != Cell.BOX) continue;
            total += @intCast((100*y) + x);
        }
    }

    return total;
}

pub fn moveWide(
    update_points_left: *std.ArrayList(aoc.Vec2(i16)),
    update_points_right: *std.ArrayList(aoc.Vec2(i16)),
    test_points: *std.ArrayList(aoc.Vec2(i16)),
    pos: aoc.Vec2(u16), dir: aoc.Vec2(i16), width: usize, height: usize, grid: []Cell
) !aoc.Vec2(u16) {
    const size = aoc.Vec2Init(usize, width, height).as(i16);

    test_points.clearRetainingCapacity();
    update_points_left.clearRetainingCapacity();
    update_points_right.clearRetainingCapacity();

    var test_pos = pos.as(i16).addVec(dir);
    if (!test_pos.inBounds(aoc.Vec2Zero(i16), size)) return pos;


    try test_points.append(test_pos);

    outer: while(test_points.items.len > 0)
    {
        const sample = test_points.pop();
        const ind = sample.toIndex(width);
        if (grid[ind] == Cell.CLEAR) continue;
        if (grid[ind] == Cell.WALL) return pos;


        std.debug.assert(grid[ind] != Cell.BOX);
        if (grid[ind] == Cell.LEFTBOX) {
            try update_points_left.append(sample);
            
            if (!aoc.Vec2Init(i16, 1, 0).eq(dir))
                try test_points.append(sample.addVec(dir));

            const rightbox = sample.addVec(aoc.Vec2Init(i16, 1, 0));
            for (update_points_right.items) |up| if (rightbox.eq(up)) continue :outer;
            try test_points.append(rightbox);
        }
        if (grid[ind] == Cell.RIGHTBOX) {
            try update_points_right.append(sample);

            if (!aoc.Vec2Init(i16, -1, 0).eq(dir))
                try test_points.append(sample.addVec(dir));

            const leftbox = sample.addVec(aoc.Vec2Init(i16, -1, 0));
            for (update_points_left.items) |up| if (leftbox.eq(up)) continue :outer;
            try test_points.append(leftbox);
        }
    }

    for (update_points_left.items) |up| grid[up.toIndex(width)] = Cell.CLEAR;
    for (update_points_right.items) |up| grid[up.toIndex(width)] = Cell.CLEAR;
    for (update_points_left.items) |up| grid[up.addVec(dir).toIndex(width)] = Cell.LEFTBOX;
    for (update_points_right.items) |up| grid[up.addVec(dir).toIndex(width)] = Cell.RIGHTBOX;

    return pos.as(i16).addVec(dir).as(u16);
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var pos = aoc.Vec2Zero(u16);
    const width = 2*input.items[0].len;
    const height = input.items[0].len;
    var grid = try alloc.alloc(Cell, height*width);
    defer alloc.free(grid);

    for (input.items[0..height], 0..) |line,y| {
        for (line, 0..) |cell,x| {
            var p1 = aoc.Vec2Init(usize, 2*x, y);
            var p2 = aoc.Vec2Init(usize, 2*x+1, y);
            switch(cell) {
                '#' => {
                    grid[p1.toIndex(width)] = Cell.WALL;
                    grid[p2.toIndex(width)] = Cell.WALL;
                },
                '.' => {
                    grid[p1.toIndex(width)] = Cell.CLEAR;
                    grid[p2.toIndex(width)] = Cell.CLEAR;
                },
                'O' => {
                    grid[p1.toIndex(width)] = Cell.LEFTBOX;
                    grid[p2.toIndex(width)] = Cell.RIGHTBOX;
                },
                '@' => {
                    grid[p1.toIndex(width)] = Cell.CLEAR;
                    grid[p2.toIndex(width)] = Cell.CLEAR;
                    pos = p1.as(u16);
                },
                else => unreachable
            }
        }
    }

    var testpositions = std.ArrayList(aoc.Vec2(i16)).init(alloc);
    defer testpositions.deinit();
    var ul = std.ArrayList(aoc.Vec2(i16)).init(alloc);
    defer ul.deinit();
    var ur = std.ArrayList(aoc.Vec2(i16)).init(alloc);
    defer ur.deinit();

    for (input.items[(height+1)..]) |line| {
        for (line) |dir| {
            switch(dir) {
                '>' => pos = try moveWide(&ul, &ur, &testpositions, pos, aoc.offsets(i16)[0], width, height, grid),
                'v' => pos = try moveWide(&ul, &ur, &testpositions, pos, aoc.offsets(i16)[1], width, height, grid),
                '<' => pos = try moveWide(&ul, &ur, &testpositions, pos, aoc.offsets(i16)[2], width, height, grid),
                '^' => pos = try moveWide(&ul, &ur, &testpositions, pos, aoc.offsets(i16)[3], width, height, grid),
                else => unreachable
            }
        }
    }

    var total: i64 = 0;
    for (0..height) |y| {
        for (0..width) |x| {
            const p = aoc.Vec2Init(usize, x, y);
            if (grid[p.toIndex(width)] != Cell.LEFTBOX) continue;
            const score: i64 = @intCast((100*y) + x);
            total += score;
        }
    }

    return total;
}
