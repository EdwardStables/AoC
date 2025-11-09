const std = @import("std");

const Opcode = enum(u32) {
    ADD = 1,
    MULTIPLY = 2,
    END = 99,
    _,
};

pub const IntCode = struct {
    mem: std.ArrayList(u32),
    alloc: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator, input: []const u8) !IntCode {
        var mem = std.ArrayList(u32).init(alloc);
        try IntCode.createMemMap(&mem, input);
        return .{
            .alloc = alloc,
            .mem = mem
        };
    }

    pub fn deinit(self: *IntCode) void {
        self.mem.deinit();
    }

    pub fn resetMemMap(self: *IntCode, input: []const u8) !void {
        self.mem.clearRetainingCapacity();
        var si = std.mem.splitAny(u8, input, ","); 
        while (si.next()) |token| {
            try self.mem.append(try std.fmt.parseInt(u32, token, 10));
        }

    }

    fn createMemMap(mem: *std.ArrayList(u32), input: []const u8) !void {
        var si = std.mem.splitAny(u8, input, ","); 
        while (si.next()) |token| {
            try mem.append(try std.fmt.parseInt(u32, token, 10));
        }
    }

    pub fn setMem(self: *IntCode, pos: usize, val: u32) void {
        if (pos < self.mem.items.len) self.mem.items[pos] = val;
    }

    pub fn getMem(self: *IntCode, pos: usize) ?u32 {
        return if (pos < self.mem.items.len) self.mem.items[pos]
        else null;
    }

    pub fn execute(self: *IntCode, debug: bool) bool {
        var ip: u32 = 0;
        var m = self.mem.items;
        while (true) {
            const opcode: Opcode = @enumFromInt(m[ip]);

            if (opcode == .END) break;

            const in1 = m[m[ip + 1]];
            const in2 = m[m[ip + 2]];
            const out = m[ip + 3];

            switch(opcode) {
                .ADD => m[out] = in1 + in2,
                .MULTIPLY => m[out] = in1 * in2,
                .END => {//Captured earlier
                    std.debug.print("IP: {d} - Seen END in opcode switch\n", .{ip});
                    return false;
                },
                else => {
                    std.debug.print("IP: {d} - Invalid Opcode {d}\n", .{ip, m[ip]});
                    return false;
                }
            }

            if (debug)
                std.debug.print("IP: {d} - {s} {d} {d} -> {d} ({d})\n", .{ip, @tagName(opcode), in1, in2, out, m[out]});

            ip += switch(opcode) {
                .ADD => 4,
                .MULTIPLY => 4,
                .END => 1, 
                else => 0
            };
        }

        return true;
    }
};
