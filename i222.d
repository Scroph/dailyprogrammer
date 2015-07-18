import std.stdio;
import std.range;
import std.range;

int main(string[] args)
{
	int key = 1337;
	string msg = "foobaar";
	writeln(msg.encrypt(key));
	writeln(msg.encrypt(key).decrypt(key));
	return 0;
}

unittest
{
	string msg = "foobar";
	int key = 1337;
	auto cypher = msg.encrypt(key);
	assert(cypher != msg.encrypt(1338));
	assert(cypher.decrypt(key) == msg);
	assert(cypher.decrypt(1338) != msg);
}

struct RC4(R)
{
	enum mult = 2 ^^ 32;
	enum inc = 1013904223;
	enum mod = 1664525;
	typeof(recurrence) lcg;
	R data;

	this(R)(R data, int key) if(isInputRange!R)
	{
		lcg = recurrence!"(mult * n + inc) % mod"(key);
		this.data = data;
	}

	void popFront()
	{
		data.popFront();
		lcg.popFront();
	}

	ubyte front()
	{
		return data.front ^ lcg.front;
	}

	bool empty()
	{
		return data.empty;
	}
}

unittest
{
	auto encrypted = array(RC4!(immutable(char))("foobar", 1337));
	assert(array(RC4!(immutable(char))(encrypted, 1337)) == "foobar");
}

string encrypt(string msg, int key)
{
	auto gen = recurrence!"((2 ^^ 32) * n + 1013904223) % 1664525"(key);
	string cypher;
	cypher.reserve(msg.length);
	foreach(i, ch, rnd; lockstep(msg, take(gen, msg.length)))
		cypher ~= ch ^ rnd;
	return cypher;
}

string decrypt(string cypher, int key)
{
	auto gen = recurrence!"((2 ^^ 32) * n + 1013904223) % 1664525"(key);
	string msg;
	msg.reserve(cypher.length);
	foreach(i, ch, rnd; lockstep(cypher, take(gen, cypher.length)))
		msg ~= ch ^ rnd;
	return msg;
}

