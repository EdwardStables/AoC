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
};


pub fn Vec2(comptime T: type) type {
    return struct {
        const Self= @This();
        x: T,
        y: T,

        pub fn toIndex(self: Self, width: usize) usize {
            return @as(usize,@intCast(self.y))*width + @as(usize,@intCast(self.x));
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
    };
}

pub fn Vec2Init(comptime T: type, x: T, y: T) Vec2(T) {
    return Vec2(T){.x = x, .y = y};
}

