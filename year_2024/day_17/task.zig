const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const Instruction = enum(u8) {
    adv, //divide A by 2^combo -> A
    bxl, //xor B, literal -> B
    bst, //combo % 8 -> B
    jnz, //if A!=0 then IP<-literal and no IP inc
    bxc, //xor B and C -> B
    out, //combo % 8 -> output
    bdv, //divide A by 2^combo -> B
    cdv, //divide A by 2^combo -> C
};

const Line = struct {
    instr: Instruction,
    operand: u8,
};

fn execute(Ain: u64, Bin: u64, Cin: u64, program: []Line, output: *std.ArrayList(u8)) !void {
    var IP: u64 = 0;
    var A = Ain;
    var B = Bin;
    var C = Cin;
    while (IP < program.len) {
        const line = program[IP];

        const instr = line.instr;
        const literal = line.operand;
        const combo: u64 = switch(line.operand) {
            4 => A,
            5 => B,
            6 => C,
            else => @as(u64,@intCast(line.operand)), //only 0-3 expected
        };


        var inc: u64 = 1;
        switch (instr) {
            Instruction.adv => A = A / std.math.pow(u64, 2, combo),
            Instruction.bxl => B = B ^ literal,
            Instruction.bst => B = combo % 8,
            Instruction.jnz => {
                if (A != 0) {
                    IP = literal;
                    inc = 0;
                }
            },
            Instruction.bxc => B = B ^ C,
            Instruction.out => try output.append(@intCast(combo%8)),
            Instruction.bdv => B = A / std.math.pow(u64, 2, combo),
            Instruction.cdv => C = A / std.math.pow(u64, 2, combo),
        }
        IP += inc;
    }
}

pub fn task1(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    const A: u64 = try std.fmt.parseInt(u64, input.items[0][12..], 10);
    const B: u64 = try std.fmt.parseInt(u64, input.items[1][12..], 10);
    const C: u64 = try std.fmt.parseInt(u64, input.items[2][12..], 10);

    const program_length = (input.items[4].len-8)/4;
    var program = try alloc.alloc(Line, program_length);
    defer alloc.free(program);

    const offset = 9;
    var index: u64 = 0;
    while (index < program_length) {
        const instruction_number = input.items[4][offset+4*index] - 48;
        const operand: u8 = input.items[4][offset+4*index+2] - 48;

        program[index].instr = @enumFromInt(instruction_number);
        program[index].operand = operand;

        index += 1;
    }

    var output = std.ArrayList(u8).init(alloc);
    defer output.deinit();

    try execute(A, B, C, program, &output);

    if (output.items.len == 0) return 0;

    std.debug.print("P1 solution: {d}", .{output.items[0]});
    for (output.items[1..]) |u| std.debug.print(",{d}", .{u});
    std.debug.print("\n", .{});
    
    return 0;
}

pub fn task2(alloc: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {

    const program_length = (input.items[4].len-8)/4;
    var required_output = try alloc.alloc(u8, program_length*2);
    defer alloc.free(required_output);
    var program = try alloc.alloc(Line, program_length);
    defer alloc.free(program);

    const offset = 9;
    var index: u64 = 0;
    while (index < program_length) {
        const instruction_number = input.items[4][offset+4*index] - 48;
        const operand: u8 = input.items[4][offset+4*index+2] - 48;

        program[index].instr = @enumFromInt(instruction_number);
        program[index].operand = operand;
        required_output[2*index] = instruction_number;
        required_output[2*index+1] = operand;

        index += 1;
    }

    var output = std.ArrayList(u8).init(alloc);
    defer output.deinit();

    const result = try findSolution(program, 0, 1, &output, required_output) orelse unreachable;

    return @intCast(result);
}

fn findSolution(program: []Line, base_val: u64, output_size: usize, output: *std.ArrayList(u8), required_output: []u8) !?u64 {
    inner: for (0..8) |trial_offset| {
        output.clearRetainingCapacity();
        const trial_A = (base_val * 8) + trial_offset;
        try execute(trial_A, 0, 0, program, output);

        for (output.items, 0..) |item,i| {
            if (item != required_output[required_output.len-output.items.len+i]) {
                continue :inner;
            }
        }

        if (output_size == required_output.len)
            return trial_A;
        
        const next_res = try findSolution(program, trial_A, output_size+1, output, required_output);
        if (next_res != null) return next_res;
    }
    return null;
}