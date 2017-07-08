import std.stdio;
import std.file;
import std.datetime;
import std.parallelism;
import std.functional;
import std.conv;
import std.string;
import std.algorithm;
import std.range;

int main(string[] args)
{
	if(args.length < 2)
	{
		writeln("Usage : ", args[0], " <word>");
		return 0;
	}
	immutable lines = "enable1.txt".readText.splitLines;
	StopWatch sw;
	sw.start();
	auto start = sw.peek().msecs;
	writeln("Problem count for ", args[1], " is ", lines.problemCount(args[1]));
	auto end = sw.peek().msecs;
	sw.stop();
	writeln("Took ", end - start, " milliseconds");
	readln();
	return 0;
}

int problemCount(ref immutable string[] lines, string word)
{
	int result;
	foreach(i, line; taskPool.parallel(lines))
		if(line.problem(word))
			result++;
	return result;
}

bool problem(string secret, string offensive)
{
	return secret.filter!(x => offensive.indexOf(x) != -1).to!string == offensive;
}

unittest
{
	assert(problem("synchronized", "snond") == true);
	assert(problem("misfunctioned", "snond") == true);
	assert(problem("mispronounced", "snond") == false);
	assert(problem("shotgunned", "snond") == false);
	assert(problem("snond", "snond") == true);
}
