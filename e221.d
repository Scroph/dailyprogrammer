import std.stdio;
import std.random;
import std.range;
import std.array;

enum Direction
{
	left, right
}

int main(string[] args)
{
	if(args.length < 2)
	{
		writefln("Usage : %s <text>", args[0]);
		return 0;
	}
	bool vertical;
	int padding;
	int i;
	int spaces = args[1].count!("a == ' '");
	writeln(spaces);
	auto words = splitter(args[1], " ");
	foreach(w; words)
	{
		if(vertical)
		{
			//if this is the last iteration, display the whole word
			int end = i + 1 == 10 ? w.length : w.length - 1;
			foreach(letter; w[1 .. end])
			{
				writeln(repeat(' ', padding), letter);
			}
		}
		else
		{
			auto direction = uniform!Direction();
			if(direction == Direction.left && padding > w.length)
			{
				padding -= (w.length - 1);
				writeln(repeat(' ', padding), w.retro);
			}
			else
			{
				writeln(repeat(' ', padding), w);
				padding += (w.length - 1);
			}
		}
		vertical = !vertical;
		i++;
	}
	return 0;
}

