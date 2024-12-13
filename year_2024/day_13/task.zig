const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const Game = struct {
    ax: u32,
    ay: u32,
    bx: u32,
    by: u32,
    tx: u32,
    ty: u32,
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

        var found_sln = false;
        var best_cost: i64 = 0;
        var pa_max = @divTrunc(game.tx, game.ax)+1;
        var pb_max = @divTrunc(game.tx, game.bx)+1;
        if (pa_max > 100) pa_max = 100;
        if (pb_max > 100) pb_max = 100;

        for (0..pa_max) |pa| {
            for (0..pb_max) |pb| {
                const cost: i64 = @intCast(3*pa + pb);
                if (found_sln and best_cost < cost) break;
                const xres = pa*game.ax + pb*game.bx;
                const yres = pa*game.ay + pb*game.by;
                if (xres == game.tx and yres == game.ty) {
                    if (found_sln == false) {
                        found_sln = true;
                        best_cost = cost;
                    } else {
                        if (cost < best_cost) {
                            best_cost = cost;
                        }
                    }
                }
            }
        }
        total += best_cost;
    }
    return total;
}

pub fn task2(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
