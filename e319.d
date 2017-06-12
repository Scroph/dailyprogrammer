import std.stdio;
import std.range;
import std.algorithm : endsWith;

void main()
{
	foreach(string line; stdin.lines)
	{
		auto words = line.split(" ");
		foreach(i; 0 .. words.length - 1)
		{
			string curr = words[i];
			string next = words[i + 1];

			ulong k = 0;
			foreach(j; 0 .. next.length)
				if(curr.endsWith(next[0 .. j]))
					k = j;

			write(curr[0 .. $ - k]);
			if(k == 0)
				write(' ');
		}
		write(words.back);
	}
}
