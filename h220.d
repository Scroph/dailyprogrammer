import std.stdio;
import std.algorithm;
import std.string;
import std.conv;
import std.array;

int main(string[] args)
{
	string[] words = readln.strip.split(" ");
	string[string] hints;
	int n = readln.strip.to!int;
	words.sort!"a.length < b.length";
	while(n--)
	{
		auto line = readln.strip;
		hints[line[0]] = line[1];
	}
	writeln("words = ", words);
	writeln("hints = ", hints);
	bool finished;
	while(!finished)
	{
		bool found;
		while(!found)
		{
			
		}
	}
	return 0;
}

char[] cipher(char[] data, char[char] key)
{
	foreach(idx, letter; data)
		data[idx] = key.get(letter, letter);
	return data;
}

string cipher(string data, string key)
{
	auto result = appender!string;
	result.reserve(data.length);
	foreach(i; 0 .. data.length)
	{
		auto idx = "abcdefghijklmnopqrstuvwxyz".indexOf(data[i]);
		if(idx == -1)
			result ~= data[i];
		else
			result ~= key[idx].toUpper;
	}
	return result.data;
}

string decipher(string data, string key)
{
	auto result = appender!string;
	result.reserve(data.length);
	foreach(i; 0 .. data.length)
	{
		auto idx = key.indexOf(data[i]);
		if(idx == -1)
			result ~= data[i];
		else
			result ~= "abcdefghijklmnopqrstuvwxyz"[idx];
	}
	return result.data;
}

unittest
{
	assert(cipher("hello world", "YOJHZKNEALPBRMCQDVGUSITFXW") == "EZBBC TCVBH");
	assert(decipher("EZBBC TCVBH", "YOJHZKNEALPBRMCQDVGUSITFXW") == "hello world");
}
