const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const Cell = enum(u2) {
    CLEAR,
    WALL,
    BOX
};

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
        std.debug.assert(grid[test_pos.toIndex(width)] == Cell.CLEAR);
        std.debug.assert(grid[next.toIndex(width)] != Cell.WALL);

        if (grid[next.toIndex(width)] == Cell.BOX) {
            grid[test_pos.toIndex(width)] = Cell.BOX;
            grid[next.toIndex(width)] = Cell.CLEAR;
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

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
