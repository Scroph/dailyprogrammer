import std.stdio;
import std.range;
import std.string;

int main(string[] args)
{
	string[] wordlist = "wordlist.txt".readText.splitLines;
	string[] lines = args[1].readText.splitLines;
	int[int] frequency;
	foreach(i, line; lines)
		foreach(word; line.split(" ").map!strip)
				frequency[i] += wordlist.count(word);
	foreach(line; frequency.sort!"a > b"().take(3))
		writeln(line);
	
	return 0;
}

string nthLine(File fh, int nth)
{
	int i;
	fh.rewind();
	foreach(line; fh.byLine)
		if(i++ == nth)
			return line;
	assert(false);
}
