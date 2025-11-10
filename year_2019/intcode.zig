const std = @import("std");

const Opcode = enum(u32) {
    ADD = 1,
    MULTIPLY = 2,
    INPUT = 3,
    OUTPUT = 4,
    J_IF_TRUE = 5,
    J_IF_FALSE = 6,
    LESS_THAN = 7,
    EQUALS = 8,
    END = 99,
    _,
};

pub const IntCode = struct {
    mem: std.ArrayList(i32),
    input: std.ArrayList(i32),
    output: std.ArrayList(i32),
    alloc: std.mem.Allocator,

    input_read_index: usize = 0,
    output_read_index: usize = 0,

    pub fn init(alloc: std.mem.Allocator, input: []const u8) !IntCode {
        var mem = std.ArrayList(i32).init(alloc);
        try IntCode.createMemMap(&mem, input);
        return .{
            .alloc = alloc,
            .mem = mem,
            .input = std.ArrayList(i32).init(alloc),
            .output = std.ArrayList(i32).init(alloc),
        };
    }

    pub fn deinit(self: *IntCode) void {
        self.mem.deinit();
        self.input.deinit();
        self.output.deinit();
    }

    pub fn resetMemMap(self: *IntCode, input: []const u8) !void {
        self.mem.clearRetainingCapacity();
        var si = std.mem.splitAny(u8, input, ","); 
        while (si.next()) |token| {
            try self.mem.append(try std.fmt.parseInt(i32, token, 10));
        }
    }

    fn createMemMap(mem: *std.ArrayList(i32), input: []const u8) !void {
        var si = std.mem.splitAny(u8, input, ","); 
        while (si.next()) |token| {
            try mem.append(try std.fmt.parseInt(i32, token, 10));
        }
    }

    pub fn setMem(self: *IntCode, pos: usize, val: i32) void {
        if (pos < self.mem.items.len) self.mem.items[pos] = val;
    }

    pub fn getMem(self: *IntCode, pos: usize) ?i32 {
        return if (pos < self.mem.items.len) self.mem.items[pos]
        else null;
    }

    fn getOpcode(self: *IntCode, ip: u32) Opcode {
        return @enumFromInt(@rem(self.mem.items[ip], 100));
    }

    fn getOperand(self: *IntCode, ip: u32, pos: u32) i32 {
        if (((@as(u32, @intCast(self.mem.items[ip])) / (100 * std.math.pow(u32, 10, pos))) % 10) == 1) { // immediate
            return self.mem.items[ip + 1 + pos];
        } else { //position
            return self.mem.items[@as(u32, @intCast(self.mem.items[ip + 1 + pos]))];
        }
    }

    pub fn pushInput(self: *IntCode, in: i32) !void {
        try self.input.append(in);
    }

    fn getInput(self: *IntCode) i32 {
        defer self.input_read_index+=1;
        return self.input.items[self.input_read_index];
    }

    fn pushOutput(self: *IntCode, in: i32) !void {
        try self.output.append(in);
    }

    pub fn getOutput(self: *IntCode) ?i32 {
        defer self.output_read_index+=1;
        return if (self.output_read_index < self.output.items.len) self.output.items[self.output_read_index] else null;
    }

    pub fn execute(self: *IntCode, debug: bool) bool {
        var ip: u32 = 0;
        var m = self.mem.items;
        while (true) {
            const opcode: Opcode = self.getOpcode(ip);

            if (opcode == .END) break;

            const out: u32 = @intCast(switch(opcode) {
                .ADD => m[ip + 3],
                .MULTIPLY => m[ip + 3],
                .INPUT => m[ip + 1],
                .LESS_THAN => m[ip + 3],
                .EQUALS => m[ip + 3],
                else => 0
            });

            var jumped = false;
            switch(opcode) {
                .ADD => m[out] = self.getOperand(ip,0) + self.getOperand(ip,1),
                .MULTIPLY => m[out] = self.getOperand(ip,0) * self.getOperand(ip,1),
                .INPUT => m[out] = self.getInput(),
                .OUTPUT => self.pushOutput(self.getOperand(ip,0)) catch {
                    std.debug.print("IP: {d} - Sending OUTPUT failed \n", .{ip});
                    return false;
                },
                .J_IF_TRUE => if (self.getOperand(ip,0) != 0) {ip = @intCast(self.getOperand(ip, 1)); jumped=true;},
                .J_IF_FALSE => if (self.getOperand(ip,0) == 0) {ip = @intCast(self.getOperand(ip, 1)); jumped=true;},
                .LESS_THAN => m[out] = if (self.getOperand(ip,0) < self.getOperand(ip,1)) 1 else 0,
                .EQUALS => m[out] = if (self.getOperand(ip,0) == self.getOperand(ip,1)) 1 else 0,
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
                std.debug.print("IP: {d} - {s} {d} {d} -> {d} ({d})\n", .{ip, @tagName(opcode), self.getOperand(ip,0), self.getOperand(ip,1), out, m[out]});

            ip += switch(opcode) {
                .ADD => 4,
                .MULTIPLY => 4,
                .INPUT => 2,
                .OUTPUT => 2,
                .J_IF_TRUE => if (jumped) 0 else 3,
                .J_IF_FALSE => if (jumped) 0 else 3,
                .LESS_THAN => 4,
                .EQUALS => 4,
                .END => 1, 
                else => {
                    std.debug.print("IP: {d} - Invalid Opcode {d}\n", .{ip, m[ip]});
                    return false;
                }
            };
        }

        return true;
    }
};
