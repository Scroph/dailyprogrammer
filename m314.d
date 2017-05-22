//https://www.reddit.com/r/dailyprogrammer/comments/6aefs1/20170510_challenge_314_intermediate_comparing/dhdz3ij/
import std.stdio;
import std.typecons : tuple;
import std.string : strip;

void main()
{
	foreach(line; stdin.byLine)
	{
		auto word = line.strip;
		auto current = word.dup;
		auto smallest = tuple(0, current);
		int rotations;
		do
		{
			current = current[1 .. $] ~ current[0];
			rotations++;
			if(current < smallest[1])
			{
				smallest[0] = rotations;
				smallest[1] = current;
			}
		}
		while(current != word);
		writeln(smallest[0], ' ', smallest[1]);
	}
}
