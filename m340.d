//https://redd.it/7d4yoe
import std.stdio;
import std.range;
import std.typecons;
import std.string;
import std.conv : to;
import std.array : array;
import std.algorithm : map, each;

void main()
{
	dchar[][] grid;
	auto robot = Robot(Point(0, 0));
	foreach(row, char[] line; stdin.byLine.enumerate)
	{
		grid ~= line.to!(dchar[]).strip;
		int M = line.indexOf('M');
		if(M != -1)
			robot.pos = Point(M, row);
	}

	string commands = grid.back.to!string;
	grid.popBack();
	
	Point exit = grid.find_exit;
	if(exit == Point(-1, -1))
	{
		writeln("Could not locate the exit, aborting.");
		return;
	}
	Point[] path = [robot.pos];
	auto minefield = Minefield(grid);
	foreach(cmd; commands)
	{
		switch(cmd)
		{
			case 'N':
			case 'S':
			case 'E':
			case 'O':
				if(robot.move(cmd, minefield))
					path ~= robot.pos;
			break;
			case 'I':
				robot.immobilized = false;
			break;
			default:
				robot.immobilized = true;
			break;
		}
	}
	if(!robot.dead && robot.pos == exit && robot.immobilized)
		writeln("Mr. Robot reached the exit !");
	else if(robot.dead)
		writeln("Mr. Robot died trying.");
	else if(robot.pos != exit)
		writeln("Mr. Robot stopped before reaching the exit.");

	minefield.draw(path);
}

Point find_exit(const dchar[][] grid)
{
	if(grid.front.indexOf('0') != -1)
		return Point(grid[0].indexOf('0'), 0);
	if(grid.back.indexOf('0') != -1)
		return Point(grid[0].indexOf('0'), grid.length - 1);
	foreach(i, row; grid)
	{
		if(row.front == '0')
			return Point(0, i);
		if(row.back == '0')
			return Point(row.length - 1, i);
	}
	return Point(-1, -1);
}

struct Point
{
	int x;
	int y;

	Point opBinary(string op)(Point other) if(op == "+")
	{
		return Point(x + other.x, y + other.y);
	}

	bool opEquals(Point other)
	{
		return x == other.x && y == other.y;
	}
}

struct Robot
{
	Point pos;
	bool immobilized;
	bool dead;
	immutable Point[char] movements;

	this(Point pos)
	{
		this.pos = pos;
		this.immobilized = true;
		this.dead = false;
		this.movements = [
			'N': Point(0, -1),
			'S': Point(0, +1),
			'E': Point(+1, 0),
			'O': Point(-1, 0),
		];
	}

	bool move(char direction, const Minefield minefield)
	{
		if(immobilized || dead)
			return false;
		auto new_pos = pos + movements[direction];
		if(minefield.within_bounds(new_pos))
		{
			if(minefield.cell_at(new_pos) == '*')
				dead = true;
			pos = new_pos;
			return true;
		}
		return false;
	}
}

struct Minefield
{
	int width;
	int height;
	dchar[][] minefield;

	this(dchar[][] minefield)
	{
		this.minefield = minefield;
		this.width = minefield[0].length;
		this.height = minefield.length;
	}

	dchar cell_at(Point pos) const
	{
		return minefield[pos.y][pos.x];
	}

	bool within_bounds(Point pos) const
	{
		return 0 <= pos.x && pos.x < minefield[0].length && 0 <= pos.y && pos.y < minefield.length;
	}

	void draw(const Point[] path)
	{
		dchar[][] copy = minefield.dup;
		foreach(point; path)
			copy[point.y][point.x] = ' ';
		copy[path.back.y][path.back.x] = 'M';
		copy.each!writeln;
	}
}
