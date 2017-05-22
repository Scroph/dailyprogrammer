//https://www.reddit.com/r/dailyprogrammer/comments/6ba9id/20170515_challenge_315_easy_xor_multiplication/dhlhqdo/
#include <iostream>
#include <sstream>

int multiply(int a, int b)
{
	int result = 0;
	int shift = 0;
	while(b)
	{
		result ^= (a * (b & 1)) << shift;
		b >>= 1;
		shift++;
	}
	return result;
}

int main()
{
	std::string line;
	while(getline(std::cin, line))
	{
		std::stringstream ss(line);
		int a, b;
		ss >> a >> b;
		std::cout << a << '@' << b << " = " << multiply(a, b) << std::endl;
	}
}

