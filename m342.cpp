#include <iostream>
#include <algorithm>
#include <cmath>

std::string encode(const std::string& input)
{
	std::string result;
	size_t padding = 0;
	for(size_t i = 0; i < input.length(); i += 4)
	{
		std::string part = input.substr(i, 4);
		while(part.length() % 4 != 0)
		{
			part += '\0';
			padding++;
		}
		uint32_t concatenated = part[3]
			| part[2] << 8
			| part[1] << 16
			| part[0] << 24;

		std::string chunk;
		while(concatenated)
		{
			chunk += 33 + (concatenated % 85);
			concatenated /= 85;
		}
		std::reverse(chunk.begin(), chunk.end());
		result += chunk;
	}
	return result.substr(0, result.length() - padding);
}

std::string decode(const std::string& input)
{
	std::string result;
	size_t padding = 0;
	for(size_t i = 0; i < input.length(); i += 5)
	{
		uint32_t concatenated = 0;
		std::string part = input.substr(i, 5);
		while(part.length() % 5 != 0)
		{
			part += 'u';
			padding++;
		}
		for(size_t j = 0; j < part.length(); j++)
		{
			char current = part[j];
			concatenated += (current - 33) * std::pow(85, part.length() - 1 - j);
		}
		
		std::string chunk;
		while(concatenated)
		{
			chunk += concatenated & 0xff;
			concatenated >>= 8;
		}
		std::reverse(chunk.begin(), chunk.end());
		result += chunk;
	}
	return result.substr(0, result.length() - padding);
}

int main()
{
	std::string line;
	while(std::getline(std::cin, line))
	{
		char operation = line[0];
		std::string input = line.substr(2);
		input = input.substr(0, input.length() - 1);
		if(operation == 'e')
			std::cout << encode(input) << std::endl;
		else
			std::cout << decode(input) << std::endl;
	}
}
