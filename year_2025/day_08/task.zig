const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const Vec3 = struct {
    x: i64,
    y: i64,
    z: i64,

    pub fn euc2(self: Vec3, other: Vec3) i64 {
        const x = other.x - self.x;
        const y = other.y - self.y;
        const z = other.z - self.z;
        return x*x + y*y + z*z;
    }
};

const Dist = struct {
    indexes: aoc.Vec2(usize), dist: i64, valid: bool,
    pub fn comp(_: void, L: Dist, R: Dist) bool {
        if (!L.valid and !R.valid) return false;
        if (L.valid and !R.valid) return true;
        if (!L.valid and R.valid) return false;
        return L.dist < R.dist;
    }
};

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var inputs = try alloc.alloc(Vec3, input.items.len); defer alloc.free(inputs);
    var ids = try alloc.alloc(?u16, input.items.len); defer alloc.free(ids);

    var dist = try alloc.alloc(Dist, input.items.len*input.items.len); defer alloc.free(dist);

    for (input.items, 0..) |a, i| {
        var it = std.mem.splitScalar(u8, a, ',');
        inputs[i].x = aoc.intParse(i64, it.next().?);
        inputs[i].y = aoc.intParse(i64, it.next().?);
        inputs[i].z = aoc.intParse(i64, it.next().?);
        
        ids[i] = null;
    }

    for (inputs, 0..) |a, i| {
        for (inputs, 0..) |b, j| {
            const ind  = aoc.Vec2Init(usize, i, j).toIndex(inputs.len);
            dist[ind].valid = false;
            if (j<=i) continue;
            const d = a.euc2(b);
            dist[ind].valid = true;
            dist[ind].dist = d;
            dist[ind].indexes.x = i;
            dist[ind].indexes.y = j;
        }
    }

    std.mem.sort(Dist, dist, {}, Dist.comp);
    var dist_index: usize = 0;
    var next_id: u16 = 0;
    for (0..1000) |_| {
        std.debug.assert(dist[dist_index].valid);

        const i = dist[dist_index].indexes.x;
        const j = dist[dist_index].indexes.y;
        //const d = dist[dist_index].dist;
        dist_index += 1;

        //std.debug.print("{d}, {d} {e} \n\n", .{i, j, closest_dist});
        //for (ids) |id| { std.debug.print("{d}\n", .{id orelse 1000}); }
        //std.debug.print("\n", .{});

        if (ids[i] == null and ids[j] == null) {
            ids[i] = next_id;
            ids[j] = next_id;
            next_id += 1;
        } else 
        if (ids[i] == null and ids[j] != null) {
            ids[i] = ids[j];
        } else 
        if (ids[i] != null and ids[j] == null) {
            ids[j] = ids[i];
        } else {
            std.debug.assert(ids[i] != null and ids[j] != null);
            if (ids[i].? == ids[j].?) continue;

            const old = ids[j];
            const new = ids[i];
            for (ids, 0..) |id, k| {
                if (id == null) continue;
                if (id.? == old) {
                    ids[k] = new;
                }
            }
        }
        //for (ids) |id| { std.debug.print("{d}\n", .{id orelse 1000}); }
    }

    var id_counts = try alloc.alloc(i64, next_id); defer alloc.free(id_counts);
    for (0..id_counts.len) |i| { id_counts[i] = 0; }
    for (ids) |id| {
        id_counts[id orelse continue] += 1;
    }

    var first_ind: usize = 0;
    var first_val: i64 = 0;
    for (id_counts, 0..) |v, i| {
        if (v > first_val){
            first_ind = i;
            first_val = v;
        } 
    }

    var second_ind: usize = 0;
    var second_val: i64 = 0;
    for (id_counts, 0..) |v, i| {
        if (i == first_ind) continue;
        if (v > second_val){
            second_ind = i;
            second_val = v;
        } 
    }

    var third_ind: usize = 0;
    var third_val: i64 = 0;
    for (id_counts, 0..) |v, i| {
        if (i == first_ind or i == second_ind) continue;
        if (v > third_val){
            third_ind = i;
            third_val = v;
        } 
    }

    return first_val * second_val * third_val;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var inputs = try alloc.alloc(Vec3, input.items.len); defer alloc.free(inputs);
    var ids = try alloc.alloc(?u16, input.items.len); defer alloc.free(ids);

    var dist = try alloc.alloc(Dist, input.items.len*input.items.len); defer alloc.free(dist);

    for (input.items, 0..) |a, i| {
        var it = std.mem.splitScalar(u8, a, ',');
        inputs[i].x = aoc.intParse(i64, it.next().?);
        inputs[i].y = aoc.intParse(i64, it.next().?);
        inputs[i].z = aoc.intParse(i64, it.next().?);
        
        ids[i] = null;
    }

    for (inputs, 0..) |a, i| {
        for (inputs, 0..) |b, j| {
            const ind  = aoc.Vec2Init(usize, i, j).toIndex(inputs.len);
            dist[ind].valid = false;
            if (j<=i) continue;
            const d = a.euc2(b);
            dist[ind].valid = true;
            dist[ind].dist = d;
            dist[ind].indexes.x = i;
            dist[ind].indexes.y = j;
        }
    }

    std.mem.sort(Dist, dist, {}, Dist.comp);
    var dist_index: usize = 0;
    var next_id: u16 = 0;
    outer: while (true) {
        std.debug.assert(dist[dist_index].valid);

        const i = dist[dist_index].indexes.x;
        const j = dist[dist_index].indexes.y;
        //const d = dist[dist_index].dist;
        dist_index += 1;

        //std.debug.print("{d}, {d} {e} \n\n", .{i, j, closest_dist});
        //for (ids) |id| { std.debug.print("{d}\n", .{id orelse 1000}); }
        //std.debug.print("\n", .{});

        if (ids[i] == null and ids[j] == null) {
            ids[i] = next_id;
            ids[j] = next_id;
            next_id += 1;
        } else 
        if (ids[i] == null and ids[j] != null) {
            ids[i] = ids[j];
        } else 
        if (ids[i] != null and ids[j] == null) {
            ids[j] = ids[i];
        } else {
            std.debug.assert(ids[i] != null and ids[j] != null);
            if (ids[i].? == ids[j].?) continue;

            const old = ids[j];
            const new = ids[i];
            for (ids, 0..) |id, k| {
                if (id == null) continue;
                if (id.? == old) {
                    ids[k] = new;
                }
            }

        }

        var first: ?u16 = null;
        for (ids) |id| {
            if (id == null) continue :outer;
            if (first != null and (id != first)) continue :outer;
            first = id.?;
        }
        return inputs[i].x * inputs[j].x;
    }

    unreachable;
}
