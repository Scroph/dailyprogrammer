#include <iostream>
#include <vector>
#include <algorithm>
#include <set>
#include <sstream>

int main()
{
	std::string line;
	while(std::getline(std::cin, line))
	{
		std::stringstream ss(line);
		std::string number;
		std::vector<std::string> numbers;
		//std::set<std::string> numbers;
		while(ss >> number)
			numbers.push_back(number);
			//numbers.insert(number);
		std::sort(numbers.begin(), numbers.end(), [](const std::string& a, const std::string& b) {
			return std::stoi(a + b) - std::stoi(b + a);
		});
		for(const auto& n: numbers)
			std::cout << n;
		std::cout << ' ';
		for(auto it = numbers.rbegin(); it != numbers.rend(); it++)
			std::cout << *it;
		std::cout << std::endl;
	}
}
