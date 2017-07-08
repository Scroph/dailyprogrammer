import std.stdio;
import std.array;
import std.algorithm;
import std.string;
import std.conv;
import std.experimental.ndslice;

enum optimization = [
	"LR": "",
	"RL": "",
	"VV": "",
	"HH": ""
];

/*string optimize(const string operation)
{
	int[char] rotation = [
		'L': -90,
		'R': +90,
	];
	int[2][char] mirror = [
		'H': [0, 1],
		'V': [1, 0],
	];

	int finalRotation;
	int finalFlip;
	foreach(letter; operation)
	{
		if(letter in rotation)
		{
			finalRotation += rotated[letter];
		}
		else if(letter in mirror)
		{
			finalFlip[0] += mirror[letter][0];
			finalFlip[1] += mirror[letter][1];
		}
	}

	finalRotation %= 360;
	finalFlip[0] %= 2;
	finalFlip[1] %= 2;
}*/


void main(string[] args)
{
	auto header = readln.strip.split(" ");
	int width = header[1].to!int;
	int height = header[2].to!int;
	int max = header[3].to!int;
	auto picture = slice!int(height, width);
	string operations = args[1].optimize;
	pragma(msg, typeof(picture));
	foreach(row; 0 .. height)
	{
		foreach(col; 0 .. width)
		{
			picture[row][col] = readln.strip.to!int;
		}
	}

	foreach(operation; operations)
	{
		switch(operation)
		{
			case 'R': picture = picture.rotated(-1); break;
			case 'L': picture = picture.rotated(1); break;
			case 'H': picture = picture.reversed!1; break;
			case 'V': picture = picture.reversed!0; break;
			default : break;
		}
	}

	writeln("P2 ", picture.shape[1], ' ', picture.shape[0], ' ', max);
	foreach(row; picture)
		foreach(cell; row)
			cell.writeln;
}

int[][] loadPicture(const string path)
{
	auto fh = File(path, "r");
	auto header = fh.readln.strip.split(" ");
	int width = header[1].to!int;
	int height = header[2].to!int;
	int max = header[3].to!int;
	auto picture = new int[][](height, width);
	foreach(row; 0 .. height)
	{
		foreach(col; 0 .. width)
		{
			picture[row][col] = fh.readln.strip.to!int;
		}
	}
	return picture;
}

int[][] apply(const int[][] input, const string operations)
{
	auto picture = slice!int(input.length, input[0].length);
	foreach(row; 0 .. input.length)
	{
		foreach(col; 0 .. input[0].length)
		{
			picture[row][col] = input[row][col];
		}
	}
	foreach(operation; operations)
	{
		switch(operation)
		{
			case 'R': picture = picture.rotated(-1); break;
			case 'L': picture = picture.rotated(1); break;
			case 'H': picture = picture.reversed!1; break;
			case 'V': picture = picture.reversed!0; break;
			default : break;
		}
	}
	return picture.ndarray;
}

unittest
{
	assert(loadPicture("earth.pgm").apply("R") == loadPicture("earth-R.pgm"));
	assert(loadPicture("earth.pgm").apply("L") == loadPicture("earth-L.pgm"));
	assert(loadPicture("earth.pgm").apply("H") == loadPicture("earth-H.pgm"));
	assert(loadPicture("earth.pgm").apply("V") == loadPicture("earth-V.pgm"));
	assert(loadPicture("earth.pgm").apply("HL") == loadPicture("earth-HL.pgm"));
	assert(loadPicture("earth.pgm").apply("HH") == loadPicture("earth.pgm"));
}

string optimize(const string input)
{
	bool done;
	string result = input;
	do
	{
		done = true;
		foreach(k, v; optimization)
		{
			if(input.canFind(k))
			{
				done = false;
				result = result.replace(k, v);
			}
		}
	}
	while(!done);
	return result;
}
