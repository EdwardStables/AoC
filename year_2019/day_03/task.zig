const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var line1 = std.ArrayList(aoc.Vec2(i16)).init(alloc);
    defer line1.deinit();
    var line1_pos: aoc.Vec2(i16) = .{.x=0,.y=0};
    var line2_pos: aoc.Vec2(i16) = .{.x=0,.y=0};

    var si = std.mem.splitAny(u8, input.items[0], ","); 
    while (si.next()) |token| {
        const d = switch(token[0]) {
            'R' => aoc.rt(i16),
            'L' => aoc.lt(i16),
            'U' => aoc.up(i16),
            else => aoc.dn(i16), //D
        };
        const count = try std.fmt.parseInt(u16, token[1..], 10);
        for (0..count) |_| {
            line1_pos = line1_pos.addVec(d);
            try line1.append(line1_pos);
        }
    }

    var closest: ?i64 = null;
    var sj = std.mem.splitAny(u8, input.items[1], ","); 
    while (sj.next()) |token| {
        const d = switch(token[0]) {
            'R' => aoc.rt(i16),
            'L' => aoc.lt(i16),
            'U' => aoc.up(i16),
            else => aoc.dn(i16), //D
        };

        for (0..(try std.fmt.parseInt(u16, token[1..], 10))) |_| {
            line2_pos = line2_pos.addVec(d);
            for (line1.items) |l1| {
                if (l1.eq(line2_pos)) {
                    const p_mh = @abs(l1.x) + @abs(l1.y);
                    if (p_mh <= closest orelse p_mh) {
                        closest = p_mh;
                    }
                }
            }
        }
    }

    return closest orelse error.Unexpected;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var line1 = std.ArrayList(aoc.Vec2(i16)).init(alloc);
    defer line1.deinit();
    var line1_pos: aoc.Vec2(i16) = .{.x=0,.y=0};
    var line2_pos: aoc.Vec2(i16) = .{.x=0,.y=0};

    var si = std.mem.splitAny(u8, input.items[0], ","); 
    while (si.next()) |token| {
        const d = switch(token[0]) {
            'R' => aoc.rt(i16),
            'L' => aoc.lt(i16),
            'U' => aoc.up(i16),
            else => aoc.dn(i16), //D
        };
        const count = try std.fmt.parseInt(u16, token[1..], 10);
        for (0..count) |_| {
            line1_pos = line1_pos.addVec(d);
            try line1.append(line1_pos);
        }
    }

    var closest: ?i64 = null;
    var sj = std.mem.splitAny(u8, input.items[1], ","); 
    var l2i: u32 = 0;
    while (sj.next()) |token| {
        const d = switch(token[0]) {
            'R' => aoc.rt(i16),
            'L' => aoc.lt(i16),
            'U' => aoc.up(i16),
            else => aoc.dn(i16), //D
        };

        for (0..(try std.fmt.parseInt(u16, token[1..], 10))) |_| {
            line2_pos = line2_pos.addVec(d);
            l2i += 1;
            for (line1.items, 1..) |l1, l1i| {
                if (l1.eq(line2_pos)) {
                    const p_dist: i64 = @intCast(l2i + l1i);
                    if (p_dist <= closest orelse p_dist) {
                        closest = p_dist;
                    }
                }
            }
        }
    }

    return closest orelse error.Unexpected;
}
