//https://redd.it/784fgr
#include <iostream>
#include <cmath>

double measure_tunnel(double a, double b, double p)
{
	return std::sqrt(std::pow(a, 2) + std::pow(p, 2)) + std::sqrt(std::pow(b, 2) + std::pow(100 - p, 2));
}

double solve_river(double a, double b)
{
	double step = 0.1;
	for(double p = step; p < 100.0 - step; p += step)
	{
		auto tunnel_center	= measure_tunnel(a, b, p);
		auto tunnel_left	= measure_tunnel(a, b, p - step);
		auto tunnel_right	= measure_tunnel(a, b, p + step);

		if(tunnel_center < tunnel_left && tunnel_center < tunnel_right)
			return p;
	}
	return -1.0;
}

double calculate_area(double angle, double p)
{
	return 90 * 3.1415 * angle * p * p / std::pow(360 + 3.1415 * angle, 2);
}

double solve_sector(double length)
{
	double step = 0.1, max_angle = -1.0;
	for(double angle = step; angle < 360.0 - step; angle += step)
	{
		auto prev = calculate_area(angle - step, length);
		auto area = calculate_area(angle, length);
		auto next = calculate_area(angle + step, length);
		if(area > next && area > prev)
			return angle;
	}
	return max_angle;
}

int main()
{
	std::cout << solve_river(20.0, 30.0) << std::endl;
	std::cout << solve_sector(100.0) << std::endl;
}
