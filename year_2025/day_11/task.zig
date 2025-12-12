const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn paths(nodes: usize, current: usize, end: usize, graph: []bool) i64 {
    //std.debug.print("{d}\n", .{current});
    var count: i64 = 0;

    for (0..nodes) |i| {
        if (graph[nodes*current + i]) {
            if (i == end) return 1;
            count += paths(nodes, i, end, graph);
        }
    }

    return count;
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const nodes = input.items.len + 1;
    var graph = try alloc.alloc(bool, nodes*nodes); defer alloc.free(graph);
    var map = std.StringHashMap(usize).init(alloc); defer map.deinit();

    for (0..graph.len) |i| {
        graph[i] = false;
    }

    var start: usize = 0;
    const end: usize = nodes-1;

    for (input.items, 0..) |line, i| {
        try map.put(line[0..3], i);
        if (line[0] == 'y' and line[1] == 'o' and line[2] == 'u') {
            start = i;
        }
    }
    try map.put("out", nodes-1);

    for (input.items, 0..) |line, source| {
        var i: usize = 5;
        while (i < line.len) : (i += 4) {
            const dest = map.get(line[i..i+3]) orelse {std.debug.print("{s}\n", .{line[i..i+3]}); unreachable;};
            graph[(source * nodes) + dest] = true;
            //const source_str = line[0..3];
            //const dest_str = line[i..i+3];
            //std.debug.print("{s}({d}) -> {s}({d})\n", .{source_str, source, dest_str, dest} );
        }
    }

    //for (0..nodes) |c| {
    //    for (0..nodes) |r| {
    //        std.debug.print("{s} ", .{if (graph[c*nodes + r]) "X" else "_"});
    //    }
    //    std.debug.print("\n", .{});
    //}

    return paths(nodes, start, end, graph);
}

const MemEntry = struct {
    no_no: usize,
    yes_no: usize,
    no_yes: usize,
    yes_yes: usize,
};

fn paths_limited(nodes: usize, current: usize, end: usize, graph: []bool, fft: usize, dac: usize, mem: *std.AutoHashMap(usize, MemEntry)) !MemEntry {
    if (mem.get(current)) |value| {
        //std.debug.print("got current {d} : {d} {d} {d} {d}\n", .{current, value.yes_no, value.yes_no, value.no_yes, value.no_no});
        return value;
    }


    //std.debug.print("{d} | ", .{current});
    //if (history) |hist| {
    //    for (hist) |h| {
    //        std.debug.print("{d} ", .{h});
    //    }
    //} else {
    //    std.debug.print("-", .{});
    //}
    //std.debug.print("\n", .{});
    var count: MemEntry = .{.no_no=0,.no_yes=0,.yes_no=0,.yes_yes=0};

    for (0..nodes) |i| {
        if (graph[nodes*current + i]) {
            const new_count = try paths_limited(nodes, i, end, graph, fft, dac, mem);

            count.yes_yes += new_count.yes_yes;

            if (current == fft) {
                count.yes_yes += new_count.no_yes;
                count.yes_no += new_count.no_no;
            }
            count.yes_no += new_count.yes_no;

            if (current == dac) {
                count.yes_yes += new_count.yes_no;
                count.no_yes += new_count.no_no;
            }
            count.no_yes += new_count.no_yes;

            if (current != dac and current != fft) {
                count.no_no += new_count.no_no;
            }
        }
    }

    try mem.put(current, count);

    return count;
}


pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const nodes = input.items.len + 1;
    var graph = try alloc.alloc(bool, nodes*nodes); defer alloc.free(graph);
    var map = std.StringHashMap(usize).init(alloc); defer map.deinit();

    for (0..graph.len) |i| {
        graph[i] = false;
    }

    var start: usize = 0;
    var fft: usize = 0;
    var dac: usize = 0;
    const end: usize = nodes-1;

    for (input.items, 0..) |line, i| {
        try map.put(line[0..3], i);
        if (line[0] == 's' and line[1] == 'v' and line[2] == 'r') start = i;
        if (line[0] == 'd' and line[1] == 'a' and line[2] == 'c') dac = i;
        if (line[0] == 'f' and line[1] == 'f' and line[2] == 't') fft = i;
    }
    try map.put("out", nodes-1);

    for (input.items, 0..) |line, source| {
        var i: usize = 5;
        while (i < line.len) : (i += 4) {
            const dest = map.get(line[i..i+3]) orelse {std.debug.print("{s}\n", .{line[i..i+3]}); unreachable;};
            graph[(source * nodes) + dest] = true;
            //const source_str = line[0..3];
            //const dest_str = line[i..i+3];
            //std.debug.print("{s}({d}) -> {s}({d})\n", .{source_str, source, dest_str, dest} );
        }
    }

    //for (0..nodes) |c| {
    //    for (0..nodes) |r| {
    //        std.debug.print("{s} ", .{if (graph[c*nodes + r]) "X" else "_"});
    //    }
    //    std.debug.print("\n", .{});
    //}
    var mem = std.AutoHashMap(usize, MemEntry).init(alloc); defer mem.deinit();
    try mem.put(end, .{.no_no=1,.no_yes=0,.yes_no=0,.yes_yes=0});
    _ = try paths_limited(nodes, start, end, graph, fft, dac, &mem);
    return @intCast(mem.get(start).?.yes_yes);
}
