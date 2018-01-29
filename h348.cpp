//https://redd.it/7t6fnc
#include <iostream>
#include <algorithm>
#include <vector>
#include <set>

struct Solver
{
	std::set<int> squares;
	std::vector<int> output;
	int N;

	Solver(int n)
	{
		N = n;
		output.reserve(N + 1);
		for(int i = 0; i < N + 1; i++)
			output.push_back(0);
		for(int i = 2; i < n; i++)
			if(i * i < n * 2)
				squares.insert(i * i);
	}

	bool solve()
	{
		for(int i = 1; i <= N; i++)
		{
			output[0] = i;
			if(backtrack(0))
				return true;
		}
		return false;
	}

	friend std::ostream& operator<<(std::ostream& out, const Solver& s)
	{
		for(size_t i = 0; i < s.N; i++)
			out << s.output[i] << ' ';
		return out;
	}

	private:
	std::vector<int> find_next(int n) const
	{
		std::vector<int> result;
		for(int sq: squares)
			if(sq > n && std::find(output.begin(), output.end(), sq - n) == output.end())
				result.push_back(sq - n);
		return result;
	}

	bool is_valid() const
	{
		for(int i = 1; i <= N; i++)
			if(std::find(output.begin(), output.end(), i) == output.end())
				return false;
		return true;
	}

	bool backtrack(size_t idx)
	{
		//std::cout << *this << std::endl;
		if(idx >= N)
			return false;
		if(idx == N - 1 && is_valid())
			return true;

		for(auto next: find_next(output[idx]))
		{
			output[idx + 1] = next;
			if(backtrack(idx + 1))
				return true;
			output[idx + 1] = 0;
		}
		return false;
	}
};

int main()
{
	int N;
	while(std::cin >> N)
	{
		Solver solver(N);
		if(solver.solve())
			std::cout << N << " : " << solver << std::endl;
		else
			std::cout << N << " : no solution was found." << std::endl;
	}
}
