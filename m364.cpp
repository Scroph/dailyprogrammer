#include <iostream>
#include <set>
#include <vector>
#include <algorithm>
#include <cmath>
#include <sstream>

using namespace std;
int ducci(const vector<int>& seq);

int main()
{
	string line;
	while(getline(cin, line))
	{
		vector<int> sequence;
		int n;
		line = line.substr(1, line.size() - 3);
		cout << line << endl;
		replace(line.begin(), line.end(), ',', ' ');
		stringstream ss(line);
		while(ss >> n)
		{
			sequence.push_back(n);
		}
		auto reps = ducci(sequence);
		cout << reps << endl;
		cout << endl;
	}
}

int ducci(const vector<int>& seq)
{
	set<vector<int>> history;
	auto prev = seq;
	history.insert(prev);
	for(size_t i = 1; ; i++)
	{
		vector<int> curr;
		curr.reserve(prev.size());
		for(size_t j = 1; j < prev.size(); j++)
		{
			curr.push_back(abs(prev[j] - prev[j - 1]));
			//cout << curr.back() << " ";
		}
		curr.push_back(abs(prev.back() - prev.front()));
		if(history.find(curr) != history.end())
		{
			cout << "Repetition detected" << endl;
			return i + 1;
		}
		history.insert(curr);
		//cout << curr.back() << endl;
		if(all_of(curr.begin(), curr.end(), [](int n) { return n == 0; }))
		{
			return i + 1;
		}
		prev = curr;
	}
	return -1;
}
