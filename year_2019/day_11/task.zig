const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const IntCode = @import("../intcode.zig").IntCode;
const Allocator = std.mem.Allocator;

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const canvas_size = 80;
    var colour = try alloc.alloc(bool, canvas_size*canvas_size); defer alloc.free(colour);
    var drawn = try alloc.alloc(bool, canvas_size*canvas_size); defer alloc.free(drawn);

    var pos = aoc.Vec2Init(i32, canvas_size/2, canvas_size/2);
    var dir = aoc.up(i32);

    var ic = try IntCode.init(alloc, input.items[0]); defer ic.deinit();

    while (true) {
        try ic.pushInput(if (colour[pos.toIndex(canvas_size)]) 1 else 0);
        const new_colour = ic.executeUntilOutput(false) orelse break;
        const lr = ic.executeUntilOutput(false) orelse unreachable;

        colour[pos.toIndex(canvas_size)] = if (new_colour == 1) true else false;
        drawn[pos.toIndex(canvas_size)] = true;
        if (lr == 0) {
            dir = dir.rotate_left();
        } else {
            dir = dir.rotate_right();
        }

        pos = pos.addVec(dir);
    }

    //for (0..canvas_size) |y| {
    //    for (0..canvas_size) |x| {
    //        if (colour[aoc.Vec2Init(usize, x, y).toIndex(canvas_size)])
    //            std.debug.print("X", .{})
    //        else
    //            std.debug.print(" ", .{});
    //    }
    //    std.debug.print("\n", .{});
    //}
    var paint_count: i64 = 0;
    for (0..drawn.len) |i| {if (drawn[i]) paint_count+=1;}

    return paint_count;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const canvas_size = 100;
    var colour = try alloc.alloc(bool, canvas_size*canvas_size); defer alloc.free(colour);
    var pos = aoc.Vec2Init(i16, canvas_size/2, canvas_size/2);
    colour[pos.as(u32).toIndex(canvas_size)] = true;
    var dir = aoc.up(i16);

    var ic = try IntCode.init(alloc, input.items[0]); defer ic.deinit();

    while (true) {
        try ic.pushInput(if (colour[pos.as(u32).toIndex(canvas_size)]) 1 else 0);
        const new_colour = ic.executeUntilOutput(false) orelse break;
        const lr = ic.executeUntilOutput(false) orelse unreachable;

        colour[pos.toIndex(canvas_size)] = if (new_colour == 1) true else false;
        if (lr == 0) {
            dir = dir.rotate_left();
        } else {
            dir = dir.rotate_right();
        }
        pos = pos.addVec(dir);
    }


    for (0..canvas_size) |y| {
        var draws = false;
        for (0..canvas_size) |x| {
            if (colour[aoc.Vec2Init(usize, x, y).toIndex(canvas_size)]) {draws = true;}
        }
        if (draws) {
            for (0..canvas_size) |x| {
                if (colour[aoc.Vec2Init(usize, canvas_size-x, y).toIndex(canvas_size)])
                    std.debug.print("X", .{})
                else
                    std.debug.print(" ", .{});
            }
            std.debug.print("\n", .{});
        }
    }

    return 0;
}
