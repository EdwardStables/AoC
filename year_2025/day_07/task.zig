const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var beam: u160 = 0;
    const one: u160 = 1;
    for (input.items[0], 0..) |c, i| {
        if (c == 'S') {
            beam |= one << @intCast(i);
            break;
        }
    }

    var count: i64 = 0;
    for (input.items[1..]) |line| {
        for (line, 0..) |c, i| {
            const shift: u8 = @intCast(i);
            if (c == '^' and (beam & (one << shift))!=0)  {
                beam ^= (one << shift);
                beam |= (one << shift-1);
                beam |= (one << shift+1);
                count += 1;
            }
        }
    }

    return count;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var beam: [142]u64 = undefined;
    var beam_next: [142]u64 = undefined;
    for (input.items[0], 0..) |c, i| {
        beam[i] = 0;
        beam_next[i] = 0;
        if (c == 'S') {
            beam[i] = 1;
        }
    }

    var count: i64 = 1;
    for (input.items[1..]) |line| {
        for (line, 0..) |c, i| {
            if (c == '^' and beam[i] != 0)  {
                beam_next[i] = 0;
                beam_next[i-1] += beam[i];
                beam_next[i+1] += beam[i];
                count += @intCast(beam[i]);
            } else {
                beam_next[i] += beam[i];
            }

            beam[i] = 0;
        }
        const tmp = beam;
        beam = beam_next;
        beam_next = tmp;
    }

    return count;
}

