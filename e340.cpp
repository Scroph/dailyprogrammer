#include <iostream>
#include <map>

void handle_case(const std::string& input)
{
	std::map<char, int> character_count;

	for(char c: input)
	{
		if(++character_count[c] > 1)
		{
			std::cout << c << " : " << input.find(c) << std::endl;
			return;
		}
	}
	std::cout << "Np duplicates were found." << std::endl;
}
int main()
{
	std::string input;
	while(getline(std::cin, input))
	{
		std::cout << input << std::endl;
		handle_case(input);
	}
}
