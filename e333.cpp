//https://redd.it/72ivih
#include <iostream>
#include <sstream>
#include <set>
#include <map>

struct Packet
{
	size_t x;
	size_t y;
	size_t z;
	std::string msg;

	Packet() {}
	Packet(size_t x, size_t y, size_t z, const std::string& msg) : x(x), y(y), z(z), msg(msg) {}

	bool operator<(const Packet& other)
	{
		if(x < other.x)
			return true;
		if(x == other.x && y < other.y)
			return true;
		return false;
	}
	friend std::ostream& operator<<(std::ostream& out, const Packet& p);
};

std::ostream& operator<<(std::ostream& out, const Packet& p)
{
	return out << p.x << "\t" << p.y << "\t" << p.z << "\t" << p.msg;
}

bool is_complete(const std::set<Packet>& msg)
{
	auto front = msg.begin();
	return msg.size() == front->z;
}

void print_msg(const std::set<Packet>& msg)
{
	for(const auto& packet: msg)
		std::cout << packet << std::endl;
}

int main()
{
	std::string line;
	std::map<int, std::set<Packet>> messages;
	while(getline(std::cin, line))
	{
		std::stringstream ss(line);
		Packet p;
		ss >> p.x >> p.y >> p.z;
		getline(ss, p.msg);
		messages[p.x].insert(p);
		auto msg = messages.find(p.x);
		if(is_complete(msg->second))
		{
			print_msg(msg->second);
			messages.erase(msg);
		}
	}
}

