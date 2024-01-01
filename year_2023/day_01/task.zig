const std = @import("std");

pub fn task_a(data: [][]u8, len: u16) u64 {
    var total: u32 = 0;
    var i: u16 = 0;
    while (i < len) : (i += 1) {
        var on_first = true;
        var local: u32 = 0;
        for (data[i]) |c| {
            if (c < 48 or c > 57) continue;
            if (on_first) {
                local = (c - 48);
                total += 10 * local;
                on_first = false;
            } else {
                local = (c - 48);
            }
        }
        total += local;
    }
    return total;
}

pub fn task_b(data: [][]u8, len: u16) u64 {
    _ = data;
    _ = len;
    return 2;
}
