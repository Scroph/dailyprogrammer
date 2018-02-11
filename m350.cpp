//https://redd.it/7vx85p
#include <iostream>
#include <sstream>
#include <vector>

void solve(const std::vector<int>& input, int sum)
{
	int left = 0, right = sum - input[0];
	if(right == left)
		std::cout << 0 << std::endl;
	for(size_t i = 1; i < input.size(); i++)
	{
		left += input[i - 1];
		right -= input[i];
		if(left == right)
			std::cout << i << std::endl;
	}
}

int main()
{
	std::string line;
	while(std::getline(std::cin, line))
	{
		std::string input;
		std::getline(std::cin, input);
		std::stringstream ss(input);
		std::vector<int> elements;
		elements.reserve(std::stoi(line));
		int element, sum = 0;
		while(ss >> element)
		{
			sum += element;
			elements.push_back(element);
		}
		std::cout << input << std::endl;
		solve(elements, sum);
	}
}
