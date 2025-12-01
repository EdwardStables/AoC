const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const Vec3 = struct {
    const Self = @This();
    x: i16,
    y: i16,
    z: i16,

    //x=9, y=13, z=-8
    pub fn fromString(s: []const u8) Vec3 {
        var it = std.mem.splitSequence(u8, s, ", ");
        var tok = it.next().?[2..];
        const x = std.fmt.parseInt(i16, tok, 10) catch unreachable;
        tok = it.next().?[2..];
        const y = std.fmt.parseInt(i16, tok, 10) catch unreachable;
        tok = it.next().?[2..];
        const z = std.fmt.parseInt(i16, tok, 10) catch unreachable;
        std.debug.assert(it.next() == null);
        return .{.x=x,.y=y,.z=z};
    }

};

const Moon = struct {
    p: Vec3,
    v: Vec3,

    pub fn init(pos: Vec3) Moon {
        return .{.p=pos, .v=.{.x=0,.y=0,.z=0}};
    }

    pub fn energy(self: Moon) i64 {
        return (@abs(self.p.x) + @abs(self.p.y) + @abs(self.p.z)) * 
               (@abs(self.v.x) + @abs(self.v.y) + @abs(self.v.z));
    }

    pub fn update_position(self: *Moon) void {
        self.p.x += self.v.x;
        self.p.y += self.v.y;
        self.p.z += self.v.z;
    }

    pub fn update_velocity(self: *Moon, other: *Moon) void {
        if (self.p.x < other.p.x) {
            self.v.x += 1;
            other.v.x -= 1;
        } else
        if (self.p.x > other.p.x) {
            self.v.x -= 1;
            other.v.x += 1;
        }
        if (self.p.y < other.p.y) {
            self.v.y += 1;
            other.v.y -= 1;
        } else
        if (self.p.y > other.p.y) {
            self.v.y -= 1;
            other.v.y += 1;
        }
        if (self.p.z < other.p.z) {
            self.v.z += 1;
            other.v.z -= 1;
        } else
        if (self.p.z > other.p.z) {
            self.v.z -= 1;
            other.v.z += 1;
        }
    }

    pub fn print(self: Moon) void {
        std.debug.print("pos=<x={d: >2}, y={d: >2}, z={d: >2}>, vel=<x={d: >2}, y={d: >2}, z={d: >2}>\n", .{self.p.x, self.p.y, self.p.z, self.v.x, self.v.y, self.v.z});
    }
};

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const steps = 1000;
    std.debug.assert(input.items.len == 4);
    var moons = [4]Moon{
        Moon.init(Vec3.fromString(input.items[0][1..input.items[0].len-1])),
        Moon.init(Vec3.fromString(input.items[1][1..input.items[1].len-1])),
        Moon.init(Vec3.fromString(input.items[2][1..input.items[2].len-1])),
        Moon.init(Vec3.fromString(input.items[3][1..input.items[3].len-1]))
    };

    //std.debug.print("\nAfter 0 steps:\n", .{});
    //for (0..moons.len) |l| {
    //    moons[l].print();
    //}

    for (0..steps) |_| {
        for (0..moons.len) |l| {
            for (l+1..moons.len) |r| {
                moons[l].update_velocity(&moons[r]);
            }
        }
        for (0..moons.len) |l| {
            moons[l].update_position();
        }

        //std.debug.print("\nAfter {d} steps:\n", .{s+1});
        //for (0..moons.len) |l| {
        //    moons[l].print();
        //}
    }

    return moons[0].energy() +  
           moons[1].energy() +  
           moons[2].energy() +  
           moons[3].energy();
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const steps = 100000000000;
    //const steps = 5000000;
    std.debug.assert(input.items.len == 4);
    var moons = [4]Moon{
        Moon.init(Vec3.fromString(input.items[0][1..input.items[0].len-1])),
        Moon.init(Vec3.fromString(input.items[1][1..input.items[1].len-1])),
        Moon.init(Vec3.fromString(input.items[2][1..input.items[2].len-1])),
        Moon.init(Vec3.fromString(input.items[3][1..input.items[3].len-1]))
    };

    var rep_step: i64 = 0;
    for (0..steps) |s| {
        for (0..moons.len) |l| {
            for (l+1..moons.len) |r| {
                moons[l].update_velocity(&moons[r]);
            }
        }
        for (0..moons.len) |l| {
            moons[l].update_position();
        }

        var vel0 = true;
        for (0..moons.len) |l| {
            if (moons[l].v.x != 0)
                vel0 = false;
            if (moons[l].v.y != 0)
                vel0 = false;
            if (moons[l].v.z != 0)
                vel0 = false;
        }
        if (vel0) {
            std.debug.print("Vsame {d}\n", .{s});
            for (0..moons.len) |l| {
                moons[l].print();
            }
            rep_step = @as(i64,@intCast(s)) + 1;
            break;
        }
    }

    return rep_step*2;
}
