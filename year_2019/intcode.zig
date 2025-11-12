const std = @import("std");

const Opcode = enum(u64) {
    ADD = 1,
    MULTIPLY = 2,
    INPUT = 3,
    OUTPUT = 4,
    J_IF_TRUE = 5,
    J_IF_FALSE = 6,
    LESS_THAN = 7,
    EQUALS = 8,
    REL_BASE = 9,
    END = 99,
    _,
};

pub const IntCode = struct {
    mem: std.ArrayList(i64),
    input: std.ArrayList(i64),
    output: std.ArrayList(i64),
    alloc: std.mem.Allocator,

    input_read_index: usize = 0,
    output_read_index: usize = 0,

    ip: u64 = 0,
    relative_base: i64 = 0,

    pub fn init(alloc: std.mem.Allocator, input: []const u8) !IntCode {
        var mem = std.ArrayList(i64).init(alloc);
        try IntCode.createMemMap(&mem, input);
        return .{
            .alloc = alloc,
            .mem = mem,
            .input = std.ArrayList(i64).init(alloc),
            .output = std.ArrayList(i64).init(alloc),
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
            try self.mem.append(try std.fmt.parseInt(i64, token, 10));
        }
        self.input.clearRetainingCapacity();
        self.output.clearRetainingCapacity();
        self.input_read_index = 0;
        self.output_read_index = 0;

        self.ip = 0;
        self.relative_base = 0;
    }

    fn createMemMap(mem: *std.ArrayList(i64), input: []const u8) !void {
        var si = std.mem.splitAny(u8, input, ","); 
        while (si.next()) |token| {
            try mem.append(try std.fmt.parseInt(i64, token, 10));
        }
    }

    pub fn setMem(self: *IntCode, pos: usize, val: i64) void {
        if (pos < self.mem.items.len) self.mem.items[pos] = val;
    }

    pub fn getMem(self: *IntCode, pos: usize) ?i64 {
        return if (pos < self.mem.items.len) self.mem.items[pos]
        else null;
    }

    fn getOpcode(self: *IntCode, ip: u64) Opcode {
        return @enumFromInt(@rem(self.mem.items[ip], 100));
    }

    fn getOperand(self: *IntCode, ip: u64, pos: u64) !i64 {
        const read_addr = try self.getOutputAddr(ip, pos);
        return try self.memRead(read_addr);
    }

    fn getOutputAddr(self: *IntCode, ip: u64, pos: u64) !u64 {
        const address_type = ((@as(u64, @intCast(self.mem.items[ip])) / (100 * std.math.pow(u64, 10, pos))) % 10);
        return switch(address_type) {
            0 => @intCast(try self.memRead(ip + 1 + pos)), //position
            2 => @intCast(try self.memRead(ip + 1 + pos) + self.relative_base), //relative
            1 => ip + 1 + pos, //immediate
            else => unreachable
        };
    }

    pub fn pushInput(self: *IntCode, in: i64) !void {
        try self.input.append(in);
    }

    fn getInput(self: *IntCode) i64 {
        defer self.input_read_index+=1;
        return self.input.items[self.input_read_index];
    }

    fn pushOutput(self: *IntCode, in: i64) !void {
        try self.output.append(in);
    }

    pub fn getOutput(self: *IntCode) ?i64 {
        if (self.output_read_index < self.output.items.len) {
            defer self.output_read_index+=1;
            return self.output.items[self.output_read_index];
        }
        else {
            return null;
        }
    }

    fn memExpand(self: *IntCode, addr: u64) !void { // double size until the output fits 
        while (addr > self.mem.items.len) {
            try self.mem.appendNTimes(0, self.mem.items.len);
        }
    }

    fn memWrite(self: *IntCode, addr: u64, value: i64) !void {
        try self.memExpand(addr);
        self.mem.items[addr] = value;
    }

    fn memRead(self: *IntCode, addr: u64) !i64 {
        try self.memExpand(addr);
        return self.mem.items[addr];
    }

    fn loop(self: *IntCode, debug: bool) ?bool {
        const ip = self.ip;
        const opcode: Opcode = self.getOpcode(ip);
        if (debug) {
            std.debug.print("IP: {d} ", .{ip});
            std.debug.print("{d} ", .{self.mem.items[ip]});
            std.debug.print("Opcode: {s} ", .{@tagName(opcode)});
            std.debug.print("Relbase: {d} ", .{self.relative_base});
        }

        if (opcode == .END) return true;

        const out: u64 = @intCast(switch(opcode) {
            .ADD =>       self.getOutputAddr(ip, 2),
            .MULTIPLY =>  self.getOutputAddr(ip, 2),
            .INPUT =>     self.getOutputAddr(ip, 0),
            .LESS_THAN => self.getOutputAddr(ip, 2),
            .EQUALS =>    self.getOutputAddr(ip, 2),
            else => 0
        } catch {
            std.debug.print("IP: {d} - Mem read failed \n", .{ip});
            return false;
        });

        const op0 = self.getOperand(ip, 0) catch return false;
        const op1 = self.getOperand(ip, 1) catch return false;

        if (debug) {
            std.debug.print("op1: {d} op2: {d} out: {d}", .{op0, op1, out});
        }

        var jumped = false;
        switch(opcode) {
            .ADD =>      self.memWrite(out, op0 + op1) catch return false,
            .MULTIPLY => self.memWrite(out, op0 * op1) catch return false,
            .INPUT =>    self.memWrite(out, self.getInput()) catch return false,
            .OUTPUT =>   self.pushOutput(op0) catch {
                std.debug.print("IP: {d} - Sending OUTPUT failed \n", .{ip});
                return false;
            },
            .J_IF_TRUE => if (op0 != 0) {self.ip = @intCast(op1); jumped=true;},
            .J_IF_FALSE => if (op0 == 0) {self.ip = @intCast(op1); jumped=true;},
            .LESS_THAN => self.memWrite(out, if (op0 < op1) 1 else 0) catch return false,
            .EQUALS => self.memWrite(out, if (op0 == op1) 1 else 0) catch return false,
            .REL_BASE => self.relative_base += @intCast(op0),
            .END => {//Captured earlier
                std.debug.print("IP: {d} - Seen END in opcode switch\n", .{ip});
                return false;
            },
            else => {
                std.debug.print("IP: {d} - Invalid Opcode {d}\n", .{ip, self.mem.items[ip]});
                return false;
            }
        }

        if (debug) std.debug.print("\n", .{});

        self.ip += switch(opcode) {
            .ADD => 4,
            .MULTIPLY => 4,
            .INPUT => 2,
            .OUTPUT => 2,
            .J_IF_TRUE => if (jumped) 0 else 3,
            .J_IF_FALSE => if (jumped) 0 else 3,
            .LESS_THAN => 4,
            .EQUALS => 4,
            .REL_BASE => 2,
            .END => 1, 
            else => {
                std.debug.print("IP: {d} - Invalid Opcode {d}\n", .{ip, self.mem.items[ip]});
                return false;
            }
        };

        return null;
    }

    pub fn executeUntilOutput(self: *IntCode, debug: bool) ?i64 {
        while (true) {
            const res = self.loop(debug);
            if (res != null) break;

            const out = self.getOutput();
            if (out != null) {
                return out.?;
            }
        }

        return null;
    }

    pub fn execute(self: *IntCode, debug: bool) bool {
        while (true) {
            const res = self.loop(debug);
            if (res == null) continue;
            return res.?;
        }
        unreachable;
    }
};
