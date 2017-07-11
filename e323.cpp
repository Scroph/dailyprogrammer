//https://redd.it/6melen
#include <iostream>
#include <sstream>
#include <vector>
#include <set>
#include <tuple>

int main()
{
	std::string line;
	while(getline(std::cin, line))
	{
		std::stringstream ss(line);
		std::multiset<int> mset;
		int n;
		while(ss >> n)
			mset.insert(n);

		std::set<std::tuple<int, int, int>> triplets;
		const std::vector<int> numbers(mset.begin(), mset.end());
		for(size_t i = 0; i < numbers.size() - 3; i++)
		{
			size_t start = i + 1, end = numbers.size() - 1;
			while(start < end)
			{
				int sum = numbers[i] + numbers[start] + numbers[end];
				if(sum == 0)
				{
					triplets.insert(std::make_tuple(numbers[i], numbers[start], numbers[end]));
					end--;
					continue;
				}
				sum > 0 ? end-- : start++;
			}
		}

		for(const auto& t: triplets)
		{
			std::cout << std::get<0>(t) << ' ';
			std::cout << std::get<1>(t) << ' ';
			std::cout << std::get<2>(t) << std::endl;
		}
		std::cout << std::endl;
	}
	return 0;
}
