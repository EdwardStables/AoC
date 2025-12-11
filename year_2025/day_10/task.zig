const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const Button = u16;

const Light = struct {
    width: u4,
    number: u16
};

fn count(setting: usize) i64 {
    var _setting = setting;
    var c: i64 = 0;
    while (_setting > 0) {
        if (_setting & 1 == 1) c+= 1;
        _setting >>= 1;
    }
    return c;
}

fn line_satisfied(light: Light, buttons: std.ArrayList(Button), setting: usize) bool {
    var _setting = setting;
    var result: u16 = 0;
    for (buttons.items) |b| {
        if (_setting & 1 == 1) {
            result ^= b;
        }
        _setting >>= 1;
        if (_setting == 0) break;
    }

    return result == light.number;
}

fn solve_line_lights(light: Light, buttons: std.ArrayList(Button)) i64 {
    var min_count: ?i64 = null;
    for (0..std.math.pow(usize,2,buttons.items.len)-1) |setting| {
        if (line_satisfied(light, buttons, setting)) {
            const c = count(setting);
            if (min_count == null or c < min_count.?) {
                min_count = c;
            }
        }
    }
    return min_count orelse unreachable;
}

fn parse_lights(line: []const u8) Light {
    var light: Light = .{.number = 0, .width=0};
    for (line) |c| {
        if (c == '[') continue;
        if (c == ']') break;
        if (c == '#') {
            light.number |= @as(u16,@intCast(1)) << light.width;
        }
        light.width += 1;
    }
    return light;
}

fn parse_buttons(buttons: *std.ArrayList(Button), width: u4, alloc: Allocator, line: []const u8) !void {
    var chunk_it = std.mem.splitScalar(u8, line, ' ');
    while (chunk_it.next()) |chunk| {
        if (chunk[0] == '[') continue;
        if (chunk[0] == '{') break;

        var index_it = std.mem.splitScalar(u8, chunk[1..chunk.len-1], ',');
        var num: u16 = 0;
        while (index_it.next()) |index| {
            const n = aoc.intParse(u8,index);
            std.debug.assert(n < width);
            num |= @as(u16,@intCast(1)) << @as(u4,@intCast(n));
        }
        try buttons.append(alloc, num);
    }
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var buttons = try std.ArrayList(Button).initCapacity(alloc, 10); defer buttons.deinit(alloc);
    var result: i64 = 0;
    for (input.items) |line| {
        const light = parse_lights(line);
        buttons.clearRetainingCapacity();
        try parse_buttons(&buttons, light.width, alloc, line);
        result += solve_line_lights(light, buttons);
    }

    return result;
}

const Jolts = struct {
    width: u4,
    jolts: []u8
};

fn parse_jolts(alloc: Allocator, line: []const u8) !Jolts {
    var chunk_it = std.mem.splitScalar(u8, line, ' ');
    var jolt: Jolts = .{ .jolts = undefined, .width=1};
    while (chunk_it.next()) |chunk| {
        if (chunk[0] != '{') continue;

        for (chunk) |ch| {if (ch==',') jolt.width+=1;}
        jolt.jolts = try alloc.alloc(u8,jolt.width);
        var index_it = std.mem.splitScalar(u8, chunk[1..chunk.len-1], ',');
        var i: usize = 0;
        while (index_it.next()) |index| : (i+=1)  {
            jolt.jolts[i] = aoc.intParse(u8,index);
        }
    }

    return jolt;
}
fn line_satisfied_jolts(jolts: Jolts, buttons: std.ArrayList(Button), presses: []u8) ?bool {
    var equal = true;
    for (presses) |p| std.debug.print("{d} ", .{p});
    std.debug.print("\n", .{});
    for (jolts.jolts, 0..) |j, ji| {
        var jsum: u8 = 0;
        for (buttons.items, 0..) |b, bi| {
            if (((b >> @as(u4,@intCast(ji))) & 1) == 1) {
                jsum += presses[bi];
            }
        }
        //std.debug.print("{d} {d} {d}\n", .{ji, j, jsum});
        if (jsum > j) return null;
        if (jsum < j) equal = false;
    }
    return equal;
}

fn button_count(counts: []u8) i64 {
    var s: i64 = 0;
    for (counts) |c| {
        s += c;
    }
    return s;
}

fn solve_line_jolts(jolts: Jolts, buttons: std.ArrayList(Button), alloc: Allocator) !i64 {
    std.debug.print("line\n", .{});
    var queue = try std.ArrayList([]u8).initCapacity(alloc, 1000); defer queue.deinit(alloc);
    const bw = buttons.items.len;
    const start_presses = try alloc.alloc(u8, bw);
    for (0..bw) |i| start_presses[i] = 0;
    try queue.append(alloc, start_presses);

    var queue_index: usize  = 0;
    var min_count: ?i64 = null;
    while (queue_index < queue.items.len) : (queue_index += 1) {
        if (min_count) |c| std.debug.print("{d}\n", .{c});
        const sat = line_satisfied_jolts(jolts, buttons, queue.items[queue_index]);
        if (sat==null) continue;
        if (sat.?) { //value matches requirement
            const c = button_count(queue.items[queue_index]);
            if (min_count == null or c < min_count.?) {
                min_count = c;
            }
            continue;
        } else {
            for (0..bw) |i| {
                const new_presses = try alloc.alloc(u8, bw);
                for (0..bw) |j| {
                    new_presses[j] = queue.items[queue_index][j];
                }
                new_presses[i] += 1;
                try queue.append(alloc, new_presses);
            }
        }
    }

    for (queue.items) |q| {
        alloc.free(q);
    }

    return min_count orelse unreachable;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var buttons = try std.ArrayList(Button).initCapacity(alloc, 10); defer buttons.deinit(alloc);
    var result: i64 = 0;
    for (input.items) |line| {
        const jolts = try parse_jolts(alloc, line);
        buttons.clearRetainingCapacity();
        try parse_buttons(&buttons, jolts.width, alloc, line);
        result += try solve_line_jolts(jolts, buttons, alloc);
    }

    return result;
}
