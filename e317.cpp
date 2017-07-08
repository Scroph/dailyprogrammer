//https://www.reddit.com/r/dailyprogrammer/comments/6e08v6/20170529_challenge_317_easy_collatz_tag_system/di6zi6m/
#include <iostream>
#include <map>
#include <list>

const std::map<char, std::string> rules {
	{'a', "bc"},
	{'b', "a"},
	{'c', "aaa"},
};
int main()
{
	std::string line;
	while(getline(std::cin, line))
	{
		std::list<char> seq;
		for(char c: line)
			seq.push_back(c);

		while(seq.size() > 1)
		{
			char front = seq.front();
			seq.pop_front();
			seq.pop_front();
			for(char c: rules.at(front))
				seq.push_back(c);
			for(char c: seq)
				std::cout << c;
			std::cout << std::endl;
		}
		std::cout << std::endl;
	}
	return 0;
}
