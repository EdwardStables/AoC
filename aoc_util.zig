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
};
