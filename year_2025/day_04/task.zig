const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    const W = input.items[0].len;
    const H = input.items.len;
    for (0..H) |y| {
        for (0..W) |x| {
            if (input.items[y][x] != '@') continue;
            var roll_count: u8 = 0;
            if (y > 0   and x > 0  ) roll_count += if (input.items[y-1][x-1] == '@') 1 else 0;
            if (y > 0              ) roll_count += if (input.items[y-1][x  ] == '@') 1 else 0;
            if (y > 0   and x < W-1) roll_count += if (input.items[y-1][x+1] == '@') 1 else 0;
            if (            x > 0  ) roll_count += if (input.items[y  ][x-1] == '@') 1 else 0;
            if (            x < W-1) roll_count += if (input.items[y  ][x+1] == '@') 1 else 0;
            if (y < H-1 and x > 0  ) roll_count += if (input.items[y+1][x-1] == '@') 1 else 0;
            if (y < H-1            ) roll_count += if (input.items[y+1][x  ] == '@') 1 else 0;
            if (y < H-1 and x < W-1) roll_count += if (input.items[y+1][x+1] == '@') 1 else 0;
            if (roll_count < 4) total += 1;
        }
    }
    return total;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const W = input.items[0].len;
    const H = input.items.len;
    var grid = try alloc.alloc(?u8, W*H); defer alloc.free(grid);
    for (0..H) |y| {
        for (0..W) |x| {
            const v = aoc.Vec2Init(usize, x, y);
            if (input.items[y][x] == '.') {
                grid[v.toIndex(W)] = null;
                continue;
            }
            var roll_count: u8 = 0;
            if (y > 0   and x > 0  ) roll_count += if (input.items[y-1][x-1] != '.') 1 else 0;
            if (y > 0              ) roll_count += if (input.items[y-1][x  ] != '.') 1 else 0;
            if (y > 0   and x < W-1) roll_count += if (input.items[y-1][x+1] != '.') 1 else 0;
            if (            x > 0  ) roll_count += if (input.items[y  ][x-1] != '.') 1 else 0;
            if (            x < W-1) roll_count += if (input.items[y  ][x+1] != '.') 1 else 0;
            if (y < H-1 and x > 0  ) roll_count += if (input.items[y+1][x-1] != '.') 1 else 0;
            if (y < H-1            ) roll_count += if (input.items[y+1][x  ] != '.') 1 else 0;
            if (y < H-1 and x < W-1) roll_count += if (input.items[y+1][x+1] != '.') 1 else 0;

            grid[v.toIndex(W)] = roll_count;
        }
    }

    var updated = true;
    var removed: i64 = 0;
    while (updated) {
        updated = false;
        for (0..H) |y| {
            for (0..W) |x| {
                const v = aoc.Vec2Init(usize, x, y);
                const i = v.toIndex(W);
                if ((grid[i] orelse 255) >= 4) continue;
                updated = true;
                grid[i] = null;
                removed += 1;
                if (v.upleft())        |jv| {const j = jv.toIndex(W); if (grid[j] orelse 0 > 0) grid[j].? -= 1;}
                if (v.up())            |jv| {const j = jv.toIndex(W); if (grid[j] orelse 0 > 0) grid[j].? -= 1;}
                if (v.upright(W))      |jv| {const j = jv.toIndex(W); if (grid[j] orelse 0 > 0) grid[j].? -= 1;}
                if (v.left())          |jv| {const j = jv.toIndex(W); if (grid[j] orelse 0 > 0) grid[j].? -= 1;}
                if (v.right(W))        |jv| {const j = jv.toIndex(W); if (grid[j] orelse 0 > 0) grid[j].? -= 1;}
                if (v.downleft(H))     |jv| {const j = jv.toIndex(W); if (grid[j] orelse 0 > 0) grid[j].? -= 1;}
                if (v.down(H))         |jv| {const j = jv.toIndex(W); if (grid[j] orelse 0 > 0) grid[j].? -= 1;}
                if (v.downright(W, H)) |jv| {const j = jv.toIndex(W); if (grid[j] orelse 0 > 0) grid[j].? -= 1;}
            }
        }
    }
    return removed;
}