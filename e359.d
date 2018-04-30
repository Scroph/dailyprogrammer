import core.stdc.stdio;
import core.stdc.string;

extern(C) void main()
{
	int cycles;
	scanf("%d", &cycles);
	foreach(c; 1 .. cycles + 1)
	{
		char[1024] sequence = "";
		sequence[].compute_sequence(c);
		sequence.ptr.puts;
	}
}

void compute_sequence(char[] sequence, int cycles)
{
	if(cycles == 0)
	{
		sequence.ptr.strcpy("1");
		return;
	}
	char[1024] previous = "110";
	foreach(it; 0 .. cycles - 1)
	{
		char[1024] current = "";
		//current.reserve(previous.length * 2 + 1);
		char[2] toggle = "1";
		foreach(c; previous[0 .. previous.ptr.strlen])
		{
			current.ptr.strcat(toggle.ptr);
			char[2] tmp;
			tmp.ptr.sprintf("%c", c);
			current.ptr.strcat(tmp.ptr);
			toggle = toggle[0] == '1' ? "0" : "1";
		}
		current.ptr.strcat(toggle.ptr);
		previous.ptr.strcpy(current.ptr);
	}
	sequence.ptr.strcpy(previous.ptr);
}
