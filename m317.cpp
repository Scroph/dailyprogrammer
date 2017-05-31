//https://www.reddit.com/r/dailyprogrammer/comments/6eerfk/20170531_challenge_317_intermediate_counting/di9v53n/
#include <iostream>
#include <vector>
#include <cctype>
#include <map>
#include <stack>

struct Molecule
{
	std::string name;
	int count;

	Molecule() : name(""), count(1) {}
	Molecule(const std::string& name) : name(name), count(1) {}
	Molecule(const std::string& name, int count) : name(name), count(count) {}
};
std::stack<Molecule> parseInput(const std::string& line);

int main()
{
	std::string line;
	while(getline(std::cin, line))
	{
		std::cout << line << std::endl;
		auto stack = parseInput(line);
		std::map<std::string, int> moleculeCount;
		while(!stack.empty())
		{
			auto molecule = stack.top();
			stack.pop();
			moleculeCount[molecule.name] += molecule.count;
		}

		for(const auto& kv: moleculeCount)
			std::cout << kv.first << " : " << kv.second << std::endl;
		std::cout << std::endl;
	}
	return 0;
}

std::stack<Molecule> parseInput(const std::string& line)
{
	std::stack<Molecule> stack;
	size_t i = 0;
	while(i < line.length() - 1)
	{
		char curr = line[i];
		char next = line[i + 1];
		if(std::isupper(curr) && std::islower(next))
		{
			if(i + 2 < line.length() && std::isdigit(line[i + 2]))
			{
				Molecule molecule;
				molecule.name += curr;
				molecule.name += next;
				std::string number;
				for(size_t j = i + 2; j < line.length() && std::isdigit(line[j]); j++)
					number += line[j];
				molecule.count = std::stoi(number);
				i += 2; //molecule name
				i += number.length(); //following number
				stack.push(molecule);
			}
			else
			{
				Molecule molecule;
				molecule.name += curr;
				molecule.name += next;
				stack.push(molecule);
				i += 2;
			}
			continue;
		}

		if(std::isupper(curr) && std::isdigit(next))
		{
			std::string number;
			for(size_t j = i + 1; j < line.length() && std::isdigit(line[j]); j++)
				number += line[j];
			std::string name;
			name += curr;
			Molecule molecule(name, std::stoi(number));
			stack.push(molecule);
			i += 1; //molecule name
			i += number.length();
			continue;
		}

		if(std::isupper(curr) && !std::isdigit(next))
		{
			Molecule molecule;
			molecule.name += curr;
			stack.push(molecule);
			i++;
			continue;
		}

		if(curr == '(')
		{
			stack.push(Molecule("(", 0));
			i++;
			continue;
		}

		if(curr == ')')
		{
			std::vector<Molecule> molecules;
			int multiple = 1;
			if(std::isdigit(next))
			{
				std::string number; //C4H8(OH)12
				for(size_t j = i + 1; j < line.length() && std::isdigit(line[j]); j++)
					number += line[j];
				multiple = std::stoi(number);
			}

			while(true)
			{
				auto molecule = stack.top();
				stack.pop();
				if(molecule.name == "(")
					break;
				molecules.push_back(molecule);
			}
			for(auto& m: molecules)
			{
				m.count *= multiple;
				stack.push(m);
			}
			i += 2;
			continue;
		}
	}
	if(std::isalpha(line.back()))
	{
		Molecule molecule;
		molecule.name += line.back();
		stack.push(molecule);
	}
	return stack;
}
