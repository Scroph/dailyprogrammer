#include <iostream>
#include <array>
#include <sstream>
#include <vector>

struct Point
{
	size_t x;
	size_t y;
	Point() : x(0), y(0) {}
	Point(size_t x, size_t y) : x(x), y(y) {}
	Point operator+(const Point& p) const
	{
		return Point(x + p.x, y + p.y);
	}
};
const std::array<Point, 4> directions {
	Point(0, 1),
	Point(0, -1),
	Point(1, 0),
	Point(-1, 0),
};

struct Room
{
	std::vector<std::string> map;
	Room(const std::vector<std::string>& map) : map(map) {}

	bool within_bounds(const Point& position) const
	{
		return 0 <= position.x && position.x < map[0].size() && 0 <= position.y && position.y < map.size();
	}

	char cell_at(const Point& position) const
	{
		return map[position.y][position.x];
	}

	void set_cell(const Point& position, char value)
	{
		map[position.y][position.x] = value;
	}

	void update(const Point& position)
	{
		if(!within_bounds(position))
			return;
		switch(cell_at(position))
		{
			case 'S':
				set_cell(position, 'F');
				for(const auto& direction: directions)
				{
					auto neighbor = position + direction;
					if(within_bounds(position + direction))
					{
						if(cell_at(neighbor) == 'S')
						{
							update(neighbor);
						}
						else if(cell_at(neighbor) == '_')
						{
							auto beyond_wall = neighbor + direction;
							if(cell_at(beyond_wall) == 'S')
								update(beyond_wall);
						}
					}
				}
			break;
			case ' ':
				set_cell(position, 'S');
				for(const auto& direction: directions)
				{
					auto neighbor = position + direction;
					if(within_bounds(neighbor))
					{
						if(cell_at(neighbor) == '_')
						{
							auto beyond_wall = neighbor + direction;
							if(cell_at(beyond_wall) == ' ')
								update(beyond_wall);
						}
						else if(cell_at(neighbor) == 'F')
						{
							update(position);
						}
					}
				}
			break;
			default:
			break;
		}
	}

	friend std::ostream& operator<<(std::ostream& out, const Room& r)
	{
		for(const auto& row: r.map)
			out << row << std::endl;
		return out;
	}
};

int main()
{
	std::vector<std::string> map {
		{"#############/#"},
		{"#     |       #"},
		{"#     #       #"},
		{"#     #       #"},
		{"#######       #"},
		{"#     _       #"},
		{"###############"},
	};
	std::string line;
	Room room(map);
	while(getline(std::cin, line))
	{
		std::stringstream ss(line);
		Point p;
		ss >> p.x >> p.y;
		std::cout << p.x << ", " << p.y << std::endl;
		room.update(p);
		std::cout << room << std::endl;;
		std::cout << std::endl;
	}
	std::cout << room << std::endl;;
	return 0;
}
