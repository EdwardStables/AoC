const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task3(_: Allocator, _: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    return 0;
}
pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const width = 25;
    const height = 6;
    const layer_size = width*height;

    var min_layer: ?usize = null;
    var min_count: ?usize = null;

    var layer: usize = 0;
    var layer_index: usize = 0;
    var zero_count: usize = 0;
    for (input.items[0]) |digit| {
        layer_index += 1;
        if (digit == '0') zero_count+=1;

        if (layer_index == layer_size) {
            if (min_layer == null or min_count.? > zero_count) {
                min_layer = layer;
                min_count = zero_count;
            }

            layer += 1;
            layer_index = 0;
            zero_count = 0;
        }
    }

    var one_count: i64 = 0;
    var two_count: i64 = 0;
    for (input.items[0][min_layer.?*layer_size..(min_layer.?+1)*layer_size]) |digit| {
        if (digit == '1') one_count += 1;
        if (digit == '2') two_count += 1;
    }

    return one_count * two_count;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const width = 25;
    const height = 6;
    //const width = 2;
    //const height = 2;
    const layer_size = width*height;
    const layer_count = input.items[0].len / layer_size;

    var row_out = [_]u8{0} ** width;

    for (0..height) |row| {
        for (0..width) |col| {
            var layer = layer_count;
            while (layer > 0) {
                layer -= 1;
                const ind = layer*layer_size + (row*width) + col;

                switch(input.items[0][ind]) {
                    '0' => row_out[col] = ' ',
                    '1' => row_out[col] = 'X',
                    '2' => {},
                    else => unreachable
                }
            }
        }
        std.debug.print("{s}\n", .{&row_out});
    }



    return 0;
}
