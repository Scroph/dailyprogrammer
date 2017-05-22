//https://www.reddit.com/r/dailyprogrammer/comments/6arlw4/20170512_chalenge_314_hard_finding_point_nemo/dhhm0cv/
#include <iostream>
#include <array>
#include <algorithm>
#include <cmath>
#include <vector>

struct Point
{
	int x;
	int y;
};

std::ostream& operator<<(std::ostream& out, const Point& p)
{
	return out << p.x << ':' << p.y;
}

double euclidianDistance(const Point& p1, const Point& p2, int width, bool wraparound)
{
	if(!wraparound)
		return std::sqrt(std::pow(p1.x - p2.x, 2) + std::pow(p1.y - p2.y, 2));
	return std::sqrt(std::pow(width - p2.x + p1.x, 2) + std::pow(p1.y - p2.y, 2));
}

int main()
{
	std::vector<Point> land;
	std::vector<Point> sea;

	std::string line;
	int width, height;
	std::cin >> width >> height;
	int y = 0;
	getline(std::cin, line);
	while(getline(std::cin, line))
	{
		while(line.length() < width)
			line += " ";
		for(int x = 0; x < line.length(); x++)
		{
			if(line[x] == '#')
				land.push_back({x, y});
			else
				sea.push_back({x, y});
		}
		y++;
	}

	double largest_distance = 0;
	Point nemo;
	for(const Point& s: sea)
	{
		double closest_land = 1000000;
		for(const Point& l: land)
		{
			std::array<double, 4> distances {
				euclidianDistance(s, l, width, false),
				euclidianDistance(s, l, width, true),
				euclidianDistance(l, s, width, false),
				euclidianDistance(l, s, width, true)
			};
			double distance = *(std::min_element(distances.begin(), distances.end()));
			if(distance < closest_land)
				closest_land = distance;
		}
		if(closest_land > largest_distance)
		{
			nemo = s;
			largest_distance = closest_land;
		}
	}
	std::cout << nemo << " : " << largest_distance << std::endl;
}
