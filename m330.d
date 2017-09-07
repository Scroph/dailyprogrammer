//https://redd.it/6yep7x
import std.stdio;
import std.uni;
import std.exception;
import std.algorithm;
import std.array;
import std.conv;
import std.string;
import std.range;

void main()
{
	double input;
	foreach(string line; stdin.lines)
	{
		string dollars, cents;
		size_t comma = line.indexOf('.');
		if(comma != -1)
		{
			dollars = line[0 .. comma];
			cents = line[comma + 1 .. $].strip;
		}
		else
		{
			dollars = line.strip;
			cents = "000";
		}

		dollars = dollars.rightJustify(dollars.length.round_to_multiple(3), '0');
		cents = cents.rightJustify(cents.length.round_to_multiple(3), '0');

		dollars
			.chunks(3)
			.map!(to!string)
			.map!to_words
			.array
			.combine
			.asCapitalized
			.write;

		write(" dollars and ");

		cents
			.chunks(3)
			.map!(to!string)
			.map!to_words
			.array
			.combine
			.write;

		writeln(" cents.");
	}
}

string combine(string[] parts)
{
	immutable suffixes = ["", "thousand", "million", "billion", "trillion", "quadrillion", "quintillion", "gazillion"];

	parts.reverse;
	foreach(i, h; parts)
		if(i != 0)
			parts[i] ~= " " ~ suffixes[i];
	return parts.retro.join(", ");
}

int round_to_multiple(int n, int divisor)
{
	if(n != 0 && n % divisor == 0)
		return n;
	return n + divisor - (n % divisor);
}

unittest
{
	pragma(msg, 6.round_to_multiple(3));
	static assert(6.round_to_multiple(3) == 6);

	pragma(msg, 7.round_to_multiple(3));
	static assert(7.round_to_multiple(3) == 9);

	pragma(msg, 3.round_to_multiple(3));
	static assert(3.round_to_multiple(3) == 3);

	pragma(msg, 1.round_to_multiple(3));
	static assert(1.round_to_multiple(3) == 3);

	pragma(msg, 0.round_to_multiple(3));
	static assert(0.round_to_multiple(3) == 3);
}

string to_words(string n)
{
	enforce(n.length == 3, "to_words requires a number that consists of three digits");
	if(n == "000")
		return "zero";
	immutable ones = ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
	immutable tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];
	immutable special = ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"];

	string[] parts;
	if(n[0] != '0')
		parts ~= ones[n[0] - '0'] ~ " hundred";
	if(n[1] == '1')
	{
		parts ~= special[n[2] - '0'];
		return parts.join(" ");
	}
	if(n[1] != '0')
		parts ~= tens[n[1] - '0'];
	if(n[2] != '0')
		parts ~= ones[n[2] - '0'];
	return parts.join(" ");
}

unittest
{
	pragma(msg, "391".to_words);
	static assert("391".to_words == "three hundred ninety one");

	pragma(msg, "911".to_words);
	static assert("911".to_words == "nine hundred eleven");

	pragma(msg, "742".to_words);
	static assert("742".to_words == "seven hundred forty two");

	pragma(msg, "388".to_words);
	static assert("388".to_words == "three hundred eighty eight");

	pragma(msg, "302".to_words);
	static assert("302".to_words == "three hundred two");

	pragma(msg, "420".to_words);
	static assert("420".to_words == "four hundred twenty");

	pragma(msg, "800".to_words);
	static assert("800".to_words == "eight hundred");

	pragma(msg, "010".to_words);
	static assert("010".to_words == "ten");

	pragma(msg, "019".to_words);
	static assert("019".to_words == "nineteen");

	pragma(msg, "042".to_words);
	static assert("042".to_words == "forty two");
}
