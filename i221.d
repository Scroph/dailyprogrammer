import std.stdio;
import std.array;
import std.range;
import std.string;
import std.conv;

int main(string[] args)
{
	int n = readln.strip.to!int;
	auto lines = new string[n];
	foreach(i; 0 .. n)
		lines[i] = readln.chomp("\n");
	lines = lines.padLines();
	Direction dir = lines[0][1] == ' ' ? Direction.down : Direction.right;
	int i, j;
	write(lines[i][j]);
	while(true)
	{
		switch(dir) with(Direction)
		{
			case down:
				i++;
			break;
			case right:
				j++;
			break;
			case left:
				j--;
			break;
			case up:
				i--;
			break;
			default: break;
		}
		write(lines[i][j]);
		auto new_dir = lines.nextDirection(dir, i, j);
		if(new_dir == Direction.none)
			break;
		if(dir != new_dir)
			write(" ", lines[i][j]);
		dir = new_dir;
	}

	return 0;
}

enum Direction
{
	up, down, left, right, none
}

Direction nextDirection(string[] lines, Direction dir, int i, int j)
{
	if(i + 1 < lines.length && lines[i + 1][j] != ' ' && dir != Direction.up)
		return Direction.down;
	if(i - 1 >= 0 && lines[i - 1][j] != ' ' && dir != Direction.down)
		return Direction.up;
	if(j + 1 < lines[0].length && lines[i][j + 1] != ' ' && dir != Direction.left)
		return Direction.right;
	if(j - 1 >= 0 && lines[i][j - 1] != ' ' && dir != Direction.right)
		return Direction.left;
	return Direction.none;
}

unittest
{
	auto lines = [
		"SNAKE             ",
		"    A   DUSTY     ",
		"    T   N   U     ",
		"    SALSA   M     ",
		"            M     ",
		"            YACHTS"
	];
	assert(lines.nextDirection(Direction.right, 0, 1) == Direction.right);
	assert(lines.nextDirection(Direction.down, 1, 4) == Direction.down);
	assert(lines.nextDirection(Direction.down, 3, 4) == Direction.right);
	assert(lines.nextDirection(Direction.right, 3, 8) == Direction.up);
	assert(lines.nextDirection(Direction.up, 1, 8) == Direction.right);
	assert(lines.nextDirection(Direction.right, 5, 17) == Direction.none);
}

string[] padLines(string[] lines)
{
	int max_len;
	foreach(l; lines)
		if(l.length > max_len)
			max_len = l.length;
	foreach(ref l; lines)
		l ~= ' '.repeat(max_len - l.length).array;
	return lines;
}

unittest
{
	auto lines = ["ab", "abc", "abcd", "abc"];
	assert(lines.padLines() == ["ab  ", "abc ", "abcd", "abc "]);
}
