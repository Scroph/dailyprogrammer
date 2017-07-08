import std.stdio;
import std.typecons;
import std.format;

alias Tuple!(int, int) Pos;
int main(string[] args)
{
	int N, M;
	Pos depot;
	readf("%d (%d,%d)\n", &depot[0], &depot[1]);
	readf("%d\n", &M);
	Customer[] customers;
	customers.reserve(M);
	foreach(i; 0 .. M)
		customers ~= Customer(stdin.readln);

	return 0;
}

struct Customer
{
	int units;
	Pos location;

	this(string format)
	{
		format.formattedRead("%d (%d,%d)\n", &units, &location[0], &location[1]);
	}

}

unittest
{
	auto customer = Customer("10 (20,30)\n");
	assert(customer.units == 10);
	assert(customer.location[0] == 20);
	assert(customer.location[1] == 30);
	customer = Customer("100 (120,140)\n");
	assert(customer.units == 100);
	assert(customer.location[0] == 120);
	assert(customer.location[1] == 140);
}
