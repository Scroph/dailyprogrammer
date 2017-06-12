//https://www.reddit.com/r/dailyprogrammer/comments/6fe9cv/20170605_challenge_318_easy_countdown_game_show/dihurf3/
import std.stdio;
import std.conv;
import std.algorithm;
import std.string;
import std.array;
import std.range;

immutable double function(double, double)[char] operations;
shared static this()
{
	operations = [
		'+': (a, b) => a + b,
		'-': (a, b) => a - b,
		'/': (a, b) => a / b,
		'*': (a, b) => a * b
	];
}

void main()
{
	foreach(line; stdin.byLine)
	{
		int[] numbers = line.strip.splitter.map!(to!int).array;
		/*double total = numbers.back;
		numbers.popBack;*/
		handleCase(numbers[0 .. $ - 1], numbers.back);
	}
}

void handleCase(int[] numbers, double total)
{
	foreach(permutation; numbers.permutations)
	{
		int[] current = permutation.array;
		auto base = Base(4, current.length - 1);
		foreach(indexes; base)
		{
			string operators = indexes.map!(i => "+-*/"[i]).to!string;
			double result = current.evaluate(operators);
			if(result == total)
			{
				foreach(n, op; lockstep(current, operators))
					write(n, ' ', op, ' ');
				writeln(current.back, " = ", result);
				return;
			}
		}
	}
	writeln("No result was found.");
}

struct Base
{
	int length;
	int base;
	private int current;

	this(int base, int length)
	{
		this.base = base;
		this.length = length;
	}

	void popFront()
	{
		current++;
	}

	int[] front() @property const
	{
		int[] converted;
		converted.reserve(length);
		int c = current;
		while(c)
		{
			converted ~= c % base;
			c /= base;
		}
		while(converted.length < length)
			converted ~= 0;
		converted.reverse();
		return converted;
	}

	bool empty() @property const
	{
		return front.length > length;
	}
}

unittest
{
	auto base = Base(4, 3);
	assert(base.front == [0, 0, 0]);
	base.popFront;
	assert(base.front == [0, 0, 1]);
	base.popFront;
	base.popFront;
	base.popFront;
	assert(base.front == [0, 1, 0]);
}

double evaluate(const int[] numbers, string operators)
{
	double result = numbers[0];
	for(int i = 1, j = 0; i < numbers.length; i++, j++)
		result = operations[operators[j]](result, numbers[i]);
	return result;
}

unittest
{
	assert(evaluate([3, 8, 7, 6, 3, 1], "+*+*+") == 250);
	assert(evaluate([7, 3, 100, 7, 9], "*+*+") == 856);
	assert(evaluate([100, 6, 3, 75, 50, 25], "+**-/") == 952);
}
