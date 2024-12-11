const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const line = input.items[0];
    var total: i64 = 0;

    var start_id: u32 = 0;
    var end_id: u32 = @intCast(line.len / 2);
    var end_index: u32 = @intCast(line.len-1);
    var end_count: u32 = line[end_index]-48;

    var mul_index: u32 = 0;

    outer: for (line, 0..) |char, index| {
        if (index >= end_index) break;
        const value: u32 = char - 48;

        if (index % 2 == 0) { //File
            for (0..value) |_|
            {
                total += mul_index * start_id;
                mul_index += 1;
            }
            start_id += 1;
        } else { //Space
            for (0..value) |_| {
                //Shift the last one back
                if (end_count == 0) {
                    end_id -= 1;
                    end_index -= 2;
                    if (end_index <= index) break :outer;
                    end_count = line[end_index]-48;
                }

                total += mul_index * end_id;
                mul_index += 1;
                end_count -= 1;

            }
        }
    }

    while (end_count > 0) : (end_count-=1) {
        total += mul_index * end_id;
        mul_index += 1;
    }

    return total;
}

const Entry = struct {
    space: bool = false,
    id: u32 = 0,
    moved: bool = false,
    size: u8 = 0,
};

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var disk = try std.ArrayList(Entry).initCapacity(alloc, input.items[0].len);
    defer disk.deinit();

    for (input.items[0], 0..) |char, ind| {
        if (ind % 2 == 1) {
            try disk.append(.{.space=true, .size=char-48, .moved=true});
        } else {
            try disk.append(.{.id=@intCast(ind/2), .size=char-48});
        }
    }
    //for (disk.items) |item| {
    //    for (0..item.size) |_| {
    //        std.debug.print("{u}", .{if (item.space) '.' else (@as(u8,@intCast(48 + item.id)))});
    //    }
    //}
    //std.debug.print("\n", .{});


    var final_index = disk.items.len-1;
    while (final_index > 0) {
        var i = &disk.items[final_index];
        if (i.moved) {
            final_index -= 1;
            continue;
        }

        var ind: u32 = 0;
        var moved = false;
        while (ind < final_index) : (ind += 1) {
            var target = &disk.items[ind];
            if (!target.space) continue;
            if (target.size < i.size) continue;


            moved = true;
            const remaining_space = target.size - i.size;
            target.space = false;
            target.id = i.id;
            target.size = i.size;

            i.space = true;

            if (remaining_space > 0) {
                try disk.insert(ind+1, .{.space = true, .size = remaining_space, .moved = true});
            }
            break;
        }

        //no space
        if (!moved) {
            i.moved = true;
        }
        final_index -= 1;
    }

    var total: i64 = 0;
    var mul: i64 = 0;
    
    for (disk.items) |item| {
        if (item.space) {
            mul += item.size;
            continue;
        }
        for (0..item.size) |_| {
            total += item.id * mul;
            mul += 1;
        }
    }


    return total;
}
