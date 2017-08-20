#include <iostream>
#include <set>
#include <vector>

struct Point
{
	size_t r;
	size_t c;

	bool operator==(const Point& p) const
	{
		return r == p.r && c == p.c;
	}

	//arbitrary ordering algorithm so that Point is usable with set
	//I should probably use unordered_set though
	bool operator<(const Point& p) const
	{
		return r == p.r ? c < p.c : r < p.r;
	}
};

Point calculate_displacement(const Point& src, const Point& dest)
{
	return {
		dest.r - src.r,
		dest.c - src.c
	};
}

struct Backtracker
{
	size_t N;
	std::vector<std::vector<bool>> board;
	std::vector<Point> ones;
	std::set<Point> displacements;

	Backtracker(size_t N)
	{
		this->N = N;
		ones.reserve(N);
		board.reserve(N);
		for(size_t i = 0; i < N; i++)
			board.push_back(std::vector<bool>(N, false));
	}

	bool is_safe(const Point& p, /* out */ std::set<Point>& current_displacements) const
	{
		for(size_t x = 0; x < N; x++)
		{
			if(board[x][p.c])
				return false;
			if(board[p.r][x])
				return false;
		}

		//calculate displacements of p against every cell that is set to true
		//filling current_displacements in the process
		//so that solve can merge it with the member "displacements" set
		//and remove it later on

		//returns false if there is a duplicate
		for(const auto& one: ones)
		{
			auto d = calculate_displacement(one, p);
			current_displacements.insert(d);
			if(displacements.find(d) != displacements.end())
				return false;

			d = calculate_displacement(p, one);
			current_displacements.insert(d);
			if(displacements.find(d) != displacements.end())
				return false;
		}
		return true;
	}

	bool solve(size_t depth, size_t& solutions)
	{
		if(depth == N)
		{
			solutions++;
			return true;
		}

		for(size_t c = 0; c < N; c++)
		{
			Point current = {depth, c};
			std::set<Point> current_displacements;
			if(is_safe(current, current_displacements))
			{
				board[depth][c] = true;
				ones.push_back(current);
				for(const auto& d: current_displacements)
					displacements.insert(d);

				solve(depth + 1, solutions);

				board[depth][c] = false;
				ones.pop_back();
				for(const auto& d: current_displacements)
					displacements.erase(displacements.find(d));
			}
		}
		return false;
	}
};

int main()
{
	int N;
	while(std::cin >> N)
	{
		Backtracker b(N);
		size_t solutions = 0;
		b.solve(0, solutions);
		std::cout << "Found " << solutions << " solutions :" << std::endl;
	}
}
