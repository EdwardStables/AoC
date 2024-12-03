 const std = @import("std");
const aoc = @import("../../aoc_util.zig");
const Allocator = std.mem.Allocator;

const ParseState = enum {
    invalid,
    m,
    u,
    l,
    bopen,
    num1,
    comma,
    num2,
    d,
    o,
    do_bopen,
    n,
    apos,
    t,
    dont_bopen,
};

pub fn task1(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    var state = ParseState.invalid;
    var num1: i64 = 0;
    var numsize: u8 = 0;
    var nums = [_]u8{'0'}**3;
    for (input.items) |line| {
        for (line) |char| {
            switch (state) {
                ParseState.m=> {
                    state = if (char == 'u') ParseState.u else ParseState.invalid;
                    continue;
                },
                ParseState.u=> {
                    state = if (char == 'l') ParseState.l else ParseState.invalid;
                    continue;
                },
                ParseState.l=> {
                    state = if (char == '(') ParseState.bopen else ParseState.invalid;
                    continue;
                },
                ParseState.bopen=> {
                    if (char <= 47 or char > 57 or numsize >= 3) {
                        state = ParseState.invalid;
                        continue;
                    }

                    state = ParseState.num1;
                    nums[numsize] = char;
                    numsize += 1;
                    continue;
                },
                ParseState.num1 => {
                    if (char == ',') {
                        var ind: u8 = 0;
                        while (numsize > 0) : ({numsize -= 1; ind += 1;}) {
                            const factor = std.math.pow(i64, 10, numsize-1);
                            num1 += factor * @as(i64,nums[ind]-48);
                        }
                        state = ParseState.comma;
                        continue;
                    }
                    if (char <= 47 or char > 57 or numsize >= 3) {
                        state = ParseState.invalid;
                        continue;
                    }

                    nums[numsize] = char;
                    numsize += 1;
                    continue;
                },
                ParseState.comma => {
                    if (char <= 47 or char > 57 or numsize >= 3) {
                        state = ParseState.invalid;
                        continue;
                    }

                    state = ParseState.num2;
                    nums[numsize] = char;
                    numsize += 1;
                    continue;
                },
                ParseState.num2 => {
                    if (char == ')') {
                        var num2: i64 = 0;
                        var ind: u8 = 0;
                        while (numsize > 0) : ({numsize -= 1; ind += 1;}) {
                            const factor = std.math.pow(i64, 10, numsize-1);
                            num2 += factor * @as(i64,nums[ind]-48);
                        }
                        const res = num1 * num2;
                        total += res;
                        num1 = 0;
                        state = ParseState.invalid;
                        continue;
                    }
                    if (char <= 47 or char > 57 or numsize >= 3) {
                        state = ParseState.invalid;
                        continue;
                    }

                    nums[numsize] = char;
                    numsize += 1;
                    continue;
                },
                else => {
                    numsize = 0;
                    num1 = 0;
                    state = if (char == 'm') ParseState.m else ParseState.invalid;
                    continue;
                },

            }
        }
    }

    return total;
}

pub fn task2(_: Allocator, input: *std.ArrayList([]const u8)) aoc.TaskErrors!i64 {
    var total: i64 = 0;
    var enable = true;
    var state = ParseState.invalid;
    var num1: i64 = 0;
    var numsize: u8 = 0;
    var nums = [_]u8{'0'}**3;
    for (input.items) |line| {
        for (line) |char| {
            switch (state) {
                ParseState.m=> {
                    state = if (char == 'u') ParseState.u else ParseState.invalid;
                },
                ParseState.u=> {
                    state = if (char == 'l') ParseState.l else ParseState.invalid;
                },
                ParseState.l=> {
                    state = if (char == '(') ParseState.bopen else ParseState.invalid;
                },
                ParseState.bopen=> {
                    if (char <= 47 or char > 57 or numsize >= 3) {
                        state = ParseState.invalid;
                    } else {
                        state = ParseState.num1;
                        nums[numsize] = char;
                        numsize += 1;
                    }
                },
                ParseState.num1 => {
                    if (char == ',') {
                        var ind: u8 = 0;
                        while (numsize > 0) : ({numsize -= 1; ind += 1;}) {
                            const factor = std.math.pow(i64, 10, numsize-1);
                            num1 += factor * @as(i64,nums[ind]-48);
                        }
                        state = ParseState.comma;
                    } else if (char <= 47 or char > 57 or numsize >= 3) {
                        state = ParseState.invalid;
                        continue;
                    } else {
                        nums[numsize] = char;
                        numsize += 1;
                    }
                },
                ParseState.comma => {
                    if (char <= 47 or char > 57 or numsize >= 3) {
                        state = ParseState.invalid;
                    } else {
                        state = ParseState.num2;
                        nums[numsize] = char;
                        numsize += 1;
                    }
                },
                ParseState.num2 => {
                    if (char == ')') {
                        var num2: i64 = 0;
                        var ind: u8 = 0;
                        while (numsize > 0) : ({numsize -= 1; ind += 1;}) {
                            const factor = std.math.pow(i64, 10, numsize-1);
                            num2 += factor * @as(i64,nums[ind]-48);
                        }
                        const res = num1 * num2;
                        if (enable)
                            total += res;
                        num1 = 0;
                        state = ParseState.invalid;
                    }
                    else if (char <= 47 or char > 57 or numsize >= 3) {
                        state = ParseState.invalid;
                    } else {
                        nums[numsize] = char;
                        numsize += 1;
                    }
                },
                ParseState.d => {
                    state = if (char == 'o') ParseState.o else ParseState.invalid;
                },
                ParseState.o => {
                    state = if (char == 'n') ParseState.n else 
                            if (char == '(') ParseState.do_bopen else ParseState.invalid;
                },
                ParseState.do_bopen => {
                    if (char == ')') enable = true;
                    state = ParseState.invalid;
                },
                ParseState.n => {
                    state = if (char == '\'') ParseState.apos else ParseState.invalid;
                },
                ParseState.apos => {
                    state = if (char == 't') ParseState.t else ParseState.invalid;
                },
                ParseState.t => {
                    state = if (char == '(') ParseState.dont_bopen else ParseState.invalid;
                },
                ParseState.dont_bopen => {
                    if (char == ')') enable = false;
                    state = ParseState.invalid;
                },
                ParseState.invalid => {
                    // do nothing, handled after
                },
            }
            
            if (state == ParseState.invalid) {
                //reset
                numsize = 0;
                num1 = 0;
                
                if (char == 'd') {
                    state = ParseState.d;
                } else if (char == 'm') {
                    state = ParseState.m;
                } else {
                    state = ParseState.invalid;
                }
            }
        }
    }
    return total;
}
