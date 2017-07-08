#include <iostream>
#include <algorithm>
#include <cctype>
#include <map>

std::map<std::string, std::string> dict {
	{"A", "4"},
	{"B", "6"},
	{"E", "3"},
	{"I", "1"},
	{"L", "|"},
	{"M", "(V)"},
	{"N", "(\\)"},
	{"O", "0"},
	{"S", "5"},
	{"T", "7"},
	{"U", "\\/"},
	{"W", "`//"}
};

bool is_l33t(const std::string& input)
{
	for(const auto& kv: dict)
		if(input.find(kv.second) != std::string::npos)
			return true;
	return false;
}

std::string search_replace(std::string source, const std::string& haystack, const std::string& needle)
{
	int idx;
	while((idx = source.find(haystack)) != std::string::npos)
	{
		source = source.replace(idx, haystack.length(), needle);
	}
	return source;
}

int main()
{
	std::string line;
	while(getline(std::cin, line))
	{
		std::transform(line.begin(), line.end(), line.begin(), ::toupper);
		std::cout << line << " -> ";
		bool l33t = is_l33t(line);
		for(const auto& kv: dict)
		{
			std::string from = l33t ? kv.second : kv.first;
			std::string to = l33t ? kv.first : kv.second;
			line = search_replace(line, from, to);
			//std::cout << "\t" << line << std::endl;
		}
		std::cout << line << std::endl;
	}
	return 0;
}
