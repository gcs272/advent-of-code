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

pub fn readLines() ![]u8 {
    var ainst = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = &ainst.allocator;
    return std.io.getStdIn().readToEndAlloc(alloc, 1024 * 1024);
}

fn partOne(input: []u8) !i32 {
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

    return abs(posx) + abs(posy);
}

fn partTwo(input: []u8) !i32 {
    var wayx: i32 = 10;
    var wayy: i32 = 1;
    var shipx: i32 = 0;
    var shipy: i32 = 0;

    var lines = std.mem.tokenize(input, "\n");
    while (lines.next()) |line| {
        var inst = line[0];
        var val = try std.fmt.parseInt(i32, line[1..], 10);

        if (inst == 'R' or inst == 'L') {
            if (inst == 'L') {
                val = 360 - val;
            }

            var t = wayx;
            if (val == 90) {
                wayx = wayy;
                wayy = -t;
            } else if (val == 180) {
                wayx = -wayx;
                wayy = -wayy;
            } else if (val == 270) {
                wayx = -wayy;
                wayy = t;
            }
        }

        wayx += switch (inst) {
            'E' => val,
            'W' => -val,
            else => 0,
        };

        wayy += switch (inst) {
            'N' => val,
            'S' => -val,
            else => 0,
        };

        if (inst == 'F') {
            shipx += wayx * val;
            shipy += wayy * val;
        }

        //std.debug.print("{}\t{d},{d}\t{d},{d}\n", .{ line, shipx, shipy, wayx, wayy });
    }

    return abs(shipx) + abs(shipy);
}

pub fn main() !void {
    var lines = try readLines();

    const a1 = try partOne(lines);
    std.debug.print("part one: {d}\n", .{a1});

    const a2 = try partTwo(lines);
    std.debug.print("part two: {d}\n", .{a2});
}
