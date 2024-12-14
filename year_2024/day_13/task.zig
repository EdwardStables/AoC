const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const Game = struct {
    ax: i64,
    ay: i64,
    bx: i64,
    by: i64,
    tx: i64,
    ty: i64,
};

fn getGame(input: *std.ArrayList([]const u8), line: u32) Game {
    const ax = 10*(input.items[line+0][12]-48) + (input.items[line+0][13]-48);
    const ay = 10*(input.items[line+0][18]-48) + (input.items[line+0][19]-48);
    const bx = 10*(input.items[line+1][12]-48) + (input.items[line+1][13]-48);
    const by = 10*(input.items[line+1][18]-48) + (input.items[line+1][19]-48);
    var tx: u32 = 0;
    var ty: u32 = 0;
    var line_ind = input.items[line+2].len-1;
    var mult: u32 = 1;
    var write_y = true;
    while (line_ind > 8) : (line_ind -= 1) {
        const c: u8 = input.items[line+2][line_ind];
        if (c == '=' or c == 'Y' or c == ' ' or c == ',') {
            write_y = false;
            mult = 1;
            continue;
        }
        if (c == 'X') break;
        const val: u32 = @as(u32, @intCast(c - 48)) * mult;
        if (write_y) {
            ty += val;
        } else {
            tx += val;
        }
        mult *= 10;
    }

    return .{.ax=ax, .ay=ay, .bx=bx, .by=by, .tx=tx, .ty=ty};
}

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    var line: u32 = 0;
    while (line < input.items.len) : (line += 4) {
        const game = getGame(input, line);

        const det = @as(f32, @floatFromInt((game.by*game.ax) - (game.bx*game.ay)));
        if (det == 0) continue;

        const pa = @as(f32, @floatFromInt((game.by*game.tx) - (game.bx*game.ty))) / det;
        const pb = @as(f32, @floatFromInt((game.ax*game.ty) - (game.ay*game.tx))) / det;

        if (@floor(pa) != pa) continue;
        if (@floor(pb) != pb) continue;
        if (pa > 100 or pb > 100) continue;

        total += @intFromFloat((3*pa)+pb);
    }
    return total;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    var line: u32 = 0;
    const offs = 10000000000000;
    while (line < input.items.len) : (line += 4) {
        var game = getGame(input, line);
        game.tx += offs;
        game.ty += offs;

        const det = (game.by*game.ax) - (game.bx*game.ay);
        if (det == 0) continue;

        const pa = @divFloor((game.by*game.tx) - (game.bx*game.ty), det);
        const pb = @divFloor((game.ax*game.ty) - (game.ay*game.tx), det);

        if (pa < 0) continue;
        if (pb < 0) continue;

        const rx = pa*game.ax + pb*game.bx;
        const ry = pa*game.ay + pb*game.by;
        if (game.tx != rx) continue;
        if (game.ty != ry) continue;

        total += (3*pa)+pb;
    }
    return total;
}
