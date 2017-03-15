import std.stdio;
import std.functional;
import std.conv;
import std.range;
import std.algorithm;

string[] generateGrayCodes(int length)
{
	if(length == 1)
		return ["0", "1"];
	return memoize!generateGrayCodes(length - 1)
		.map!(gray => "0" ~ gray)
		.chain(memoize!generateGrayCodes(length - 1)
			.retro
			.map!(gray => "1" ~ gray)
		).array;
}

void main()
{
	foreach(n; stdin.byLine.map!(to!int))
		n.generateGrayCodes.writeln;
}
