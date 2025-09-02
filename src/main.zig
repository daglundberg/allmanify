const std = @import("std");

var gpa = std.heap.page_allocator;

var out_stream = std.io.getStdOut().writer();

pub fn main() !void {
    if (std.io.getStdIn().isTty()) {
        std.debug.print("No input...", .{});
        return;
    }

    const in_stream = std.io.getStdIn().reader();

    var buf_reader = std.io.bufferedReader(in_stream);
    var r = buf_reader.reader();
    while (true) {
        //Read line
        const raw_line = try r.readUntilDelimiterOrEofAlloc(gpa, '\n', 1024);
        defer if (raw_line) |l| gpa.free(l);
        if (raw_line == null) break;
        const line = raw_line.?;

        //calculate indentation
        var indent_len: usize = 0;
        while (indent_len < line.len and (line[indent_len] == ' ' or line[indent_len] == '\t')) {
            if (line[indent_len] == '\t')
                indent_len += 4;

            if (line[indent_len] == ' ')
                indent_len += 1;
        }

        try writeIndentation(indent_len);

        var trimmed = std.mem.trim(u8, line, " \t");

        if (trimmed.len <= 0) {
            try out_stream.writeAll("\n");
            continue;
        }

        if (trimmed[trimmed.len - 1] == '{') {
            if (std.mem.eql(u8, trimmed[trimmed.len - 2 ..], ".{")) {
                // write line without '{' and trim any whitespace between it and the code before it
                const trimmed_again = std.mem.trimRight(u8, trimmed[0 .. trimmed.len - 2], " \t");
                try out_stream.writeAll(trimmed_again);
                try out_stream.writeAll("\n");
                try writeIndentation(indent_len);
                try out_stream.writeAll(".{\n");
            } else if (std.mem.eql(u8, trimmed[trimmed.len - 6 ..], "else {")) {
                // write line without '{' and trim any whitespace between it and the code before it
                const trimmed_again = std.mem.trimRight(u8, trimmed[0 .. trimmed.len - 6], " \t");
                try out_stream.writeAll(trimmed_again);
                try out_stream.writeAll("\n");
                try writeIndentation(indent_len);
                try out_stream.writeAll("else\n");
                try writeIndentation(indent_len);
                try out_stream.writeAll("{\n");
            } else {
                // check if line starts with else if then we need to do special case
                if (trimmed.len > 9) {
                    if (std.mem.eql(u8, trimmed[0..9], "} else if")) {
                        try out_stream.writeAll("\n");
                        try writeIndentation(indent_len);
                        try out_stream.writeAll("}\n");
                        try writeIndentation(indent_len);
                        try out_stream.writeAll(trimmed[2..9]);
                        trimmed = trimmed[9..];
                    }
                }

                // write line without '{' and trim any whitespace between it and the code before it
                const trimmed_again = std.mem.trimRight(u8, trimmed[0 .. trimmed.len - 1], " \t");

                try out_stream.writeAll(trimmed_again);
                try out_stream.writeAll("\n");
                try writeIndentation(indent_len);
                try out_stream.writeAll("{\n");
            }
        } else {
            try out_stream.writeAll(trimmed);
            try out_stream.writeAll("\n");
        }
    }
}

fn writeIndentation(indentation: usize) !void {
    if (indentation % 4 == 0) {
        try out_stream.writeByteNTimes('\t', indentation / 4);
    } else {
        try out_stream.writeByteNTimes(' ', indentation);
    }
}
