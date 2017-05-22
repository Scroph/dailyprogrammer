//https://www.reddit.com/r/dailyprogrammer/comments/6bumxo/20170518_challenge_315_intermediate_game_of_life/dhvwxj4/
#include <iostream>
#include <vector>

enum class Cell
{
	RED, BLUE, NONE
};

class GameOfLife
{
	private:
		int width;
		int height;
		std::vector<std::vector<Cell>> grid;

		void setCell(int x, int y, Cell value)
		{
			grid[y][x] = value;
		}

		Cell cellAt(int x, int y) const
		{
			if(x >= width)
				x %= width;
			if(y >= height)
				y %= height;
			if(x < 0)
				x += width;
			if(y < 0)
				y += height;
			return grid[y][x];
		}

		int countAlive(int x, int y, int& redAlive, int& blueAlive) const
		{
			blueAlive = 0;
			redAlive = 0;
			for(int j = y - 1; j <= y + 1; j++)
			{
				for(int i = x - 1; i <= x + 1; i++)
				{
					if(i == x && y == j)
						continue;
					if(cellAt(i, j) == Cell::RED)
						redAlive++;
					else if(cellAt(i, j) == Cell::BLUE)
						blueAlive++;
				}
			}
			return blueAlive + redAlive;
		}

		Cell findColor(Cell color, int redAlive, int blueAlive) const
		{
			if(color == Cell::RED)
				return redAlive + 1 > blueAlive ? Cell::RED : Cell::BLUE;
			if(color == Cell::BLUE)
				return blueAlive + 1 > redAlive ? Cell::BLUE : Cell::RED;
			throw "This cell should not be dead";
		}

	public:
		GameOfLife(std::vector<std::vector<Cell>> grid)
		{
			this->grid = grid;
			width = grid[0].size();
			height = grid.size();
		}

		void advanceSimulation()
		{
			for(int j = 0; j < height; j++)
			{
				for(int i = 0; i < width; i++)
				{
					int redAlive, blueAlive;
					int alive = countAlive(i, j, redAlive, blueAlive);
					Cell cell = cellAt(i, j);

					if(cell == Cell::NONE)
					{
						if(alive == 3)
							setCell(i, j, redAlive > blueAlive ? Cell::RED : Cell::BLUE);
					}
					else
					{

						if(alive < 2 || alive > 3)
							setCell(i, j, Cell::NONE);
						else
							setCell(i, j, findColor(cell, redAlive, blueAlive));
					}
				}
			}
		}

		void print() const
		{
			for(const auto& row: grid)
			{
				for(const auto& cell: row)
				{
					switch(cell)
					{
						case Cell::RED:     std::cout << '#'; break;
						case Cell::BLUE:    std::cout << '*'; break;
						case Cell::NONE:    std::cout << '.'; break;
					}
				}
				std::cout << std::endl;
			}
			std::cout << std::endl;
		}
};

std::ostream& operator<<(std::ostream& out, const GameOfLife& game)
{
	return out;
}

int main()
{
	int width, height, N;
	std::cin >> width >> height >> N;
	std::vector<std::vector<Cell>> grid;
	grid.reserve(height);
	std::string line;
	getline(std::cin, line);
	for(int h = 0; h < height; h++)
	{
		std::vector<Cell> row;
		row.reserve(width);
		getline(std::cin, line);
		for(int w = 0; w < width; w++)
		{
			switch(line[w])
			{
				case '#': row.push_back(Cell::RED); break;
				case '*': row.push_back(Cell::BLUE);    break;
				case '.': row.push_back(Cell::NONE);    break;
			}
		}
		grid.push_back(row);
	}
	GameOfLife game(grid);
	game.print();
	while(N--)
	{
		game.advanceSimulation();
		game.print();
	}

	return 0;
}
