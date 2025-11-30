const std = @import("std");

const Allocator = std.mem.Allocator;

pub const TaskErrors = error {
    //Allocators
    OutOfMemory,
    //IO Errors
    DiskQuota,
    FileTooBig,
    InputOutput,
    NoSpaceLeft,
    DeviceBusy,
    InvalidArgument,
    AccessDenied,
    BrokenPipe,
    SystemResources,
    OperationAborted,
    NotOpenForWriting,
    LockViolation,
    WouldBlock,
    ConnectionResetByPeer,
    ProcessNotFound,
    Unexpected,
    //Fmt errors
    Overflow,
    InvalidCharacter,
    //Threading errors,
    LockedMemoryLimitExceeded,
    ThreadQuotaExceeded,
    //Priority Queue
    ElementNotFound,
};

//Ordering matters
pub fn offsets(comptime T: type) [4]Vec2(T) {
    return .{
        Vec2Init(T, 1, 0),
        Vec2Init(T, 0, 1),
        Vec2Init(T, -1, 0),
        Vec2Init(T, 0, -1),
    };
}

pub fn up(comptime T: type) Vec2(T) { return Vec2Init(T,  0, -1); }
pub fn dn(comptime T: type) Vec2(T) { return Vec2Init(T,  0,  1); }
pub fn lt(comptime T: type) Vec2(T) { return Vec2Init(T, -1,  0); }
pub fn rt(comptime T: type) Vec2(T) { return Vec2Init(T,  1,  0); }

pub fn Vec2(comptime T: type) type {
    return struct {
        const Self = @This();
        x: T,
        y: T,

        pub fn toIndex(self: Self, width: usize) usize {
            return @as(usize,@intCast(self.y))*width + @as(usize,@intCast(self.x));
        }

        pub fn inBounds(self: Self, tl: Self, br: Self) bool {
            return self.x >= tl.x and self.y >= tl.y and self.x < br.x and self.y < br.y;
        }

        pub fn eq(self: Self, other: Self) bool {
            return self.x == other.x and self.y == other.y;
        }
        pub fn addVec(self: Self, other: Self) Self {
            return .{.x=self.x + other.x, .y=self.y + other.y};
        }
        pub fn subVec(self: Self, other: Self) Self {
            return .{.x=self.x - other.x, .y=self.y - other.y};
        }
        pub fn addX(self: Self, x: T) void {
            self.x = self.x + x;
        }

        pub fn addY(self: Self, y: T) void {
            self.y = self.y + y;
        }

        pub fn addXY(self: Self, x: T, y: T) void {
            self.x = self.x + x;
            self.y = self.y + y;
        }

        pub fn scale(self: Self, s: T) Vec2(T) {
            return .{.x = s*self.x, .y = s*self.y};
        }

        //TODO only works for ints
        pub fn as(self: Self, T2: type) Vec2(T2) {
            return .{.x = @as(T2,@intCast(self.x)), .y = @as(T2,@intCast(self.y))};
        }

        pub fn rotate_left(self: Self) Vec2(T) {
            return .{.x=-self.y,.y=self.x};
        }

        pub fn rotate_right(self: Self) Vec2(T) {
            return .{.x=self.y,.y=-self.x};
        }

        pub fn manhatten(self: Self, other: Self) usize {
            const xdist = if (self.x > other.x) self.x - other.x else other.x - self.x;
            const ydist = if (self.y > other.y) self.y - other.y else other.y - self.y;
            const result = xdist + ydist;
            return result;
        }

        pub fn mag2(self: Self) T {
            return self.x*self.x + self.y*self.y;
        }
    };
}

pub fn Vec2Init(comptime T: type, x: T, y: T) Vec2(T) {
    return Vec2(T){.x = x, .y = y};
}

pub fn Vec2Zero(comptime T: type) Vec2(T) {
    return Vec2(T){.x = @intCast(0), .y = @intCast(0)};
}

pub fn Vec2FromIndex(comptime T: type, index: usize, width: usize) Vec2(T) {
    return Vec2(T){.x=index%width, .y=index/width};
}


const DijkstraOutput = struct {
    dist: []u32,
    prev: []u32
};

fn dijkstra_compare(dist: []u32, a: u32, b: u32) std.math.Order {
    return if (dist[a] <= dist[b]) std.math.Order.lt else std.math.Order.gt;
}

pub fn dijkstra(alloc: Allocator, start: usize, size: usize, adjacency: []?u32) !DijkstraOutput {
    var dist = try alloc.alloc(u32, size);
    var prev = try alloc.alloc(u32, size);

    for (0..size) |i| dist[i] = std.math.maxInt(u32);
    dist[start] = 0;
    for (0..size) |i| prev[i] = std.math.maxInt(u32);

    var pq = std.PriorityQueue(u32, []u32, dijkstra_compare).init(alloc, dist);
    defer pq.deinit();

    try pq.add(@intCast(start));

    for (0..size) |i| {
        try pq.add(@intCast(i));
    }

    while (pq.count() > 0) {
        const min = pq.remove();
        if (dist[min] == std.math.maxInt(u32)) break; //unreachable
        const neighbours = adjacency[size*min..size*(min+1)];
        for (neighbours, 0..) |n, ni| {
            if (n==null) continue;
            const neighbour_dist = dist[min] + n.?;
            if (neighbour_dist < dist[ni]) {
                dist[ni] = neighbour_dist;
                prev[ni] = min;

                var iter = pq.iterator();
                var ii: usize = 0;
                while (iter.next()) |it| : (ii+=1) {
                    if (it != ni) continue;
                    _ = pq.removeIndex(ii);
                    try pq.add(@intCast(ni));
                    break;
                }
            }
        }
    }

    return .{.dist=dist, .prev=prev};
}