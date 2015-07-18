//http://redd.it/3d4fwj
import std.stdio;
import std.functional;
import std.getopt;
import std.range;
import std.string;

int main(string[] args)
{
	if(args.length > 1)
	{
		int limit = 10;
		string word;
		getopt(args, "l|limit", &limit, std.getopt.config.passThrough);
		writeln("Garland degree : ", garland(args[1]));
		writeln("Garland sequence : ", GarlandSequence(args[1]).take(limit));
	}
	return 0;
}

void findLargest()
{
	int largest;
	int result;
	string word;
	foreach(line; File("enable1.txt").byLine.map!(pipe!(strip, idup)))
	{
		result = garland(line);
		if(result > largest)
		{
			largest = result;
			word = line;
		}
	}
	writeln("Largest garland is ", largest, " for ", word);
}

int garland(string word)
{
	int result;
	foreach(i, ch; word)
		if(i != word.length && word.endsWith(word[0 .. i]))
			result = i;
	return result;
}

unittest
{
	assert(garland("programmer") == 0);
	assert(garland("ceramic") == 1);
	assert(garland("onion") == 2);
	assert(garland("alfalfa") == 4);
}

struct GarlandSequence
{
	string word;
	int idx;
	int degree;

	this(string word)
	{
		this.word = word;
		degree = garland(word);
	}
	
	void popFront()
	{
		idx++;
		if(idx >= word.length)
			idx = degree;
	}

	immutable(char) front() @property
	{
		return word[idx];
	}

	enum bool empty = false;
}
