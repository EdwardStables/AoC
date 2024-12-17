const std = @import("std");

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
            return .{.x=self.x + other.x, .y=self.y+other.y};
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
    };
}

pub fn Vec2Init(comptime T: type, x: T, y: T) Vec2(T) {
    return Vec2(T){.x = x, .y = y};
}

pub fn Vec2Zero(comptime T: type) Vec2(T) {
    return Vec2(T){.x = @intCast(0), .y = @intCast(0)};
}

