import std.stdio;
import std.conv;
import std.string;
import std.algorithm;

void main()
{
	foreach(line; stdin.byLine)
	{
		int number = line.to!int;
		line
			.strip
			.permutations
			.filter!(perm => !perm.startsWith('0'))
			.map!(to!int)
			.filter!(perm => perm > number)
			.reduce!min
			.writeln;
	}
}
