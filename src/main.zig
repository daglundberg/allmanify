const std = @import("std");

var gpa = std.heap.page_allocator;

var out_stream = std.io.getStdOut().writer();

const tabSize = 4;

pub fn main() !void
{
	if (std.io.getStdIn().isTty())
	{
		std.debug.print("No input...", .{});
		return;
	}

	const in_stream = std.io.getStdIn().reader();

	var buf_reader = std.io.bufferedReader(in_stream);
	var r = buf_reader.reader();
	while (true)
	{
		//Read line
		const raw_line = try r.readUntilDelimiterOrEofAlloc(gpa, '\n', 1024);
		defer if (raw_line) |l| gpa.free(l);
		if (raw_line == null) break;
		const line = raw_line.?;

		//calculate indentation
		var indent_len: usize = 0;
		var index: usize = 0;
		while (index < line.len and (line[index] == ' ' or line[index] == '\t'))
		{
			if (line[index] == '\t')
			{
				indent_len += tabSize;
				index += 1;
			}

			if (line[index] == ' ')
			{
				indent_len += 1;
				index += 1;
			}
		}

		try writeIndentation(indent_len);

		var trimmed = std.mem.trim(u8, line, " \t");

		if (trimmed.len <= 0)
		{
			try out_stream.writeAll("\n");
			continue;
		}

		if (trimmed.len > 1)
		{
			if (trimmed[trimmed.len - 1] == '{')
			{
				if (std.mem.eql(u8, trimmed[trimmed.len - 2 ..], ".{"))
				{
					// write line without '{' and trim any whitespace between it and the code before it
					const trimmed_again = std.mem.trimRight(u8, trimmed[0 .. trimmed.len - 2], " \t");
					try out_stream.writeAll(trimmed_again);
					try out_stream.writeAll("\n");
					try writeIndentation(indent_len);
					try out_stream.writeAll(".{\n");

					continue;
				
				}
				else if (std.mem.eql(u8, trimmed[trimmed.len - 6 ..], "else {"))
				{
					// write line without '{' and trim any whitespace between it and the code before it
					const trimmed_again = std.mem.trimRight(u8, trimmed[0 .. trimmed.len - 6], " \t");
					try out_stream.writeAll(trimmed_again);
					try out_stream.writeAll("\n");
					try writeIndentation(indent_len);
					try out_stream.writeAll("else\n");
					try writeIndentation(indent_len);
					try out_stream.writeAll("{\n");
					continue;
				}
				else
				{
					// check if line starts with else if then we need to do special case
					if (trimmed.len > 9)
					{
						if (std.mem.eql(u8, trimmed[0..9], "} else if"))
						{
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
					continue;
				}
			}
		}

		try out_stream.writeAll(trimmed);
		try out_stream.writeAll("\n");
	}
}

fn writeIndentation(indentation: usize) !void
{
	if (indentation % tabSize == 0)
	{
		try out_stream.writeByteNTimes('\t', indentation / tabSize);
	}
	else
	{
		try out_stream.writeByteNTimes(' ', indentation);
	}
}
