const std = @import("std");

fn abs(n: i32) i32 {
    if (n < 0) {
        return n * -1;
    }
    return n;
}

fn clamp(heading: i32) i32 {
    if (heading > 360) {
        return heading - 360;
    } else if (heading < 0) {
        return heading + 360;
    }

    return heading;
}

pub fn main() !void {
    var ainst = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = &ainst.allocator;
    const input = try std.io.getStdIn().readToEndAlloc(alloc, 1024 * 1024);

    var heading: i32 = 0;
    var posx: i32 = 0;
    var posy: i32 = 0;

    var lines = std.mem.tokenize(input, "\n");
    while (lines.next()) |line| {
        var inst = line[0];
        const val = try std.fmt.parseInt(i32, line[1..], 10);

        // Convert the forward step to a standard heading
        if (inst == 'F') {
            inst = switch (heading) {
                0, 360 => 'E',
                90 => 'S',
                180 => 'W',
                270 => 'N',
                else => 'E',
            };
        }

        posx += switch (inst) {
            'E' => val,
            'W' => -val,
            else => 0,
        };

        posy += switch (inst) {
            'N' => val,
            'S' => -val,
            else => 0,
        };

        heading = switch (inst) {
            'L' => clamp(heading - val),
            'R' => clamp(heading + val),
            else => heading,
        };

        //std.debug.print("{}\t{d},{d}\t{d}\n", .{ line, posx, posy, heading });
    }
    std.debug.print("part one: {}\n", .{abs(posx) + abs(posy)});
}
