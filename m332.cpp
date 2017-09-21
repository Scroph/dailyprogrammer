//https://redd.it/71gbqj
#include <iostream>
#include <algorithm>
#include <vector>
#include <sstream>

struct Backtracker
{
	std::vector<int> peaks;
	std::vector<int> result;

	std::vector<int> find_next(const std::vector<int>& peaks, size_t current)
	{
		std::vector<int> higher;
		for(size_t i = current + 1; i < peaks.size(); i++)
			if(peaks[i] > peaks[current])
				higher.push_back(i);
		return higher;
	}

	void solve(size_t current, std::vector<int> depth)
	{
		auto higher = find_next(peaks, current);
		if(higher.size() == 0 && result.size() < depth.size())
		{
			result = depth;
			return;
		}
		for(auto& next: higher)
		{
			depth.push_back(next);
			solve(next, depth);
			depth.pop_back();
		}
	}

	void solve()
	{
		std::vector<int> tmp { 0 };
		solve(0, tmp);
	}

	friend std::ostream& operator<<(std::ostream& out, const Backtracker& b);
};

std::ostream& operator<<(std::ostream& out, const Backtracker& b)
{
	for(const auto& p: b.result)
		out << b.peaks[p] << ' ';
	return out;
}

int main()
{
	std::string line;
	while(getline(std::cin, line))
	{
		Backtracker b;
		std::stringstream ss(line);
		int peak;
		while(ss >> peak)
			b.peaks.push_back(peak);
		b.solve();
		std::cout << b << std::endl;
	}
}
