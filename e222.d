import std.stdio;
import std.functional : pipe;
import std.algorithm : map;
import std.string;

immutable alphabet = " abcdefghijklmnopqrstuvwxyz";
int main(string[] args)
{
	foreach(word; stdin.byLine.map!(pipe!(strip, toLower, idup)))
	{
		bool balanced;
		foreach(i; 1 .. word.length - 1)
		{
			int left = word.leftBalance(i);
			int right = word.rightBalance(i);
			if(left == right)
			{
				writeln(word[0 .. i], " ", word[i], " ", word[i + 1 .. $], " - ", left);
				balanced = true;
				break;
			}
		}
		if(!balanced)
			writeln(word, " does not balance.");
	}
	return 0;
}

int rightBalance(string word, int index)
{
	int amount;
	foreach(i, letter; word[index + 1 .. $])
		amount += (i + 1) * alphabet.indexOf(letter);
	return amount;
}

int leftBalance(string word, int index)
{
	int amount;
	foreach(i, letter; word[0 .. index])
		amount += (index - i) * alphabet.indexOf(letter);
	return amount;
}

