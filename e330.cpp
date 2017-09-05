//https://redd.it/6y19v2#include <iostream>
#include <iomanip>
#include <sstream>
#include <algorithm>

struct Point
{
	double x;
	double y;

	Point() : x(0), y(0) {}
	Point(double x, double y) : x(x), y(y) {}

	friend std::ostream& operator<<(std::ostream& out, const Point& p);
};

std::ostream& operator<<(std::ostream& out, const Point& p)
{
	return out << '(' << p.x << ", " << p.y << ')';
}

int main()
{
	Point up_left;
	Point up_right;
	Point down_left;
	Point down_right;
	//while(std::cin >> x >> y >> r)
	std::string line;
	while(getline(std::cin, line))
	{
		double x, y, r;
		std::replace(line.begin(), line.end(), ',', ' ');
		std::stringstream ss(line);
		ss >> x >> y >> r;

		up_left.x = std::min(up_left.x, x - r);
		up_left.y = std::max(up_left.y, y + r);

		up_right.x = std::max(up_right.x, x + r);
		up_right.y = std::max(up_left.y, y + r);

		down_left.x = std::min(down_left.x, x - r);
		down_left.y = std::min(down_left.y, y - r);

		down_right.x = std::max(down_right.x, x + r);
		down_right.y = std::min(down_right.y, y - r);
	}

	std::cout << std::setprecision(4) << std::showpoint << down_left << ", ";
	std::cout << up_left << ", ";
	std::cout << up_right << ", ";
	std::cout << down_right << std::endl;
}
