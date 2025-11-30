const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

fn gcd(_a: u32, _b: u32) u32 {
    var d: u5 = 0;
    var a = _a;
    var b = _b;
    while (a & 1 == 0 and b & 1 == 0) {
        a >>= 1;
        b >>= 1;
        d += 1;
    }

    while (a & 1 == 0) {
        a >>= 1;
    }

    while (b & 1 == 0) {
        b >>= 1;
    }

    while (a != b) {
        if (a > b) {
            a = a - b;
            while (a & 1 == 0) {
                a >>= 1;
            }
        }
        if (b > a) {
            b = b - a;
            while (b & 1 == 0) {
                b >>= 1;
            }
        }
    }

    return (@as(u32,1) << d) * a;
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const w = input.items[0].len;
    const h = input.items.len;

    var max: ?i64 = 0;

    var seen = try alloc.alloc(bool, w*h);
    defer alloc.free(seen);

    for (0..h) |y1| {
        for (0..w) |x1| {
            if (input.items[y1][x1] == '#') {
                var count: i64 = 0;
                for (0..w*h) |i| {
                    seen[i] = false;
                }
                for (0..h) |y2| {
                    for (0..w) |x2| {
                        if (x1 == x2 and y1 == y2) continue;
                        if (input.items[y2][x2] == '#') {
                            var xd: i16 = @as(i16, @intCast(x2))-@as(i16, @intCast(x1));
                            var yd: i16 = @as(i16, @intCast(y2))-@as(i16, @intCast(y1));
                            const f: u32 = if (xd != 0 and yd != 0) gcd(@abs(xd), @abs(yd)) else @max(@abs(xd), @abs(yd));
                            xd = @divExact(xd, @as(i16,@intCast(f)));
                            yd = @divExact(yd, @as(i16,@intCast(f)));

                            const i = aoc.Vec2Init(i16, @intCast(x1), @intCast(y1)).addVec(aoc.Vec2Init(i16, xd, yd)).toIndex(w);
                            if (!seen[i]) {
                                count += 1;
                                seen[i] = true;
                            }
                        }
                    }
                }

                if (max == null or count > max.?)
                    max = count;
            }
        }
    }
    return max.?;
}

const AngleStore = struct {a:f32, p:aoc.Vec2(i16), valid: bool, p_gcd:aoc.Vec2(i16)};
fn AngleStoreCompAngle(_: aoc.Vec2(i32), L: AngleStore, R: AngleStore) bool {
    if (L.a < R.a) return true;
    if (L.a == R.a) {
        const ldist2 = L.p.as(i32).mag2();
        const rdist2 = R.p.as(i32).mag2();
        return ldist2 < rdist2;
    }
    return false;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const w = input.items[0].len;
    const h = input.items.len;

    var max: ?i64 = 0;
    var laser = aoc.Vec2Init(usize, 0, 0);

    var seen = try alloc.alloc(bool, w*h);
    defer alloc.free(seen);

    for (0..h) |y1| {
        for (0..w) |x1| {
            if (input.items[y1][x1] == '#') {
                var count: i64 = 0;
                for (0..w*h) |i| {
                    seen[i] = false;
                }
                for (0..h) |y2| {
                    for (0..w) |x2| {
                        if (x1 == x2 and y1 == y2) continue;
                        if (input.items[y2][x2] == '#') {
                            var xd: i16 = @as(i16, @intCast(x2))-@as(i16, @intCast(x1));
                            var yd: i16 = @as(i16, @intCast(y2))-@as(i16, @intCast(y1));
                            const f: u32 = if (xd != 0 and yd != 0) gcd(@abs(xd), @abs(yd)) else @max(@abs(xd), @abs(yd));
                            xd = @divExact(xd, @as(i16,@intCast(f)));
                            yd = @divExact(yd, @as(i16,@intCast(f)));

                            const i = aoc.Vec2Init(i16, @intCast(x1), @intCast(y1)).addVec(aoc.Vec2Init(i16, xd, yd)).toIndex(w);
                            if (!seen[i]) {
                                count += 1;
                                seen[i] = true;
                            }
                        }
                    }
                }

                if (max == null or count > max.?) {
                    laser.x = x1;
                    laser.y = y1;
                    max = count;
                }
            }
        }
    }

    var angles = try alloc.alloc(AngleStore, w*h);
    defer alloc.free(angles);

    for (0..h) |y| {
        for (0..w) |x| {
            const i = aoc.Vec2Init(i16, @intCast(x), @intCast(y)).toIndex(w);
            if  (x == laser.x and y == laser.y or input.items[y][x] != '#') {
                angles[i].valid = false;
                angles[i].a = 0.0;
            } else {
                angles[i].valid = true;

                angles[i].p.x = @as(i16, @intCast(x))-@as(i16, @intCast(laser.x));
                angles[i].p.y = @as(i16, @intCast(y))-@as(i16, @intCast(laser.y));

                var xd = angles[i].p.x;
                var yd = angles[i].p.y;

                const f: u32 = if (xd != 0 and yd != 0) gcd(@abs(xd), @abs(yd)) else @max(@abs(xd), @abs(yd));
                xd = @divExact(xd, @as(i16,@intCast(f)));
                yd = @divExact(yd, @as(i16,@intCast(f)));
                angles[i].p_gcd.x = xd;
                angles[i].p_gcd.y = yd;
                const xdf: f32 = @floatFromInt(xd);
                const ydf: f32 = @floatFromInt(yd);
                if (xdf >= 0 and ydf < 0) {
                    angles[i].a = std.math.atan(xdf/-ydf);
                } else
                if (xdf > 0 and ydf >= 0) {
                    angles[i].a = std.math.atan(ydf/xdf) + std.math.pi/2.0;
                } else
                if (xdf <= 0 and ydf < 0) {
                    angles[i].a = std.math.atan(ydf/xdf) + (1.5*std.math.pi);
                } else {
                //if (xdf < 0 and ydf >= 0) {
                    angles[i].a = std.math.atan(ydf/-xdf) + std.math.pi;
                }
            }
        }
    }

    std.mem.sort(AngleStore, angles, laser.as(i32), AngleStoreCompAngle);

    var count: i64 = 0;
    var last_point: ?aoc.Vec2(i16) = null;

    for (0..w*h) |i| {
        if (!angles[i].valid) continue;
        if (last_point != null and last_point.?.eq(angles[i].p_gcd)) continue;
        angles[i].valid = false;
        last_point = angles[i].p_gcd;
        count += 1;
        if (count == 200) break;
    }
    last_point.?.x += @intCast(laser.x);
    last_point.?.y += @intCast(laser.y);
    return @intCast((100 * last_point.?.x) + last_point.?.y);
}
