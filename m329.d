//https://redd.it/6x77p1
import core.stdc.stdio;
import core.stdc.stdlib;

extern(C) int main()
{
	int m, n, target;
	while(scanf("%d %d %d", &m, &n, &target) == 3)
	{
		int height = m < n ? m : n;
		int width = m > n ? m : n;
		handle2(width, height, target);
		//handle2(width, height, target);
	}
	return 0;
}

struct Point
{
	int r;
	int c;

	bool opEquals(Point p) const
	{
		return p.r == r && p.c == c;
	}

	bool at_destination(int target)
	{
		return r == target || c == target;
	}

	void print()
	{
		printf("(%d, %d), ", r, c);
	}
}

bool at_extremities(Point p, int width, int height)
{
	return p.r == 0 || p.c == 0 || p.r == height || p.c == width;
}

struct Vector(T)
{
	size_t capacity;
	size_t size;
	T *data;

	this(size_t initial)
	{
		capacity = initial;
		data = cast(T*) malloc(T.sizeof * capacity);
	}

	void resize()
	{
		capacity *= 2;
		T *copy = cast(T*) data.realloc(T.sizeof * capacity);
		if(copy is null)
		{
			stderr.fprintf("Not enough memory for reallocation : %d bytes required.\n", capacity);
			exit(EXIT_FAILURE);
		}
		data = copy;
	}

	ref T opIndex(int idx)
	{
		assert(idx < size, "Out of bounds error.");
		return data[idx];
	}

	size_t opDollar() const
	{
		return size;
	}

	void push_back(T e)
	{
		data[size] = e;
		if(++size == capacity)
			resize();
	}

	void opOpAssign(string op)(T e) if(op == "~")
	{
		push_back(e);
	}

	void pop_back()
	{
		if(size > 0)
			size--;
	}

	T front() const
	{
		return data[0];
	}

	T back() const
	{
		return data[size - 1];
	}

	void destroy()
	{
		free(data);
	}
}

void print(ref Vector!Point data)
{
	printf("[(%d, %d), ", data.front.c, data.front.r);
	foreach(i; 1 .. data.size - 1)
	{
		printf("(%d, %d), ", data[i].c, data[i].r);
	}
	printf("(%d, %d)]\n", data.back.c, data.back.r);
}

void handle2(int width, int height, int target)
{
	immutable up_right	= Point(1, 0);
	immutable down_right	= Point(-1, 1);
	immutable up_left	= Point(1, -1);
	immutable down_left	= Point(-1, 0);
	immutable right		= Point(0, 1);
	immutable left		= Point(0, -1);

	Point direction		= right;
	auto current		= Point(0, 0);
	auto path = Vector!Point(8);
	path ~= current;

	//printf("[");
	//printf("Width: %d, height: %d\n", width, height);
	while(true)
	{
		current.r += direction.r;
		current.c += direction.c;
		if(current.r < 0 || current.c < 0)
		{
			puts("No solution found.");
			path.destroy();
			break;
		}
		if(current.r == height && direction == up_left) //upwards to ceiling => downwards oblique
		{
			if(current.at_destination(target))
			{
				//printf("Target reached\n");
				path ~= current;
				path.print;
				path.destroy();
				//current.print;
				//printf("]\n");
				break;
			}
			direction = down_left;
			//printf("Ceiling\n");
			path ~= current;
			//current.print;
		}
		else if(current.r == 0 && direction == down_left)
		{
			if(current.at_destination(target))
			{
				//printf("Target reached\n");
				//current.print;
				path ~= current;
				path.print;
				path.destroy();
				//printf("]\n");
				break;
			}
			direction = up_left;
			//printf("Floor\n");
			path ~= current;
			//current.print;
		}
		else if(current.c == width && direction == right)
		{
			if(current.at_destination(target))
			{
				//printf("Target reached\n");
				//current.print;
				path ~= current;
				path.print;
				path.destroy();
				//printf("]\n");
				break;
			}
			direction = up_left;
			//printf("Rightmost wall\n");
			path ~= current;
			//current.print;
		}
		else if(current.c == 0 && direction == up_left)
		{
			if(current.at_destination(target))
			{
				//printf("Target reached\n");
				//current.print;
				path ~= current;
				path.print;
				path.destroy();
				//printf("]\n");
				break;
			}
			direction = right;
			//printf("Leftmost wall\n");
			path ~= current;
			//current.print;
		}
	}
}
