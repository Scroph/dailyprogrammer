//https://www.reddit.com/r/dailyprogrammer/comments/6coqwk/20170522_challenge_316_easy_knights_metric/dhwf9o5/
#include <iostream>
#include <array>
#include <utility>
#include <set>
#include <map>
#include <queue>

struct Point
{
	int x;
	int y;

	Point() : x(0), y(0) {}
	Point(int x, int y) : x(x), y(y) {}
	Point operator+(const Point& p) const
	{
		return Point(x + p.x, y + p.y);
	}

	bool operator<(const Point& p) const
	{
		if(p.x == x)
			return p.y < y;
		return p.x < x;
	}

	bool operator==(const Point& p) const
	{
		return p.x == x && p.y == y;
	}
};

std::array<Point, 8> movements {
	Point(-1,-2), Point(1,-2), Point(-1, 2), Point(1, 2),
	Point(-2,-1), Point(2,-1), Point(-2, 1), Point(2, 1)
};

int main()
{
	Point start;
	Point destination;
	std::cin >> destination.x >> destination.y;
	std::map<std::pair<Point, Point>, int> dist;
	std::queue<Point> queue;
	std::set<Point> visited;

	queue.push(start);
	visited.insert(start);
	while(!queue.empty())
	{
		auto current = queue.front();
		if(current == destination)
			break;
		queue.pop();

		for(auto& move: movements)
		{
			auto neighbor = current + move;
			if(visited.find(neighbor) != visited.end())
				continue;
			visited.insert(neighbor);
			queue.push(neighbor);
			dist[std::make_pair(start, neighbor)] = dist[std::make_pair(start, current)] + 1;
		}
	}
	std::cout << dist[std::make_pair(start, destination)] << std::endl;
}
